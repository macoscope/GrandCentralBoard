//
//  Created by Oktawian Chojnacki on 02.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation


/**
 Entity conforming to this protocol contains custom localized error message.
 */
public protocol HavingMessage {
    var message: String { get }
}

public extension ErrorType {
    var userMessage: String {

        if let error = self as? HavingMessage {
            return error.message
        }

        let error = self as NSError
        return error.localizedDescription ?? error.description ?? NSLocalizedString("Unknown", comment: "")
    }
}
