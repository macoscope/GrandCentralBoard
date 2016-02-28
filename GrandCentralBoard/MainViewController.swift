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

        Configuration.fetchConfiguration { [weak self] result in
            switch result {
            case .Success(let configuration):
                //let main = Storyboards.Main.instantiate(configuration)
                self?.board = GrandCentralBoard(configuration: configuration)
                self?.view = self?.board.view
            case .Failure:
                // TODO: Recover!
                break
            }
        }



    }
}
