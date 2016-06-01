//
//  GitHubDataProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 27.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore
import Moya
import RxSwift
import Decodable


enum GitHubTarget: TargetType {
    case Repositories
    case PullRequests(repositoryFullName: String)

    var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }

    var path: String {
        switch self {
        case .Repositories: return "/user/repos"
        case .PullRequests(let repositoryFullName): return "/repos/\(repositoryFullName)/pulls"
        }
    }

    var method: Moya.Method { return .GET }
    var parameters: [String : AnyObject]? { return nil }
    var sampleData: NSData { return NSData() }
}


protocol GitHubDataProviding {
    func repositories() -> Observable<[Repository]>
    func repositoriesWithPRsCount() -> Observable<[Repository]>
}

final class GitHubDataProvider: GitHubDataProviding {
    private let moyaProvider: RxMoyaProvider<GitHubTarget>

    init(accessToken: String, moyaProvider: RxMoyaProvider<GitHubTarget>? = nil) {
        let headers = ["Accept": "application/json", "Authorization": "token \(accessToken)"]
        self.moyaProvider = moyaProvider ?? RxMoyaProvider<GitHubTarget>.providerWithHeaders(headers)
    }

    func repositories() -> Observable<[Repository]> {
        return moyaProvider.request(.Repositories).mapDecodableArray(Repository)
    }

    private func requestPullRequestsCountForRepository(repo: Repository) -> Observable<Repository> {
        guard repo.openIssuesCount > 0 else {
            return Observable.just(repo.repositoryWithPRCount(0))
        }

        return moyaProvider.request(.PullRequests(repositoryFullName: repo.fullName)).mapJSON().map({ (object: AnyObject) -> Repository in
            guard let array = object as? NSArray else {
                assertionFailure("Object is not an array")
                return repo
            }
            return repo.repositoryWithPRCount(array.count)
        })
    }

    func repositoriesWithPRsCount() -> Observable<[Repository]> {
        return repositories().flatMap { (repos: [Repository]) -> Observable<Repository> in
                repos.toObservable().flatMap { repo -> Observable<Repository> in self.requestPullRequestsCountForRepository(repo) }
            }.toArray()
    }
}
