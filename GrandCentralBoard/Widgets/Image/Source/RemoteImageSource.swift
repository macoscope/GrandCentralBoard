//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore


struct Image : Timed {
    let value: UIImage
    let time: NSDate
}

enum RemoteImageSourceError : ErrorType, HavingMessage {
    case DownloadFailed

    var message: String {
        switch self {
            case .DownloadFailed:
                return NSLocalizedString("Cannot download image!", comment: "")
        }
    }
}

final class RemoteImageSource : Asynchronous {

    typealias ResultType = GrandCentralBoardCore.Result<Image>

    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary
    let dataDownloader: DataDownloader

    private let path: String

    init(path: String, interval: NSTimeInterval = 30, dataDownloader: DataDownloader) {
        self.interval = interval
        self.path = path
        self.dataDownloader = dataDownloader
    }

    func read(closure: (ResultType) -> Void) {
        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
            case .Success(let data):
                if let value = UIImage(data: data) {
                    let image = Image(value: value, time: NSDate())
                    closure(.Success(image))
                } else {
                    closure(.Failure(RemoteImageSourceError.DownloadFailed))
                }
            case .Failure(let error):
                closure(.Failure(error))

            }
        }
    }
}