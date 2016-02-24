//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

protocol Updateable {
    var frequency: NSTimeInterval { get }
    func update()
}

class Widget : Updateable {
    var view: UIView { get }
}