//
//  GitHubSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 22/05/16.
//  Copyright © 2016 Michał Laskowski. All rights reserved.
//

import RxSwift
import GCBCore


private extension CollectionType where Generator.Element == Repository {

    func filterAndSortByPRCountAndName() -> [Repository] {
        return filter { $0.pullRequestsCount > 0 }.sort({ (left, right) -> Bool in
            if left.pullRequestsCount == right.pullRequestsCount {
                return left.name < right.name
            }
            return left.pullRequestsCount > right.pullRequestsCount
        })
    }
}

final class GitHubSource: Asynchronous {
    typealias ResultType = Result<[Repository]>
    let sourceType: SourceType = .Momentary

    private let disposeBag = DisposeBag()
    private let dataProvider: GitHubDataProviding
    let interval: NSTimeInterval

    init(dataProvider: GitHubDataProviding, refreshInterval: NSTimeInterval) {
        self.dataProvider = dataProvider
        interval = refreshInterval
    }

    func read(closure: (ResultType) -> Void) {
        dataProvider.repositoriesWithPRsCount().single().subscribe { (event) in
            switch event {
            case .Error(let error): closure(.Failure(error))
            case .Next(let repositories): closure(.Success(repositories.filterAndSortByPRCountAndName()))
            case .Completed: break
            }
            }.addDisposableTo(disposeBag)
    }
}
