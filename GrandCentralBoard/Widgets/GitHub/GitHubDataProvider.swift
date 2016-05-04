//
//  GitHubDataProvider.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 27.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore


protocol GitHubDataProviding {
    func requestRepositories(completion: (Result<[Repository]>) -> Void)
}

final class GitHubDataProvider: GitHubDataProviding {
    private let listRepositoriesURL = NSURL(string: "https://api.github.com/user/repos")!

    private let networkRequestManager: NetworkRequestManager
    private let accessToken: String

    init(networkRequestManager: NetworkRequestManager, accessToken: String) {
        self.networkRequestManager = networkRequestManager
        self.accessToken = accessToken
    }

    private var headers: [String: String] {
        return [
            "Authorization": "token \(accessToken)",
            "Accept": "application/json"
        ]
    }

    func requestRepositories(completion: (Result<[Repository]>) -> Void) {
        networkRequestManager.requestJSON(.GET, url: listRepositoriesURL, parameters: nil, headers: headers, encoding: .URL) { result in
            switch result {
            case .Success(let json):
                do {
                    let repositories = try [Repository].decode(json)
                    completion(.Success(repositories))
                } catch {
                    completion(.Failure(error))
                }
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
}
