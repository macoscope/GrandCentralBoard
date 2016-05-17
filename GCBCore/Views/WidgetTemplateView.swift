//
//  Created by Krzysztof Werys on 16.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

/**
 This viewModel is used to configure a template view for widgets: `WidgetTemplateView`
 */
public struct WidgetTemplateViewModel {
    let title: String
    let subtitle: String
    let contentView: UIView

    public init(title: String, subtitle: String, contentView: UIView) {
        self.title = title
        self.subtitle = subtitle
        self.contentView = contentView
    }
}

/**
 Struct which is used to configure layout of a template view for widgets.
 */
public struct WidgetTemplateLayoutSettings {
    let displayContentUnderHeader: Bool
    let contentMargin: UIEdgeInsets

    public init(displayContentUnderHeader: Bool = false, contentMargin: UIEdgeInsets) {
        self.displayContentUnderHeader = displayContentUnderHeader
        self.contentMargin = contentMargin
    }
}

/**
 This is template view for a widget which contains a header and a content.
 */
public class WidgetTemplateView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var contentViewContainer: UIView!

    @IBOutlet private weak var containerTopConstraint: NSLayoutConstraint!

    public func configureWithViewModel(viewModel: WidgetTemplateViewModel) {
        configureContenView(viewModel.contentView)
        configureTitle(viewModel.title)
        configureSubtitle(viewModel.subtitle)
    }

    public func configureLayoutSettings(layoutSettings: WidgetTemplateLayoutSettings) {
        if layoutSettings.displayContentUnderHeader {
            containerTopConstraint.constant = 0
        } else {
            containerTopConstraint.constant = headerView.frame.height
        }

        contentViewContainer.bounds = UIEdgeInsetsInsetRect(contentViewContainer.frame, layoutSettings.contentMargin)
    }

    private func configureContenView(contentView: UIView) {
        contentViewContainer.addSubview(contentView)
        contentView.frame = contentViewContainer.bounds
        contentViewContainer.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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