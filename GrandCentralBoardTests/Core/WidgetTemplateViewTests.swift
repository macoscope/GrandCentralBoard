//
//  Created by Krzysztof Werys on 18/05/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//


import FBSnapshotTestCase
@testable import GCBCore

final class CircleChartViewTests: FBSnapshotTestCase {

    private static func buildViewModel() -> WidgetTemplateViewModel {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 640, height: 540))
        contentView.backgroundColor = UIColor.redColor()
        return WidgetTemplateViewModel(title: "TITLE", subtitle: "SUBTITLE", contentView: contentView)
    }

    func testDefaultLayout() {
        let viewModel = CircleChartViewTests.buildViewModel()
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero)
        let view = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        FBSnapshotVerifyView(view)
    }

    func testDisplayingContentUnderHeader() {
        let viewModel = CircleChartViewTests.buildViewModel()
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero, displayContentUnderHeader: true)
        let view = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        FBSnapshotVerifyView(view)
    }

    func testContentViewMargin() {
        let viewModel = CircleChartViewTests.buildViewModel()
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        let view = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        FBSnapshotVerifyView(view)
    }
}
