//
//  Created by Krzysztof Werys on 16.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit


public protocol WidgetTemplateViewModelType {
    var title: String { get }
    var subtitle: String { get }
    var contentView: UIView { get }
}

/**
 This viewModel is used to configure a template view for displaying widget content.
 */
public struct WidgetTemplateViewModel: WidgetTemplateViewModelType {
    public let title: String
    public let subtitle: String
    public let contentView: UIView

    /**
     Initialize the `WidgetErrorTemplateViewModel`.
     
     - parameter title:       title displayed in header
     - parameter subtitle:    subtitle displayed in header
     - parameter contentView: widget content
     
     */
    public init(title: String, subtitle: String, contentView: UIView) {
        self.title = title
        self.subtitle = subtitle
        self.contentView = contentView
    }
}

/**
 This viewModel is used to configure a template view for displaying widget error.
 */
public struct WidgetErrorTemplateViewModel: WidgetTemplateViewModelType {
    public let title: String
    public let subtitle: String
    public let contentView: UIView
    
    /**
     Initialize the `WidgetErrorTemplateViewModel`.
     
     - parameter title:     title displayed in header
     - parameter subtitle:  subtitle displayed in header
     - parameter iconImage: optional image for icon (if set, it gets centered below the header)
     
     */
    public init(title: String,
                subtitle: String,
                iconImage: UIImage? = UIImage(named: "gcb-error-icon", inBundle: NSBundle.resourcesBundle(), compatibleWithTraitCollection: nil)){
        self.title = title
        self.subtitle = subtitle
        let imageView = UIImageView(image: iconImage)
        imageView.contentMode = .Center
        self.contentView = imageView
    }
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

    @IBOutlet private var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet private var containerTopToHeaderBottomConstraint: NSLayoutConstraint!

    private var contentView: UIView?
    private(set) var currentLayoutSettings: WidgetTemplateLayoutSettings?
    static let defaultLayoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero, displayContentUnderHeader: false)

    public class func viewWithViewModel(viewModel: WidgetTemplateViewModelType, layoutSettings: WidgetTemplateLayoutSettings) -> WidgetTemplateView {
        let view = WidgetTemplateView.fromNib()
        view.configureWithViewModel(viewModel, layoutSettings: layoutSettings)
        return view
    }
    
    public class func viewWithErrorViewModel(viewModel: WidgetErrorTemplateViewModel) -> WidgetTemplateView {
        return viewWithViewModel(viewModel, layoutSettings: defaultLayoutSettings)
    }

    public func configureWithViewModel(viewModel: WidgetTemplateViewModelType, layoutSettings: WidgetTemplateLayoutSettings? = nil) {
        let layoutSettings = (layoutSettings ?? currentLayoutSettings) ?? self.dynamicType.defaultLayoutSettings
        
        contentView = viewModel.contentView
        configureContentView(viewModel.contentView)
        configureTitle(viewModel.title)
        configureSubtitle(viewModel.subtitle)
        configureLayoutSettings(layoutSettings)
    }

    public func configureLayoutSettings(layoutSettings: WidgetTemplateLayoutSettings) {
        if layoutSettings.displayContentUnderHeader {
            containerTopToHeaderBottomConstraint.active = false
            containerTopConstraint.active = true
        } else {
            containerTopToHeaderBottomConstraint.active = true
            containerTopConstraint.active = false
        }
        currentLayoutSettings = layoutSettings

        guard let contentView = contentView else { return }
        contentView.frame = UIEdgeInsetsInsetRect(contentViewContainer.bounds, layoutSettings.contentMargin)
        contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        setNeedsLayout()
    }

    private func configureContentView(contentView: UIView) {
        contentViewContainer.subviews.forEach { $0.removeFromSuperview() }
        contentViewContainer.addSubview(contentView)
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