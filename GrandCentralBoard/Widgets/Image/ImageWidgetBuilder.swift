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

        let view = ImageWidgetView.fromNib()
        let imagesSource = try RemoteImageSource(paths: settings.imagePaths, dataDownloader: dataDownloader)
        let headerConfiguration = settings.header.map {
            ImageWidgetHeader(title: $0.title, subtitle: $0.subtitle ?? "")
        }

        return ImageWidget(view: view, sources: [imagesSource], header: headerConfiguration)
    }
}
