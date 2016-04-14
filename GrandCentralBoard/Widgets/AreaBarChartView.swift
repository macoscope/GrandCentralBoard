//
//  Created by Oktawian Chojnacki on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore


private let FirstScaleLineHeight: CGFloat = 12
private let NormalScaleLineHeight: CGFloat = 4
private let LastScaleLineHeight: CGFloat = 32


final class AreaBarDashedLineWithLabel : UIView {

    @IBOutlet private var valueLabel: UILabel!

    func configureWithViewModel(viewModel: AreaBarItemViewModel) {
        switch viewModel.valueLabelMode {
        case .Hidden:
            valueLabel.hidden = true
        case .Left(let text):
            valueLabel.hidden = false
            valueLabel.text = text
            valueLabel.textAlignment = .Left
        case .Right(let text):
            valueLabel.hidden = false
            valueLabel.text = text
            valueLabel.textAlignment = .Right
        }
    }

    // MARK - fromNib

    class func fromNib() -> AreaBarDashedLineWithLabel {
        return NSBundle.mainBundle().loadNibNamed("AreaBarDashedLineWithLabel", owner: nil, options: nil)[0] as! AreaBarDashedLineWithLabel
    }
}

final class AreaBarHorizontalAxisStackView : UIStackView {

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
    typealias ViewModel = WatchWidgetViewModel //AreaBarChartViewModel

    @IBOutlet private var barStackView: AreaBarStackView!
    @IBOutlet private var axisStackView: AreaBarHorizontalAxisStackView!

    @IBOutlet private var horizontalAxisLabel: UILabel!
    @IBOutlet private var hotizontalAxisCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        axisStackView.axis = .Horizontal
        axisStackView.distribution = .EqualSpacing
        axisStackView.alignment = .Top
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
        case (.Waiting, .Rendering):

            let items = [AreaBarItemViewModel(proportionalWidth: 0.5, proportionalHeight: 0.2, color: UIColor.lipstick(), valueLabelMode: .Left(text: "123")), AreaBarItemViewModel(proportionalWidth: 0.25, proportionalHeight: 0.5, color: UIColor.aquaMarine(), valueLabelMode: .Hidden), AreaBarItemViewModel(proportionalWidth: 0.25, proportionalHeight: 1, color: UIColor.almostWhite(), valueLabelMode: .Right(text: "222"))]
            let model = AreaBarChartViewModel(barItems: items, horizontalAxisStops: 20, horizontalAxisLabelText: "people billing:", hotizontalAxisCountLabelText: "666")

            configureBarsWithViewModel(model)
            configureLabelsWithViewModel(model)
            configureAxisWithViewModel(model)
            configureValueLabelsWithViewModel(model)
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
        viewModel.barItems.forEach { bar in
            barStackView.addBar(bar)
        }
    }

    private func configureValueLabelsWithViewModel(viewModel: AreaBarChartViewModel) {
        viewModel.barItems.forEach { bar in
            let dashedLine = AreaBarDashedLineWithLabel.fromNib()
            addSubview(dashedLine)
            dashedLine.heightAnchor.constraintEqualToConstant(20).active = true
            dashedLine.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
            dashedLine.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
            dashedLine.topAnchor.constraintEqualToAnchor(topAnchor).active = true
            dashedLine.configureWithViewModel(bar)
        }
    }

    private func configureAxisWithViewModel(viewModel: AreaBarChartViewModel) {
        axisStackView.drawAxisWithViewModel(viewModel)
    }

    // MARK - fromNib

    class func fromNib() -> AreaBarChartView {
        return NSBundle.mainBundle().loadNibNamed("AreaBarChartView", owner: nil, options: nil)[0] as! AreaBarChartView
    }
}
