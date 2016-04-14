//
//  Created by Oktawian Chojnacki on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore


private let FirstScaleLineHeight: CGFloat = 12
private let NormalScaleLineHeight: CGFloat = 4
private let LastScaleLineHeight: CGFloat = 32

final class AreaBarHorizontalAxisStackView : UIStackView {

    override func awakeFromNib() {
        super.awakeFromNib()

        axis = .Horizontal
        distribution = .EqualSpacing
        alignment = .Top
    }

    func drawAxisWithViewModel(viewModel: AreaBarChartViewModel) {

        let stops = viewModel.horizontalAxisStops

        for stop in 0...stops {

            let scaleLineView = UIView()
            scaleLineView.backgroundColor = UIColor.axisGray()

            addArrangedSubview(scaleLineView)

            let height = scaleLineHeightForStop(stop, stops: stops)
            scaleLineView.heightAnchor.constraintEqualToConstant(height).active = true

            scaleLineView.widthAnchor.constraintEqualToConstant(1).active = true
        }
    }

    private func scaleLineHeightForStop(stop: Int, stops: Int) -> CGFloat {
        switch stop {
        case 0:
            return FirstScaleLineHeight
        case stops:
            return LastScaleLineHeight
        default:
            return NormalScaleLineHeight
        }
    }
}

final class AreaBarChartView : UIView, ViewModelRendering {
    typealias ViewModel = AreaBarChartViewModel

    @IBOutlet private var barStackView: AreaBarStackView!
    @IBOutlet private var axisStackView: AreaBarHorizontalAxisStackView!

    @IBOutlet private var horizontalAxisLabel: UILabel!
    @IBOutlet private var hotizontalAxisCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: ViewModelRendering

    private(set) var state: RenderingState<ViewModel> = .Waiting {
        didSet { handleTransitionFromState(oldValue, toState: state) }
    }

    func render(viewModel: ViewModel) {
        state = .Rendering(viewModel)
    }

    func failure() {
        state = .Failed
    }

    // MARK: - Transitions

    private func handleTransitionFromState(state: RenderingState<ViewModel>, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
        case (_, .Rendering(let viewModel)):
            configureBarsWithViewModel(viewModel)
            configureLabelsWithViewModel(viewModel)
            configureAxisWithViewModel(viewModel)
        default:
            break
        }
    }

    // MARK: -

    private func configureLabelsWithViewModel(viewModel: AreaBarChartViewModel) {
        horizontalAxisLabel.text = viewModel.horizontalAxisLabelText
        hotizontalAxisCountLabel.text = viewModel.hotizontalAxisCountLabelText
    }

    private func configureBarsWithViewModel(viewModel: AreaBarChartViewModel) {
        viewModel.barItems.forEach { itemViewModel in
            let barView = barStackView.addBarWithItemViewModel(itemViewModel)
            addLineWithLabelToBarView(barView, withViewModel: itemViewModel)
        }

        bringSubviewToFront(barStackView)
    }

    private func addLineWithLabelToBarView(barView: UIView, withViewModel viewModel: AreaBarItemViewModel) {
        let dashedLine = AreaBarDashedLineWithLabel.fromNib()
        dashedLine.configureWithViewModel(viewModel)
        addSubview(dashedLine)
        setUpConstraintsOfDashedLine(dashedLine, toBar: barView)
    }

    private func setUpConstraintsOfDashedLine(dashedLine: UIView, toBar bar: UIView) {
        dashedLine.heightAnchor.constraintEqualToConstant(20).active = true
        dashedLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dashedLine, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 32).active = true
        NSLayoutConstraint(item: dashedLine, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -32).active = true
        NSLayoutConstraint(item: dashedLine, attribute: .Bottom, relatedBy: .Equal, toItem: bar, attribute: .Top, multiplier: 1.0, constant: 2).active = true
    }

    private func configureAxisWithViewModel(viewModel: AreaBarChartViewModel) {
        axisStackView.drawAxisWithViewModel(viewModel)
    }

    // MARK - fromNib

    class func fromNib() -> AreaBarChartView {
        return NSBundle.mainBundle().loadNibNamed("AreaBarChartView", owner: nil, options: nil)[0] as! AreaBarChartView
    }
}
