//
//  GitHubSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 22/05/16.
//  Copyright © 2016 Michał Laskowski. All rights reserved.
//

import RxSwift
import GCBCore


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
            case .Next(let repositories): closure(.Success(repositories))
            case .Completed: break
            }
            }.addDisposableTo(disposeBag)
    }
}
