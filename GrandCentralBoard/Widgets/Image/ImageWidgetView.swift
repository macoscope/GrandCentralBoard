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

    // MARK - Initial state

    override func awakeFromNib() {
        super.awakeFromNib()
        handleTransitionFromState(.Waiting, toState: .Waiting)
    }

    // MARK - Transitions

    func handleTransitionFromState(state: RenderingState<ViewModel>, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
        case (_, .Rendering(let viewModel)):
            transitionToWaitingState(false)
            setUpImageWithViewModel(viewModel)
        case (_, .Failed):
            // TODO: Failed appearance
            break
        case (_, .Waiting):
            transitionToWaitingState(true)
        }
    }

    func setUpImageWithViewModel(viewModel: ViewModel) {
        image.image = viewModel.image
    }

    private func transitionToWaitingState(waiting: Bool) {
        UIView.animateWithDuration(0.3) {
            self.activity.alpha = waiting ? 1 : 0
            self.image.alpha = waiting ? 0 : 1
        }
    }

    class func fromNib() -> ImageWidgetView {
        return NSBundle.mainBundle().loadNibNamed("ImageWidgetView", owner: nil, options: nil)[0] as! ImageWidgetView
    }
}