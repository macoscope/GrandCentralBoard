//
//  Created by Oktawian Chojnacki on 22.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

private let pulsatingInterval: NSTimeInterval = 0.5
private let transitionInterval: NSTimeInterval = 0.3
private let semiTransparentAlpha: CGFloat = 0.5

final class WatchWidgetView : UIView, ViewModelRendering {

    @IBOutlet private weak var hourLeft: UILabel!
    @IBOutlet private weak var hourRight: UILabel!
    @IBOutlet private weak var blinkingImage: UIImageView!
    @IBOutlet private weak var watchFaceImage: UIImageView!

    // MARK - ViewModelRendering

    typealias ViewModel = WatchWidgetViewModel

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
        handleTransitionFromState(nil, toState: .Waiting)

        UIView.animateWithDuration(pulsatingInterval, delay: 0.0, options:
            [
                .CurveEaseInOut,
                .Autoreverse,
                .Repeat,
                .AllowUserInteraction
            ],
            animations: {
                self.blinkingImage.alpha = semiTransparentAlpha
            }, completion: nil)
    }

    // MARK - Transitions

    private func handleTransitionFromState(state: RenderingState<ViewModel>?, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
            case (_, .Rendering(let viewModel)):
                transitionToWaitingState(false)
                setUpLabelsWithViewModel(viewModel)
                setUpImagesWithViewModel(viewModel)
            case (_, .Failed):
                // No failed appearance
                break
            case (_, .Waiting):
                transitionToWaitingState(true)
        }
    }

    private func setUpImagesWithViewModel(viewModel: ViewModel) {
        blinkingImage.image = viewModel.blinkingImage
        watchFaceImage.image = viewModel.watchFaceImage
    }

    private func setUpLabelsWithViewModel(viewModel: ViewModel) {
        hourLeft.animateTextTransition(viewModel.hourLeft)
        hourRight.animateTextTransition(viewModel.hourRight)
    }

    private func transitionToWaitingState(waiting: Bool) {
        UIView.animateWithDuration(transitionInterval) {
            self.hourLeft.alpha = waiting ? 0 : 1
            self.hourRight.alpha = waiting ? 0 : 1
        }
    }

    // MARK - fromNib

    class func fromNib() -> WatchWidgetView {
        return NSBundle.mainBundle().loadNibNamed("WatchWidgetView", owner: nil, options: nil)[0] as! WatchWidgetView
    }
}