//
//  Created by Oktawian Chojnacki on 22.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore


private let pulsatingInterval: NSTimeInterval = 0.5
private let flashingInterval: NSTimeInterval = 0.4
private let transitionInterval: NSTimeInterval = 0.3
private let semiTransparentAlpha: CGFloat = 0.3

final class WatchWidgetView: UIView, ViewModelRendering {

    @IBOutlet private weak var hourLeft: UILabel!
    @IBOutlet private weak var hourRight: UILabel!
    @IBOutlet private weak var meetingName: UILabel!
    @IBOutlet private weak var meetingETA: UILabel!
    @IBOutlet private weak var startsIn: UILabel!
    @IBOutlet private weak var blinkingImage: UIImageView!
    @IBOutlet private weak var watchFaceImage: UIImageView!
    @IBOutlet private weak var selectionImage: UIImageView!
    @IBOutlet private weak var calendarName: UILabel!

    private var blinkingImageFlashingAnimationController: FlashingAnimationController?

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

        meetingName.text = ""
        meetingETA.text = ""
        startsIn.text = ""
        hourLeft.text = ""
        hourRight.text = ""
        calendarName.text = ""

        blinkingImageFlashingAnimationController = FlashingAnimationController(view: blinkingImage, interval: pulsatingInterval, alphaDepth: semiTransparentAlpha)
        blinkingImageFlashingAnimationController?.startFlashing()
    }

    // MARK - Transitions

    private func handleTransitionFromState(state: RenderingState<ViewModel>?, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
            case (_, .Rendering(let viewModel)):
                setUpLabelsWithViewModel(viewModel)
                setUpImagesWithViewModel(viewModel)
            default:
                break
        }
    }

    private func setUpImagesWithViewModel(viewModel: ViewModel) {
        blinkingImage.image = viewModel.blinkingImage
        watchFaceImage.image = viewModel.watchFaceImage
        selectionImage.image = viewModel.selectedImage
    }

    private func setUpLabelsWithViewModel(viewModel: ViewModel) {
        hourLeft.animateTextTransition(viewModel.hourLeft)
        hourRight.animateTextTransition(viewModel.hourRight)
        meetingName.animateTextTransition(viewModel.meetingName)
        meetingETA.animateTextTransition(viewModel.meetingETA)
        startsIn.animateTextTransition(viewModel.startsIn)
        calendarName.animateTextTransition(viewModel.calendarName)
    }


    // MARK - fromNib

    class func fromNib() -> WatchWidgetView {
        return NSBundle.mainBundle().loadNibNamed("WatchWidgetView", owner: nil, options: nil)[0] as! WatchWidgetView
    }
}
