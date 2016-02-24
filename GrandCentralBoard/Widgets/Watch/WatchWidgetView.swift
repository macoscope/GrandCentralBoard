//
//  Created by Oktawian Chojnacki on 22.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

final class WatchWidgetView : UIView, ViewModelRendering {

    @IBOutlet private var time: UILabel!
    @IBOutlet private var timezone: UILabel!
    @IBOutlet private var day: UILabel!
    @IBOutlet private var month: UILabel!

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
        handleTransitionFromState(.Waiting, toState: .Waiting)
    }

    // MARK - Transitions

    func handleTransitionFromState(state: RenderingState<ViewModel>, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
            case (_, .Rendering(let viewModel)):
                transitionToWaitingState(false)
                setUpLabelsWithViewModel(viewModel)
            case (_, .Failed):
                // No failed appearance
                break
            case (_, .Waiting):
                transitionToWaitingState(true)
        }
    }

    func setUpLabelsWithViewModel(viewModel: ViewModel) {
        time.setTextIfNotTheSame(viewModel.time)
        timezone.setTextIfNotTheSame(viewModel.timeZone)
        day.setTextIfNotTheSame(viewModel.day)
        month.setTextIfNotTheSame(viewModel.month)
    }

    private func transitionToWaitingState(waiting: Bool) {
        UIView.animateWithDuration(0.3) {
            self.time.alpha = waiting ? 0 : 1
            self.timezone.alpha = waiting ? 0 : 1
            self.day.alpha = waiting ? 0 : 1
            self.month.alpha = waiting ? 0 : 1
        }
    }

    // MARK - fromNib

    class func fromNib() -> WatchWidgetView {
        return NSBundle.mainBundle().loadNibNamed("WatchWidgetView", owner: nil, options: nil)[0] as! WatchWidgetView
    }
}