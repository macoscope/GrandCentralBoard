//
//  Created by Oktawian Chojnacki on 22.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore


final class WatchWidgetView: UIView, ViewModelRendering {

    @IBOutlet private weak var watchFaceImage: UIImageView!
    @IBOutlet private weak var centeredTimeLabel: UILabel!
    @IBOutlet private weak var alignedTimeLabel: UILabel!
    @IBOutlet private weak var eventLabel: UILabel!

    private weak var failureView: UIView?

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

        watchFaceImage.image = nil
        centeredTimeLabel.text = nil
        alignedTimeLabel.text = nil
        eventLabel.attributedText = nil
    }

    // MARK - Transitions

    private func handleTransitionFromState(state: RenderingState<ViewModel>?, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
        case (_, .Rendering(let viewModel)):
            removeFailureView()
            setUpLabelsWithViewModel(viewModel)
            setUpImagesWithViewModel(viewModel)
        case (_, .Failed):
            showFailureView()
        default:
            break
        }
    }

    private func setUpImagesWithViewModel(viewModel: ViewModel) {
        watchFaceImage.image = viewModel.watchFaceImage
    }

    private func setUpLabelsWithViewModel(viewModel: ViewModel) {
        centeredTimeLabel.animateTextTransition(viewModel.centeredTimeText)
        alignedTimeLabel.animateTextTransition(viewModel.alignedTimeText)
        eventLabel.attributedText = viewModel.eventText
    }

    private func showFailureView() {
        let errorViewModel = WidgetErrorTemplateViewModel(title: "Clock & Calendar".localized.uppercaseString,
                                                          subtitle: "Error".localized.uppercaseString)
        let failureView = WidgetTemplateView.viewWithErrorViewModel(errorViewModel)
        fillViewWithView(failureView, animated: false)
    }

    private func removeFailureView() {
        failureView?.removeFromSuperview()
    }


    // MARK - fromNib

    class func fromNib() -> WatchWidgetView {
        return NSBundle.mainBundle().loadNibNamed("WatchWidgetView", owner: nil, options: nil)[0] as! WatchWidgetView
    }
}
