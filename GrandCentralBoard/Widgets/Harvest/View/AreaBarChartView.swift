//
//  Created by Oktawian Chojnacki on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore
import GCBUtilities


private let firstScaleLineHeight: CGFloat = 12
private let normalScaleLineHeight: CGFloat = 4
private let lastScaleLineHeight: CGFloat = 32

final class AreaBarHorizontalAxisStackView: UIStackView {

    override func awakeFromNib() {
        super.awakeFromNib()

        axis = .Horizontal
        distribution = .EqualSpacing
        alignment = .Top
    }

    func drawAxisWithViewModel(viewModel: AreaBarChartViewModel) {

        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }

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
            return firstScaleLineHeight
        case stops:
            return lastScaleLineHeight
        default:
            return normalScaleLineHeight
        }
    }
}

final class AreaBarChartView: UIView, ViewModelRendering {
    typealias ViewModel = AreaBarChartViewModel

    @IBOutlet private var barStackView: AreaBarStackView!
    @IBOutlet private var axisStackView: AreaBarHorizontalAxisStackView!
    @IBOutlet private var componentChartsStackView: UIStackView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var informationSheet: UIView!
    @IBOutlet private var errorImageView: UIView!
    @IBOutlet private var centerLabel: UILabel!
    @IBOutlet private var headerLabel: LabelWithSpacing!
    @IBOutlet private var componentsSectionHeaderLabel: LabelWithSpacing!
    @IBOutlet private var subheaderLabel: UILabel!
    @IBOutlet private var horizontalAxisLabel: UILabel!
    @IBOutlet private var hotizontalAxisCountLabel: UILabel!

    private var dashedLinesWithLabels: [UIView] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        translatesAutoresizingMaskIntoConstraints = false

        componentChartsStackView.axis = .Horizontal
        componentChartsStackView.distribution = .FillEqually
        componentChartsStackView.alignment = .Bottom
        componentChartsStackView.spacing = 44
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
            configureWithViewModel(viewModel)
            informationSheetHidden = true
        case (_, .Failed):
            errorSheetVisible = true
        default:
            break
        }
    }

    private var errorSheetVisible: Bool = false {
        didSet {
            UIView.animateWithDuration(1) {
                self.errorImageView.alpha = self.errorSheetVisible ? 1 : 0
                self.activityIndicatorView.alpha = self.errorSheetVisible ? 0 : 1
                self.informationSheet.alpha = self.errorSheetVisible ? 1 : 0
            }
        }
    }

    private var informationSheetHidden: Bool = false {
        didSet {
            UIView.animateWithDuration(1) {
                self.informationSheet.alpha = self.informationSheetHidden ? 0 : 1
            }
        }
    }

    private func configureWithViewModel(viewModel: AreaBarChartViewModel) {
        configureBarsWithViewModel(viewModel)
        configureComponentChartsWithViewModel(viewModel)
        configureLabelsWithViewModel(viewModel)
        configureAxisWithViewModel(viewModel)
    }

    // MARK: -

    private func configureComponentChartsWithViewModel(viewModel: AreaBarChartViewModel) {

        componentChartsStackView.arrangedSubviews.forEach { view in
            componentChartsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        viewModel.componentCharts.forEach { chartViewModel in
            let chart = ComponentChartView.fromNib()
            chart.widthAnchor.constraintEqualToConstant(80).active = true
            chart.configureWithViewModel(chartViewModel)
            componentChartsStackView.addArrangedSubview(chart)
        }
    }

    private func configureLabelsWithViewModel(viewModel: AreaBarChartViewModel) {
        horizontalAxisLabel.text = viewModel.horizontalAxisLabelText
        hotizontalAxisCountLabel.text = viewModel.mainChart.horizontalAxisCountLabelText
        centerLabel.text = viewModel.centerText
        headerLabel.text = viewModel.mainChart.headerText
        headerLabel.applyCustomAttributes()
        subheaderLabel.text = viewModel.mainChart.subheaderText
        componentsSectionHeaderLabel.text = viewModel.historicalHeaderText
    }

    private func configureBarsWithViewModel(viewModel: AreaBarChartViewModel) {

        barStackView.arrangedSubviews.forEach { view in
            barStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        dashedLinesWithLabels.forEach { view in
            view.removeFromSuperview()
        }

        var viewsToPutToFront = [UIView]()

        viewModel.mainChart.barItems.forEach { itemViewModel in
            let barView = barStackView.addBarWithItemViewModel(itemViewModel)
            let lineView = addLineWithLabelToBarView(barView, withViewModel: itemViewModel)

            switch itemViewModel.valueLabelMode {
            case .VisibleWithHiddenLabel, .Hidden:
                break
            default:
                viewsToPutToFront.append(lineView)
            }

        }

        viewsToPutToFront.forEach {
            bringSubviewToFront($0)
        }

        bringSubviewToFront(barStackView)
        bringSubviewToFront(informationSheet)
    }

    private func addLineWithLabelToBarView(barView: UIView, withViewModel viewModel: AreaBarItemViewModel) -> UIView {
        let dashedLine = AreaBarDashedLineWithLabel.fromNib()
        dashedLine.configureWithViewModel(viewModel)
        addSubview(dashedLine)
        dashedLinesWithLabels.append(dashedLine)
        setUpConstraintsOfDashedLine(dashedLine, toBar: barView)

        return dashedLine
    }

    private func setUpConstraintsOfDashedLine(dashedLine: UIView, toBar bar: UIView) {
        dashedLine.heightAnchor.constraintEqualToConstant(20).active = true
        dashedLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: dashedLine, attribute: .Leading, relatedBy: .Equal,
                           toItem: self, attribute: .Leading, multiplier: 1.0, constant: 32).active = true
        NSLayoutConstraint(item: dashedLine, attribute: .Trailing, relatedBy: .Equal,
                           toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -32).active = true
        NSLayoutConstraint(item: dashedLine, attribute: .Bottom, relatedBy: .Equal,
                           toItem: bar, attribute: .Top, multiplier: 1.0, constant: 2).active = true
    }

    private func configureAxisWithViewModel(viewModel: AreaBarChartViewModel) {
        axisStackView.drawAxisWithViewModel(viewModel)
    }

    // MARK - fromNib

    class func fromNib() -> AreaBarChartView {
        return NSBundle.mainBundle().loadNibNamed("AreaBarChartView", owner: nil, options: nil)[0] as! AreaBarChartView
    }
}
