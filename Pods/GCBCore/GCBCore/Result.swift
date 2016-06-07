//
//  Created by Oktawian Chojnacki on 29.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


/**
 `GrandCentralBoard` native `Result`.

 - Failure: operation **Failed** - this case contains `ErrorType` value with further information.
 - Success: operation **Succeeded** - this case contains value/object of generic type specified.
 */
public enum Result<SuccessType> {
    case Failure(ErrorType)
    case Success(SuccessType)
}
