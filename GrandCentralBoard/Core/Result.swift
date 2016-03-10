//
//  Created by Oktawian Chojnacki on 29.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Failure(ErrorType)
    case Success(T)
}