//
//  Created by Oktawian Chojnacki on 22.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

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

        UIView.animateWithDuration(0.5 , delay: 0.0, options:
            [
                UIViewAnimationOptions.CurveEaseInOut,
                UIViewAnimationOptions.Autoreverse,
                UIViewAnimationOptions.Repeat,
                UIViewAnimationOptions.AllowUserInteraction
            ],
            animations: {
                self.blinkingImage.alpha = 0.5
            }, completion: { ended in })
    }

    // MARK - Transitions

    func handleTransitionFromState(state: RenderingState<ViewModel>?, toState: RenderingState<ViewModel>) {
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

    func setUpImagesWithViewModel(viewModel: ViewModel) {
        blinkingImage.setImageIfNotTheSame(viewModel.blinkingImage)
        watchFaceImage.setImageIfNotTheSame(viewModel.watchFaceImage)
    }

    func setUpLabelsWithViewModel(viewModel: ViewModel) {
        hourLeft.setTextIfNotTheSame(viewModel.hourLeft)
        hourRight.setTextIfNotTheSame(viewModel.hourRight)
    }

    private func transitionToWaitingState(waiting: Bool) {
        UIView.animateWithDuration(0.3) {
            self.hourLeft.alpha = waiting ? 0 : 1
            self.hourRight.alpha = waiting ? 0 : 1
        }
    }

    // MARK - fromNib

    class func fromNib() -> WatchWidgetView {
        return NSBundle.mainBundle().loadNibNamed("WatchWidgetView", owner: nil, options: nil)[0] as! WatchWidgetView
    }
}