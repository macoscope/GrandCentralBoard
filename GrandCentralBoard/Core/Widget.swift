//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

public protocol HavingSources : class {
    var sources: [UpdatingSource] { get }
}

public protocol Updateable : class {
    func update(source: UpdatingSource)
}

public protocol WidgetControlling: Updateable, HavingSources {
    var view: UIView { get }
}

public protocol WidgetBuilding : class {
    var name: String { get }
    func build(settings: AnyObject) throws -> WidgetControlling
}
