//
//  ImageWidgetSnapshotTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 20.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import FBSnapshotTestCase
import GCBCore
import GCBUtilities
@testable import GrandCentralBoard


private final class TestDataDownloader: DataDownloading {
    private let shouldFail: Bool

    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }

    private func downloadDataAtPath(path: String, completion: (Result<NSData>) -> Void) {
        if shouldFail {
            completion(.Failure(ErrorWithMessage(message: "error_messsage")))
        } else {
            let path = NSBundle(forClass: TestDataDownloader.self).pathForResource("cat", ofType:"jpeg")!
            let data = NSData(contentsOfFile: path)!
            completion(.Success(data))
        }
    }
}

final class ImageWidgetSnapshotTests: FBSnapshotTestCase {

    private var widgetView: ImageWidgetView!

    override func setUp() {
        super.setUp()
//        recordMode = true

        widgetView = ImageWidgetView.fromNib()
        widgetView.frame = CGRect(x: 0, y: 0, width: 640, height: 540)
    }

    func testViewWithFailure() {
        let dataDownloader = TestDataDownloader(shouldFail: true)
        let source = try! RemoteImageSource(paths: ["http://macoscope.com"], dataDownloader: dataDownloader)

        let widget = ImageWidget(view: widgetView, sources: [source], isHeaderVisible: false)
        widget.update(source)

        FBSnapshotVerifyView(widget.view)
    }

    func testViewWithCatImage() {
        let dataDownloader = TestDataDownloader(shouldFail: false)
        let source = try! RemoteImageSource(paths: ["http://macoscope.com"], dataDownloader: dataDownloader)

        let widget = ImageWidget(view: widgetView, sources: [source], isHeaderVisible: false)
        widget.update(source)

        FBSnapshotVerifyView(widget.view)
    }
}
