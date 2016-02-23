//
//  Created by Oktawian Chojnacki on 23.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

final class Job {
    let source: Source
    let widget: Widget

    func update() {
        if let source = source as? Asynchronous {

            source.read { result in

            }

            return
        }

        if let source = source as? Synchronous {
            let result = source.read()
            
        }
    }
}

protocol Updateable {

    typealias ResultType
    
    let widgetView: ViewModelRendering
    let source: Source

    func updateWithResult(result: ResultType) {
        widgetView.render(Self.ViewModel)
    }
}

final class WatchWidget : Updateable {

    let widgetView: WatchWidgetView

    func updateWithResult(result: Result<Time>) {

        let timeViewModel

        widgetView.render(Self.ViewModel)
    }

}