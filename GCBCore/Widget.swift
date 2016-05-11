//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


/// Class implementing this protocol will have a collection of sources implementing `UpdatingSource` protocol.
public protocol HavingSources : class {
    var sources: [UpdatingSource] { get }
}

/// Ability to be updated by calling `update(source:)` method with a source implementing `UpdatingSource` protocol.
public protocol Updateable : class {
    func update(source: UpdatingSource)
}

/**
  Class implementing this protocol have it's controlled `view` and has to implement `Updateable` and `HavingSources` protocols.
 */
public protocol WidgetControlling: Updateable, HavingSources {
    /// This `view` is the de facto Widget being displayed.
    var view: UIView { get }
}

/// Ability to build a Widget (class implementing `WidgetControlling` protocol) using json data (AnyObject).
public protocol WidgetBuilding : class {

    /// This is an identifier, used to select proper builder for widget configuration entry.
    var name: String { get }

    /**
     Actual building method.

     - parameter settings: Deserialized JSON data `AnyObject` (`NSDictionary`).

     - throws: Can throw errors related to deserialization.

     - returns: class implementing `WidgetControlling` protocol
     */
    func build(settings: AnyObject) throws -> WidgetControlling
}
