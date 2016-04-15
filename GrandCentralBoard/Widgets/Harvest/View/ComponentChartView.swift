//
//  Created by Oktawian Chojnacki on 15.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

final class ComponentChartView : UIView {

    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var subheaderLabel: UILabel!
    @IBOutlet private var horizontalAxisCountLabel: UILabel!
    @IBOutlet private var barStackView: AreaBarStackView!

    func configureWithViewModel(viewModel: AreaBarChartComponentViewModel) {

        headerLabel.text = viewModel.headerText
        subheaderLabel.text = viewModel.subheaderText
        horizontalAxisCountLabel.text = viewModel.horizontalAxisCountLabelText

        barStackView.arrangedSubviews.forEach { view in
            barStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        viewModel.barItems.forEach { itemViewModel in
            barStackView.addBarWithItemViewModel(itemViewModel)
        }
    }

    // MARK: - fromNib

    class func fromNib() -> ComponentChartView {
        return NSBundle.mainBundle().loadNibNamed("ComponentChartView", owner: nil, options: nil)[0] as! ComponentChartView
    }
}