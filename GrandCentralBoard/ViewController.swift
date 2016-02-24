//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    let imageSource = RemoteImageSource(url: NSURL(string: "https://sf.co.ua/14/02/wallpaper-507810.jpg")!)
    let timeSource = TimeSource(zone: NSTimeZone(name: "Europe/Warsaw")!)
    let scheduler = Scheduler()

    var stack: AutoStack!

    override func viewDidLoad() {
        super.viewDidLoad()

        stack = AutoStack()
        self.view = stack

        let topLeft = WatchWidget(source: timeSource)
        let topMiddle = WatchWidget(source: timeSource)
        let topRight = WatchWidget(source: timeSource)
        let bottomLeft = WatchWidget(source: timeSource)
        let bottomMiddle = WatchWidget(source: timeSource)
        let bottomRight = WatchWidget(source: timeSource)

        stack.stackView(topLeft.view)
        stack.stackView(topMiddle.view)
        stack.stackView(topRight.view)
        stack.stackView(bottomLeft.view)
        stack.stackView(bottomMiddle.view)
        stack.stackView(bottomRight.view)

        topLeft.update()
        topMiddle.update()
        topRight.update()
        bottomLeft.update()
        bottomMiddle.update()
        bottomRight.update()

        let job = Job(target: topLeft)
        scheduler.schedule(job)
    }
}

