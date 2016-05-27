//
//  SlackMessagesWidget.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GCBCore


extension SlackWidgetViewModel {
    static func fromMessage(message: SlackMessage) -> SlackWidgetViewModel {
        if let avatar = message.avatar {
            return SlackWidgetViewModel(avatarImage: avatar, message: message.text)
        } else {
            return SlackWidgetViewModel(avatarImage: UIImage(named: "default_avatar")!, message: message.text)
        }
    }
}


final class SlackMessagesWidget: WidgetControlling {

    private let widgetView = SlackWidgetView.fromNib()

    let sources: [UpdatingSource]
    var view: UIView { return widgetView }

    init(source: SlackSource) {
        sources = [source]
        source.subscriptionBlock = { [weak self] message in
            self?.onNewMessage(message)
        }
    }

    private func onNewMessage(message: SlackMessage) {
        let viewModel = SlackWidgetViewModel.fromMessage(message)
        widgetView.configureWithViewModel(viewModel)
    }

    func update(source: UpdatingSource) {}
}
