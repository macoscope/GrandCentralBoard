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

    private let data: [Repository]
    private let shouldFail: Bool

    init(data: [Repository], shouldFail: Bool) {
        self.data = data
        self.shouldFail = shouldFail
    }

    private func repositories() -> Observable<[Repository]> {
        if shouldFail { return Observable.error(TestError()) }
        return Observable.just(data)
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

    func testWidgetWithData() {
        let data = [
            Repository(name: "This should not be displayed", fullName: "", openIssuesCount: 10, pullRequestsCount: 0),
            Repository(name: "Test repository 3", fullName: "", openIssuesCount: 10, pullRequestsCount: 3),
            Repository(name: "Another repository", fullName: "", openIssuesCount: 10, pullRequestsCount: 3),
            Repository(name: "This should not be displayed too", fullName: "", openIssuesCount: 10, pullRequestsCount: 2),
            Repository(name: "Test repository with 101 open Pull Requests", fullName: "", openIssuesCount: 10, pullRequestsCount: 101)
        ]
        let dataProvider = TestGitHubDataProvider(data: data, shouldFail: false)
        let source = GitHubSource(dataProvider: dataProvider, refreshInterval: 60)
        let widget = GitHubWidget(source: source)

        widget.update(source)
        let view = widget.view
        view.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(view)
    }

    func testWidgetWithNoOpenPRs() {
        let data = [
            Repository(name: "This should not be displayed", fullName: "", openIssuesCount: 10, pullRequestsCount: 0),
            Repository(name: "Another repository with 0 PR", fullName: "", openIssuesCount: 10, pullRequestsCount: 0),
            Repository(name: "This should not be displayed too", fullName: "", openIssuesCount: 10, pullRequestsCount: 0),
            Repository(name: "Test repository with 0 open Pull Requests", fullName: "", openIssuesCount: 10, pullRequestsCount: 0)
        ]
        let dataProvider = TestGitHubDataProvider(data: data, shouldFail: false)
        let source = GitHubSource(dataProvider: dataProvider, refreshInterval: 60)
        let widget = GitHubWidget(source: source)

        widget.update(source)
        let view = widget.view
        view.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(view)
    }

    func testWidgetWithError() {
        let dataProvider = TestGitHubDataProvider(data: [], shouldFail: true)
        let source = GitHubSource(dataProvider: dataProvider, refreshInterval: 60)
        let widget = GitHubWidget(source: source)

        widget.update(source)
        let view = widget.view
        view.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(view)
    }

    func testWidgetWithNoDataReturned() {
        let dataProvider = TestGitHubDataProvider(data: [], shouldFail: false)
        let source = GitHubSource(dataProvider: dataProvider, refreshInterval: 60)
        let widget = GitHubWidget(source: source)

        widget.update(source)
        let view = widget.view
        view.frame = CGRect(x: 0, y: 0, width: 640, height: 540)

        FBSnapshotVerifyView(view)
    }
}
