//
//  SlackWidgetViewModel.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 30.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import UIKit
import RxSwift


struct SlackWidgetViewModel {
    let avatarImage: UIImage
    let message: String
}

extension SlackWidgetViewModel {

    private static var defaultAvatarImage: UIImage { return UIImage(named: "default_avatar")! }

    static func fromMessage(message: SlackMessage, withAvatarProvider avatarProvider: AvatarProvider) -> Observable<SlackWidgetViewModel> {
        if let avatarPath = message.avatarPath, avatarURL = NSURL(string: avatarPath) {
            return avatarProvider.avatarWithURL(avatarURL).single().map { SlackWidgetViewModel(avatarImage: $0, message: message.text) }
        } else {
            return Observable.just(SlackWidgetViewModel(avatarImage: defaultAvatarImage, message: message.text))
        }
    }
}
