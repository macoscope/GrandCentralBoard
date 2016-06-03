//
//  Created by Krzysztof Werys on 18/05/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//


import FBSnapshotTestCase
import GCBCore

final class WidgetTemplateViewTests: FBSnapshotTestCase {

    let title = "TITLE"
    let subtitle = "SUBTITLE"

    let errorTitle = "WIDGET NAME"
    let errorSubtitle = "ERROR REASON"

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    private func contentView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 640, height: 540))
        view.backgroundColor = UIColor.redColor()
        return view
    }

    func testDefaultLayout() {
        let viewModel = WidgetTemplateViewModel(title: title, subtitle: subtitle, contentView: contentView())
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero)
        let view = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        FBSnapshotVerifyView(view)
    }

    func testDisplayingContentUnderHeader() {
        let viewModel = WidgetTemplateViewModel(title: title, subtitle: subtitle, contentView: contentView())
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero, displayContentUnderHeader: true)
        let view = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        FBSnapshotVerifyView(view)
    }

    func testContentViewMargin() {
        let viewModel = WidgetTemplateViewModel(title: title, subtitle: subtitle, contentView: contentView())
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        let view = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        FBSnapshotVerifyView(view)
    }

    func testMixedContentViewMargin() {
        let viewModel = WidgetTemplateViewModel(title: title, subtitle: subtitle, contentView: contentView())
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: 0, left: 30, bottom: 60, right: 90))
        let view = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)

        FBSnapshotVerifyView(view)
    }

    func testConfigureForErrorWithoutIcon() {
        let viewModel = WidgetErrorTemplateViewModel(title: errorTitle, subtitle: errorSubtitle, iconImage: nil)
        let view = WidgetTemplateView.viewWithErrorViewModel(viewModel)

        FBSnapshotVerifyView(view)
    }

    func testConfigureForErrorWithDefaultIcon() {
        let viewModel = WidgetErrorTemplateViewModel(title: errorTitle, subtitle: errorSubtitle)
        let view = WidgetTemplateView.viewWithErrorViewModel(viewModel)

        FBSnapshotVerifyView(view)
    }

    func testConfigureMultipleTimes() {
        let viewModel = WidgetErrorTemplateViewModel(title: errorTitle, subtitle: errorSubtitle)
        let view = WidgetTemplateView.viewWithErrorViewModel(viewModel)

        let newViewModel = WidgetErrorTemplateViewModel(title: "Some different title", subtitle: "This is a totally different subtitle")
        view.configureWithViewModel(newViewModel)

        FBSnapshotVerifyView(view)
    }


    func testConfigureLayoutMultipleTimes() {
        let viewModel = WidgetErrorTemplateViewModel(title: errorTitle, subtitle: errorSubtitle)
        let view = WidgetTemplateView.viewWithErrorViewModel(viewModel)

        let newContentView = UILabel()
        newContentView.text = "Background of this should be shown under the header with 10px top margin."
        newContentView.font = UIFont.systemFontOfSize(60)
        newContentView.backgroundColor = .grayColor()
        newContentView.numberOfLines = 0

        let newViewModel = WidgetTemplateViewModel(title: "Some different title",
                                                   subtitle: "This is a totally different subtitle",
                                                   contentView: newContentView)
        view.configureWithViewModel(newViewModel)

        let newLayout = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: 10, left: 60, bottom: 60, right: 60),
                                                     displayContentUnderHeader: true)
        view.configureLayoutSettings(newLayout)
        FBSnapshotVerifyView(view)
    }
}
