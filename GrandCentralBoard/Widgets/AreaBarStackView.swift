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

    func addBar(bar: AreaBarItemViewModel) {
        let view = UIView()
        view.backgroundColor = bar.color
        addArrangedSubview(view)
        view.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: bar.proportionalHeight).active = true
        view.widthAnchor.constraintEqualToAnchor(widthAnchor, multiplier: bar.proportionalWidth).active = true
    }
}