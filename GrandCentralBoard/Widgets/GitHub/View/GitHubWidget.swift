//
//  GitHubWidget.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 21/05/16.
//  Copyright © 2016 Michał Laskowski. All rights reserved.
//

import GCBCore
import RxSwift

extension GitHubCellViewModel: CellViewModel {}

class GitHubSource: Asynchronous {
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

final class GitHubWidget: WidgetControlling {

    private let tableView = UITableView()
    private let tableViewDataSource = GitHubTableDataSource()

    let view: UIView
    let sources: [UpdatingSource]

    init(source: GitHubSource) {
        sources = [source]

        let wrapperViewModel = WidgetTemplateViewModel(title: "GitHub".uppercaseString,
                                                       subtitle: "Pull Requests".uppercaseString,
                                                       contentView: tableView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: 36, left: 27, bottom: 36, right: 27))
        view = WidgetTemplateView.viewWithViewModel(wrapperViewModel, layoutSettings: layoutSettings)

        tableViewDataSource.setUpTableView(tableView)
    }

    func update(source: UpdatingSource) {
        if let source = source as? GitHubSource {
            updateRepositories(source)
        }
    }

    private func updateRepositories(source: GitHubSource) {
        source.read { [weak self] result in
            switch result {
            case .Success(let repos):
                self?.tableViewDataSource.items = repos.flatMap { GitHubCellViewModel(forRepository: $0) }
                self?.tableView.reloadData()
            case .Failure:
                break
            }
        }
    }
}
