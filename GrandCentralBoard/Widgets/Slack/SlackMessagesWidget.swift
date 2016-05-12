//
//  SlackMessagesWidget.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GCBCore


final class SlackMessagesWidget: WidgetControlling {

    private let widgetView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        return label
    }()

    let sources: [UpdatingSource]
    var view: UIView { return widgetView }

    init(source: SlackSource) {
        sources = [source]
        source.subscriptionBlock = { [weak self] message in
            self?.onNewMessage(message)
        }
    }

    private func onNewMessage(message: SlackMessage) {
        widgetView.text = message.text
    }

    func update(source: UpdatingSource) {}
}
