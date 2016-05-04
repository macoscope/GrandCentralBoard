//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

/**
 Ability to stack views (in a unspecified way) as well as remove all stacked views.
 */
public protocol ViewStacking {
    /**
     Stack view.

     - parameter view: specified view will be stacked on called subject.
     */
    func stackView(view: UIView)

    /**
     Calling this method will result in removing all previously stacked views.
     */
    func removeAllStackedViews()
}

/// This UIView subclass is using a collection of Stack Views to display grid of 6 views.
public final class AutoStack: UIView, ViewStacking {

    private let maximumColumns: Int = 2
    private let maximumRows: Int = 3

    public var stackedViews = [UIView]()
    public var mainStackView = UIStackView()
    public var columnStackViews = [UIStackView]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.blackColor()
        mainStackView.distribution = .FillEqually
        mainStackView.alignment = .Fill
        mainStackView.axis = .Vertical
        mainStackView.spacing = 0

        fillViewWithView(mainStackView, animated: false)

        prepareColumnStackViews()
    }

    private func prepareColumnStackViews() {
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

    public func stackView(view: UIView) {

        stackedViews.append(view)

        for columnStackView in columnStackViews.reverse() {

            guard columnStackView.arrangedSubviews.count < maximumRows else {
                continue
            }

            columnStackView.addArrangedSubview(view)

            return
        }
    }

    public func removeAllStackedViews() {

        mainStackView.arrangedSubviews.forEach { view in
            mainStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        stackedViews = []
        columnStackViews = []

        prepareColumnStackViews()
    }

    // MARK: - NSCoding

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
