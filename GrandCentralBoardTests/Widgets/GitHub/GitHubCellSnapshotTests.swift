//
//  GitHubCellSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 21/05/16.
//

import FBSnapshotTestCase
@testable import GrandCentralBoard


final class GitHubCellSnapshotTests: FBSnapshotTestCase {

    private var view: GitHubCell!

    override func setUp() {
        super.setUp()
        view = GitHubCell.fromNib()
        view.frame = CGRect(x: 0, y: 0, width: 640, height: 106)
        view.backgroundColor = .blackColor()

//        recordMode = true
    }

    func testGitHubCellWithCount100() {
        let viewModel = GitHubCellViewModel(countLabelText: "100",
                                            nameLabelText: "Some repo name".uppercaseString,
                                            color: .redColor())
        view.configureWithViewModel(viewModel)
        FBSnapshotVerifyView(view)
    }

    func testGitHubCellWithCount5() {
        let viewModel = GitHubCellViewModel(countLabelText: "5",
                                            nameLabelText: "Some repo name".uppercaseString,
                                            color: .orangeColor())
        view.configureWithViewModel(viewModel)
        FBSnapshotVerifyView(view)
    }

    func testGitHubCellWithCount0AndLongName() {
        let viewModel = GitHubCellViewModel(countLabelText: "0",
                                            nameLabelText: "Some repo name name name name name name name name name name name name ".uppercaseString,
                                            color: .greenColor())
        view.configureWithViewModel(viewModel)
        FBSnapshotVerifyView(view)
    }
}
