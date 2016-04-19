//
//  Created by Krzysztof Werys on 08/03/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit

extension UIImage {
    func cropToCircle() -> UIImage {
        let imageFrame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let shorterSide = min(imageFrame.size.width, imageFrame.size.height)
        let circleFrame = CGRect(x: 0, y: 0, width: shorterSide, height: shorterSide)
        let imageFrameWithOffset = CGRect(size: imageFrame.size, center: circleFrame.center)

        UIGraphicsBeginImageContextWithOptions(circleFrame.size, false, self.scale)
        UIBezierPath(ovalInRect: circleFrame).addClip()
        self.drawInRect(imageFrameWithOffset)
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    static func generatePlaceholderImage() -> UIImage {
        let size = CGSize(width: 40, height: 40)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.whiteColor().setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }


}
