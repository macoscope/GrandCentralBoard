//
//  Created by Krzysztof Werys on 16.05.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

public struct WidgetTemplateViewModel {
    let title: String
    let subtitle: String
    let contentView: UIView
}

public class WidgetTemplateView: UIView, ViewModelRendering {

    public typealias ViewModel = WidgetTemplateViewModel

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var contentView: UIView!

    public func configureWithTitle(title: String, subtitle: String, contentView: UIView) {
        self.contentView = contentView
    }

    // MARK - ViewModelRendering

    public private(set) var state: RenderingState<ViewModel> = .Waiting {
        didSet { handleTransitionFromState(oldValue, toState: state) }
    }

    public func render(viewModel: ViewModel) {
        state = .Rendering(viewModel)
    }

    public func failure() {
        state = .Failed
    }

    // MARK - Transitions

    private func handleTransitionFromState(state: RenderingState<ViewModel>, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
        case (.Waiting, .Rendering(let viewModel)):
            break
        case (_, .Rendering(let viewModel)):
            break
        default:
            break
        }
    }

    private func transitionFromWaitingState() {
    }

    public class func fromNib() -> WidgetTemplateView {
        return NSBundle(forClass: WidgetTemplateView.self).loadNibNamed("WidgetTemplateView", owner: nil, options: nil)[0] as! WidgetTemplateView
    }
}