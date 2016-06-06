//
//  SlackMessagesWidget.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 11.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GCBCore
import RxSwift


final class SlackMessagesWidget: WidgetControlling {

    private let messageView = SlackWidgetView.fromNib()
    private let widgetView: WidgetTemplateView

    let sources: [UpdatingSource]
    private let avatarProvider = AvatarProvider()
    private let disposeBag = DisposeBag()

    var view: UIView { return widgetView }

    init(source: SlackSource) {
        sources = [source]

        let widgetTemplateViewModel = WidgetTemplateViewModel(title: "Slack".uppercaseString,
                                                              subtitle: "No Posts".uppercaseString,
                                                              contentView: messageView)
        let layoutSettings = WidgetTemplateLayoutSettings(contentMargin: UIEdgeInsets(top: 26, left: 27, bottom: 27, right: 26))
        widgetView = WidgetTemplateView.viewWithViewModel(widgetTemplateViewModel, layoutSettings: layoutSettings)

        widgetView.hidden = true

        source.subscriptionBlock = { [weak self] message in
            self?.onNewMessage(message)
        }
    }

    private func onNewMessage(message: SlackMessage) {
        SlackWidgetViewModel.fromMessage(message, withAvatarProvider: avatarProvider).subscribeNext { [weak self] in
            self?.messageView.configureWithViewModel($0)
            self?.messageView.hidden = false
        }.addDisposableTo(disposeBag)
    }

    func update(source: UpdatingSource) {}
}
