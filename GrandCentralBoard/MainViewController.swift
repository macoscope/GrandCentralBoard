//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var board: GrandCentralBoard!
    var configuration: Configuration!

    override func viewDidLoad() {
        super.viewDidLoad()

        board = GrandCentralBoard(configuration: configuration)
        view = board.view
    }
}
