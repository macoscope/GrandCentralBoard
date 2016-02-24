//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

protocol Updateable : class {
    var interval: NSTimeInterval { get }
    func update()
}

protocol Widget : Updateable {
    var view: UIView { get }
}