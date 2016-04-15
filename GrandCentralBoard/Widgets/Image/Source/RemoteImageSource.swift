//
//  Created by Oktawian Chojnacki on 02.01.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GrandCentralBoardCore


enum RemoteImageSourceError : ErrorType, HavingMessage {
    case DownloadFailed
    case EmptyURLList
    var message: String {
        switch self {
        case .DownloadFailed:
            return NSLocalizedString("Cannot download image!", comment: "")
        case .EmptyURLList:
            return NSLocalizedString("Provided list of URLs with images is empty!", comment: "")
        }
    }
}

struct Counter {
    private(set) var value = 0
    let modulo: Int

    mutating func nextValue() -> Int {
        let returnValue = value
        value = (value + 1) % modulo
        return returnValue
    }
}

final class RemoteImageSource : Asynchronous {

    typealias ResultType = GrandCentralBoardCore.Result<UIImage>

    let interval: NSTimeInterval
    let sourceType: SourceType = .Momentary
    let dataDownloader: DataDownloader

    private let paths: [String]
    private var counter: Counter

    init(paths: [String], dataDownloader: DataDownloader, interval: NSTimeInterval = 30) throws {
        guard paths.count > 0 else {
            throw RemoteImageSourceError.EmptyURLList
        }

        self.interval = interval
        self.paths = paths
        self.dataDownloader = dataDownloader
        self.counter = Counter(value: 0, modulo: paths.count)
    }

    func read(closure: (ResultType) -> Void) {
        let path = paths[counter.nextValue()]
        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
            case .Success(let data):
                if let image = UIImage(data: data) {
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
