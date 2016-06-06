//
//  AnalogClockWidgetView.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/25/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore
import BEMAnalogClock

final class AnalogClockWidgetView: UIView, ViewModelRendering {
    @IBOutlet weak var analogClockView: BEMAnalogClockView!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    typealias ViewModel = AnalogClockWidgetViewModel

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
        case (_, .Rendering(let viewModel)):
            updateLabelsWithViewModel(viewModel)
            updateAnalogClockWithViewModel(viewModel)
        default:
            break
        }
    }

    private func updateLabelsWithViewModel(viewModel: ViewModel) {
        dateLabel.text = viewModel.dateString
        timeZoneLabel.text = viewModel.timeZoneCityName
    }

    private func updateAnalogClockWithViewModel(viewModel: ViewModel) {
        analogClockView.hours = viewModel.hour
        analogClockView.minutes = viewModel.minute
        analogClockView.seconds = viewModel.second
        analogClockView.updateTimeAnimated(false)
    }




    // MARK - fromNib

    class func fromNib() -> AnalogClockWidgetView {
        return NSBundle.mainBundle().loadNibNamed("AnalogClockWidgetView", owner: nil, options: nil)[0] as! AnalogClockWidgetView
    }
}
