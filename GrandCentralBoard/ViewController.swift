//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

let dummySettings = [
    WidgetSettings(key:"watch", settings: ["timeZone":"Europe/Warsaw"]),
    WidgetSettings(key:"watch", settings: ["timeZone":"Europe/Warsaw"]),
    WidgetSettings(key:"watch", settings: ["timeZone":"Europe/Warsaw"]),
    WidgetSettings(key:"watch", settings: ["timeZone":"Europe/Warsaw"]),
    WidgetSettings(key:"watch", settings: ["timeZone":"Europe/Warsaw"]),
    WidgetSettings(key:"watch", settings: ["timeZone":"Europe/Warsaw"]),
]

let dummyConfiguration = Configuration(builders: [WatchWidgetBuilder()], settings: dummySettings)

class ViewController: UIViewController {

    let board = GrandCentralBoard(configuration: dummyConfiguration)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = board.view
    }
}

