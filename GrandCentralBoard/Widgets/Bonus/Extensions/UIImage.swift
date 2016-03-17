//
//  Created by Krzysztof Werys on 08/03/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit

extension UIImage {
    func cropToCircle() -> UIImage {
        let imageFrame = CGRectMake(0, 0, self.size.width, self.size.height)
        let shorterSide = min(imageFrame.size.width, imageFrame.size.height)
        let circleFrame = CGRectMake(0, 0, shorterSide, shorterSide)
        let imageFrameWithOffset = CGRect(size: imageFrame.size, center: circleFrame.center)
        
        UIGraphicsBeginImageContextWithOptions(circleFrame.size, false, self.scale)
        UIBezierPath(ovalInRect: circleFrame).addClip()
        self.drawInRect(imageFrameWithOffset)
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
