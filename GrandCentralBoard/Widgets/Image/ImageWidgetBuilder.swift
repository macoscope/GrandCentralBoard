//
//  ImageWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 14.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GCBCore

final class ImageWidgetBuilder: WidgetBuilding {

    let name: String = "image"
    let dataDownloader: DataDownloader

    init(dataDownloader: DataDownloader) {
        self.dataDownloader = dataDownloader
    }

    func build(settings: AnyObject) throws -> WidgetControlling {
        let settings = try ImageWidgetConfiguration.decode(settings)

        let imagesSource = try RemoteImageSource(paths: settings.imagePaths, dataDownloader: dataDownloader)
        let view = ImageWidgetView.fromNib()

        return ImageWidget(view: view,
                           sources: [imagesSource],
                           isHeaderVisible: settings.isHeaderVisible ?? true)
    }
}
