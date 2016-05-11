//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

/// The errors that `GrandCentralBoard` can throw.
public enum GrandCentralBoardError: ErrorType, HavingMessage {
    case WrongWidgetsCount

    public var message: String {
        switch self {
            case .WrongWidgetsCount:
                return NSLocalizedString("Expected six configured widgets!", comment: "")
        }
    }
}

/// The class is configurable with `Configuration`.
public protocol Configurable: class {

    /**
     Configure class with `Configuration`.

     - parameter configuration: Widgets Settings and Widget Builders.

     - throws: GrandCentralBoardError if widget count is different than **6** but can throw other `ErrorTypes`.
     */
    func configure(configuration: Configuration) throws
}

/// This is a controller class that stacks views on `ViewStacking` view and schedules updates for Widgets using object conforming to `SchedulingJobs`.
public final class GrandCentralBoard {

    private let stack: ViewStacking
    private let scheduler: SchedulingJobs
    private let expectedWidgetsCount = 6

    private var configuration: Configuration?
    private var widgets: [WidgetControlling] = []

    /**
     Initialize the `GrandCentralBoard`.

     - parameter scheduler: scheduling updates for widgets.
     - parameter stack:     a view having the ability to stack views.

     */
    public init(scheduler: SchedulingJobs, stack: ViewStacking) {
        self.scheduler = scheduler
        self.stack = stack
    }
}

extension GrandCentralBoard: Configurable {

    public func configure(configuration: Configuration) throws {

        if let previousConfiguration = self.configuration where previousConfiguration == configuration {
            return
        }

        scheduler.invalidateAll()
        stack.removeAllStackedViews()

        self.configuration = configuration

        widgets = try configuration.settings.flatMap({ widgetConfiguration in

            if let builder = configuration.builders.filter({ $0.name == widgetConfiguration.name }).first {
                return try builder.build(widgetConfiguration.settings)
            }

            return nil
        })

        guard widgets.count == expectedWidgetsCount else {
            throw GrandCentralBoardError.WrongWidgetsCount
        }

        widgets.forEach { widget in
            stack.stackView(widget.view)
            widget.sources.forEach { source in
                scheduler.schedule(Job(target: widget, source: source))
            }
        }
    }
}
