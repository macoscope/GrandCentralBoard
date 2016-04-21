//
//  Created by Oktawian Chojnacki on 09.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Alamofire


public protocol DataDownloading {
    func downloadDataAtPath(path: String, completion: (Result<NSData>) -> Void)
}

public enum DataDownloadingError: ErrorType, HavingMessage {
    case EmptyResponse
    case ImageCannotBeFetched

    public var message: String {
        switch self {
        case .EmptyResponse:
            return NSLocalizedString("Received empty data!", comment: "")
        case .ImageCannotBeFetched:
            return NSLocalizedString("Cannot download image!", comment: "")
        }
    }
}

public final class DataDownloader: DataDownloading {

    public init() {

    }

    public func downloadDataAtPath(path: String, completion: (Result<NSData>) -> Void) {

        Alamofire.request(.GET, path).response { (request, response, data, error) in

            if let data = data {
                completion(.Success(data))
                return
            }

            completion(.Failure(error ?? DataDownloadingError.EmptyResponse))
        }
    }
}

public extension DataDownloading {
    func downloadImageAtPath(path: String, completion: (Result<UIImage>) -> Void) {
        downloadDataAtPath(path) { result in
            switch result {
            case .Success(let data):
                if let image = UIImage(data: data) {
                    completion(.Success(image))
                } else {
                    completion(.Failure(DataDownloadingError.ImageCannotBeFetched))
                }
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
}