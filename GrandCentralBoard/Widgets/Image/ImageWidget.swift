//
//  Created by Oktawian Chojnacki on 07.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

final class ImageWidget : Widget {

    private unowned let widgetView: ImageWidgetView
    let sources: [UpdatingSource]

    init(view: ImageWidgetView, sources: [UpdatingSource]) {
        self.widgetView = view
        self.sources = sources
    }

    var view: UIView {
        return widgetView
    }

    var events: [Event]?
    var lastFetch: NSDate?

    func update(source: UpdatingSource) {
        switch source {
            case let source as RemoteImageSource:
                updateImageFromSource(source)
            default:
                assertionFailure("Expected `source` as instance of `RemoteImageSource`.")
        }
    }

    private func updateImageFromSource(source: RemoteImageSource) {
        source.read { [weak self] result in
            switch result {
                case .Success(let image):
                    let imageViewModel = ImageViewModel(image: image.value)
                    self?.widgetView.render(imageViewModel)
                case .Failure:
                    break
            }
        }
    }
}