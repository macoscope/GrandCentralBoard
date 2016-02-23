//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let topLeft = ImageWidget.fromNib()//WatchWidget.fromNib()
    let topMiddle = ImageWidget.fromNib()
    let topRight = ImageWidget.fromNib()
    let bottomLeft = ImageWidget.fromNib()
    let bottomMiddle = ImageWidget.fromNib()
    let bottomRight = ImageWidget.fromNib()

    let imageSource = RemoteImageSource(url: NSURL(string: "https://sf.co.ua/14/02/wallpaper-507810.jpg")!)
    let timeSource = TimeSource(zone: NSTimeZone.localTimeZone())

    var stack: AutoStack!

    override func viewDidLoad() {
        super.viewDidLoad()

        stack = AutoStack()
        self.view = stack

        stack.stackView(topLeft)
        stack.stackView(topMiddle)
        stack.stackView(topRight)
        stack.stackView(bottomLeft)
        stack.stackView(bottomMiddle)
        stack.stackView(bottomRight)

        // let time = TimeViewModel(time:"00:00", timeZone: "Warsaw", day: "11", month: "January")
        // let timeReading = timeSource.read()

        imageSource.read { result in
            switch result {
                case .Success(let image):

                    let viewModel = ImageViewModel(image: image.value)

                    self.topLeft.render(viewModel)
                    self.topMiddle.render(viewModel)
                    self.topRight.render(viewModel)

                    self.bottomLeft.render(viewModel)
                    self.bottomMiddle.render(viewModel)
                    self.bottomRight.render(viewModel)

                case .Failure:
                    break
            }
        }
    }
}

