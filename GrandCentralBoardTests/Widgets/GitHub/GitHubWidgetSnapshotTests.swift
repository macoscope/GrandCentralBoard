//
//  GitHubWidgetSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 22/05/16.
//

import FBSnapshotTestCase
import RxSwift
@testable import GrandCentralBoard


private final class TestGitHubDataProvider: GitHubDataProviding {
    private func repositories() -> Observable<[Repository]> {
        return Observable.just([
            Repository(name: "This should not be displayed", fullName: "", openIssuesCount: 10, pullRequestsCount: 0),
            Repository(name: "Test repository 3", fullName: "", openIssuesCount: 10, pullRequestsCount: 3),
            Repository(name: "Another repository", fullName: "", openIssuesCount: 10, pullRequestsCount: 3),
            Repository(name: "This should not be displayed too", fullName: "", openIssuesCount: 10, pullRequestsCount: 2),
            Repository(name: "Test repository with 101 open Pull Requests", fullName: "", openIssuesCount: 10, pullRequestsCount: 101)
            ])
    }

    private func repositoriesWithPRsCount() -> Observable<[Repository]> {
        return repositories()
    }
}

final class GitHubWidgetSnapshotTests: FBSnapshotTestCase {


    override func setUp() {
        super.setUp()
//        recordMode = true
    }

    func testWidget() {
        let source = GitHubSource(dataProvider: TestGitHubDataProvider(), refreshInterval: 60)
        let widget = GitHubWidget(source: source)

        widget.update(source)
        let view = widget.view
        view.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(view)
    }
}
