//
//  clockView.swift
//  GrandCentralBoard
//
//  Created by Joel Fischer on 4/22/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore

final class DigitalClockWidgetView: UIView, ViewModelRendering {
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!

    typealias ViewModel = DigitalClockWidgetViewModel

    private var useMilitaryTime: Bool = false
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

    private func handleTransitionFromState(state: RenderingState<ViewModel>?, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
        case (_, .Rendering(let viewModel)):
            updateLabelsWithViewModel(viewModel)
        default:
            break
        }
    }

    private func updateLabelsWithViewModel(viewModel: ViewModel) {
        clockLabel.text = viewModel.timeString
        timeZoneLabel.text = viewModel.timeZoneCityName
    }


    // MARK - fromNib

    class func fromNib() -> DigitalClockWidgetView {
        return NSBundle.mainBundle().loadNibNamed("DigitalClockWidgetView", owner: nil, options: nil)[0] as! DigitalClockWidgetView
    }
}
