//
//  Created by Oktawian Chojnacki on 28.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

struct Storyboards {

    struct Main {

        static let name = "Main"

        static var storyboard: UIStoryboard {
            return UIStoryboard(name: name, bundle: nil)
        }

        static func instantiate(configuration: Configuration) -> MainViewController! {
            let viewController = storyboard.instantiateViewControllerWithIdentifier("Main") as! MainViewController
            viewController.configuration = configuration
            return viewController
        }
    }
}