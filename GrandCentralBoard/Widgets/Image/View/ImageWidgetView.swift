//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

struct ImageViewModel {
    let image: UIImage
}

final class ImageWidgetView : UIView, ViewModelRendering {

    typealias ViewModel = ImageViewModel

    @IBOutlet private var image: UIImageView!
    @IBOutlet private var activity: UIActivityIndicatorView!

    // MARK - ViewModelRendering

    private(set) var state: RenderingState<ViewModel> = .Waiting {
        didSet { handleTransitionFromState(oldValue, toState: state) }
    }

    func render(viewModel: ViewModel) {
        state = .Rendering(viewModel)
    }

    func failure() {
        state = .Failed
    }

    // MARK - Transitions

    private func handleTransitionFromState(state: RenderingState<ViewModel>, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
            case (.Waiting, .Rendering(let viewModel)):
                transitionFromWaitingState()
                setUpImageWithViewModel(viewModel)
            case (.Rendering, .Rendering(let viewModel)):
                setUpImageWithViewModel(viewModel)
            default:
                break
        }
    }

    private func setUpImageWithViewModel(viewModel: ViewModel) {
        image.image = viewModel.image
    }

    private func transitionFromWaitingState() {
        UIView.animateWithDuration(0.3) {
            self.activity.alpha = 0
        }
    }

    class func fromNib() -> ImageWidgetView {
        return NSBundle.mainBundle().loadNibNamed("ImageWidgetView", owner: nil, options: nil)[0] as! ImageWidgetView
    }
}