//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import Alamofire

struct Image : Timed {
    let value: UIImage
    let time: NSDate
}

enum RemoteImageSourceError : ErrorType, HavingMessage {
    case DownloadFailed

    var message: String {
        switch self {
            case .DownloadFailed:
            return "Cannot download image!"
        }
    }
}

final class RemoteImageSource : Asynchronous {

    typealias ResultType = Result<Image>

    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary

    private let url: NSURL

    init(url: NSURL, interval: NSTimeInterval = 30) {
        self.interval = interval
        self.url = url
    }

    func read(closure: (ResultType) -> Void) {
        Alamofire.request(.GET, url).response { (request, response, data, error) in

            if let data = data, image = UIImage(data: data) {
                let image = Image(value: image, time: NSDate())
                closure(.Success(image))
                return
            }

            closure(.Failure(RemoteImageSourceError.DownloadFailed))
        }
    }
}