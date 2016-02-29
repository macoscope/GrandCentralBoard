//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

protocol Updateable : class {
    var sources: [UpdatingSource] { get }
    func update(timer: NSTimer)
}

protocol Widget : Updateable {
    var view: UIView { get }
}

protocol WidgetBuilding : class {
    var name: String { get }
    func build(settings: AnyObject) throws -> Widget
}