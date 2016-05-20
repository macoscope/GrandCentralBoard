//
//  Created by Oktawian Chojnacki on 07.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import GCBCore


final class ImageWidget: WidgetControlling {

    private let widgetView: ImageWidgetView
    private let mainView: UIView

    let sources: [UpdatingSource]
    let isHeaderVisible: Bool

    init(view: ImageWidgetView, sources: [UpdatingSource], isHeaderVisible: Bool) {
        self.widgetView = view
        self.sources = sources
        self.isHeaderVisible = isHeaderVisible

        if isHeaderVisible {
            let viewModel = WidgetTemplateViewModel(title: "CAT PHOTOS", subtitle: "NEWEST CAT PROFILES", contentView: widgetView)
            let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsetsZero, displayContentUnderHeader: true)
            mainView = WidgetTemplateView.viewWithViewModel(viewModel, layoutSettings: layoutSettings)
        } else {
            mainView = widgetView
        }
    }

    var view: UIView {
        return mainView
    }

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
                    let imageViewModel = ImageViewModel(image: image)
                    self?.widgetView.render(imageViewModel)
                case .Failure:
                    break
            }
        }
    }
}
