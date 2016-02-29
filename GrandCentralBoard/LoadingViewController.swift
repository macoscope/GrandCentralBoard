//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Configuration.fetchConfiguration { [weak self] result in
            switch result {
                case .Success(let configuration):
                    let main = Storyboards.Main.instantiate(configuration)
                    self?.navigationController?.pushViewController(main, animated: true)
                case .Failure:
                    // TODO: Recover!
                    break
            }
        }
    }
}

