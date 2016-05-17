//
//  Created by Krzysztof Werys on 16.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

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

public class WidgetTemplateView: UIView {

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var contentViewContainer: UIView!

    public func configureWithViewModel(viewModel: WidgetTemplateViewModel) {
        contentViewContainer.addSubview(viewModel.contentView)
        viewModel.contentView.frame = contentViewContainer.bounds
        contentViewContainer.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }

    public class func fromNib() -> WidgetTemplateView {
        return NSBundle(forClass: WidgetTemplateView.self).loadNibNamed("WidgetTemplateView", owner: nil, options: nil)[0] as! WidgetTemplateView
    }
}