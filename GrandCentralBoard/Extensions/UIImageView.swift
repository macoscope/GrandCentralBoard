//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageIfNotTheSame(image: UIImage?) {
        guard self.image?.hashValue != image?.hashValue else { return }

        self.image = image
    }
}