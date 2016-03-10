//
//  Created by Oktawian Chojnacki on 09.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Alamofire

public protocol DataDownloading {
    func downloadDataAtPath(path: String, completion: (Result<NSData>) -> Void)
}

public enum DataDownloaderError : ErrorType, HavingMessage {
    case EmptyResponse

    public var message: String {
        switch self {
            case .EmptyResponse:
                return NSLocalizedString("Received empty data!", comment: "")
        }
    }
}

public final class DataDownloader : DataDownloading {

    public init() {

    }

    public func downloadDataAtPath(path: String, completion: (Result<NSData>) -> Void) {

        Alamofire.request(.GET, path).response { (request, response, data, error) in

            if let data = data {
                completion(.Success(data))
                return
            }

            completion(.Failure(error ?? DataDownloaderError.EmptyResponse))
        }
    }
}