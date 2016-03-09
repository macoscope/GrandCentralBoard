//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

protocol ViewStacking {
    func stackView(view: UIView) -> Bool
}

final class AutoStack : UIView, ViewStacking {

    private let maximumColumns: Int = 2
    private let maximumRows: Int = 3

    var stackedViews = [UIView]()
    var mainStackView = UIStackView()
    var columnStackViews = [UIStackView]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        mainStackView.distribution = .FillEqually
        mainStackView.alignment = .Fill
        mainStackView.axis = .Vertical
        mainStackView.spacing = 0
        mainStackView.autoresizingMask = [ .FlexibleHeight, .FlexibleWidth ]
        mainStackView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(mainStackView)

        for _ in 0..<maximumColumns {
            let stack = UIStackView()
            stack.distribution = .FillEqually
            stack.alignment = .Fill
            stack.axis = .Horizontal
            stack.spacing = 0.0
            columnStackViews.append(stack)
            mainStackView.addArrangedSubview(stack)
        }
    }

    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    // MARK: - ViewStacking

    func stackView(view: UIView) -> Bool {

        stackedViews.append(view)

        for columnStackView in columnStackViews.reverse() {

            guard columnStackView.arrangedSubviews.count < maximumRows else {
                continue
            }

            columnStackView.addArrangedSubview(view)
        }

        return true
    }

    // MARK: - NSCoding

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}