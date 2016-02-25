//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let board = GrandCentralBoard(configuration: try! Configuration.defaultConfiguration())

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = board.view
    }
}

