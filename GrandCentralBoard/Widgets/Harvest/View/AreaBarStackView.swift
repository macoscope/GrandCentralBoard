//
//  Created by Oktawian Chojnacki on 13.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


final class AreaBarStackView : UIStackView {

    override func awakeFromNib() {
        super.awakeFromNib()

        axis = .Horizontal
        distribution = .FillProportionally
        alignment = .Bottom
    }

    func addBarWithViewModelitemViewModel(viewModel: AreaBarItemViewModel) -> UIView {
        let view = UIView()
        view.backgroundColor = viewModel.color
        addArrangedSubview(view)
        view.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: viewModel.proportionalHeight).active = true
        view.widthAnchor.constraintEqualToAnchor(widthAnchor, multiplier: viewModel.proportionalWidth).active = true
        return view
    }
}