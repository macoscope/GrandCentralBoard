//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

enum GrandCentralBoardError : ErrorType, HavingMessage {
    case WrongWidgetsCount

    var message: String {
        switch self {
            case .WrongWidgetsCount:
                return "Expected six configured widgets!"
        }
    }
}

final class GrandCentralBoard {

    private let stack = AutoStack()
    private let scheduler: SchedulingJobs = Scheduler()
    private let expectedWidgetsCount = 6

    private var widgets : [Widget]

    var view: UIView {
        return stack
    }

    init(configuration: Configuration) throws {

        widgets = configuration.settings.flatMap({ widgetConfiguration in
            
            if let builder = configuration.builders.filter({ $0.name == widgetConfiguration.name }).first {
                return try? builder.build(widgetConfiguration.settings)
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