//
//  Created by Krzysztof Werys on 16.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit

/**
 This viewModel is used to configure a template view for widgets: `WidgetTemplateView`
 */
public struct WidgetTemplateViewModel {
    let title: String
    let subtitle: String
    let contentView: UIView
}

/**
 Struct which is used to configure layout of a template view for widgets.
 */
public struct WidgetTemplateLayoutSettings {
    let contentMargin: UIEdgeInsets
    let displayContentUnderHeader: Bool

    public init(contentMargin: UIEdgeInsets, displayContentUnderHeader: Bool = false) {
        self.contentMargin = contentMargin
        self.displayContentUnderHeader = displayContentUnderHeader
    }
}

/**
 This is template view for a widget which contains a header and a content.
 */
public class WidgetTemplateView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var contentViewContainer: UIView!

    @IBOutlet private weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerTopToHeaderBottomConstraint: NSLayoutConstraint!

    private var contentView: UIView?

    public class func viewWithViewModel(viewModel: WidgetTemplateViewModel, layoutSettings: WidgetTemplateLayoutSettings) -> WidgetTemplateView {
        let view = WidgetTemplateView.fromNib()
        view.configureWithViewModel(viewModel)
        view.configureLayoutSettings(layoutSettings)
        return view
    }

    private func configureWithViewModel(viewModel: WidgetTemplateViewModel) {
        contentView = viewModel.contentView
        configureContenView(viewModel.contentView)
        configureTitle(viewModel.title)
        configureSubtitle(viewModel.subtitle)
    }

    private func configureLayoutSettings(layoutSettings: WidgetTemplateLayoutSettings) {
        if layoutSettings.displayContentUnderHeader {
            containerTopToHeaderBottomConstraint.active = false
            containerTopConstraint.active = true
        } else {
            containerTopToHeaderBottomConstraint.active = true
            containerTopConstraint.active = false
        }

        guard let contentView = contentView else { return }
        contentView.bounds = UIEdgeInsetsInsetRect(contentView.frame, layoutSettings.contentMargin)
    }

    private func configureContenView(contentView: UIView) {
        contentViewContainer.addSubview(contentView)
        contentView.frame = contentViewContainer.bounds
        contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }

    private func configureTitle(title: String) {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.gcb_greenColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(30, weight: UIFontWeightRegular),
            NSKernAttributeName : 4.0
        ]
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
        titleLabel.attributedText = attributedString
    }

    private func configureSubtitle(subtitle: String) {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.gcb_whitetextColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(20, weight: UIFontWeightRegular),
            NSKernAttributeName : 2.9
        ]
        let attributedString = NSMutableAttributedString(string: subtitle, attributes: attributes)
        descriptionLabel.attributedText = attributedString
    }

    public class func fromNib() -> WidgetTemplateView {
        return NSBundle(forClass: WidgetTemplateView.self).loadNibNamed("WidgetTemplateView", owner: nil, options: nil)[0] as! WidgetTemplateView
    }
}