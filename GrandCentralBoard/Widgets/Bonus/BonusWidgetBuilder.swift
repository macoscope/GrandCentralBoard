//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Decodable
import GCBCore

final class BonusWidgetBuilder: WidgetBuilding {

    var name = "bonus"

    private let dataDownloader: DataDownloading

    init(dataDownloader: DataDownloader) {
        self.dataDownloader = dataDownloader
    }

    func build(settings: AnyObject) throws -> WidgetControlling {

        let settings = try BonusWidgetSettings.decode(settings)

        let bonusSource = BonusSource(bonuslyAccessToken: settings.accessToken)
        return BonusWidget(sources: [bonusSource], bubbleResizeDuration: settings.bubbleResizeDuration)
    }
}

enum BonusWidgetSettingsError: ErrorType, HavingMessage {
    case BubbleResizeDurationInvalid(NSTimeInterval)

    var message: String {
        switch self {
        case .BubbleResizeDurationInvalid(let duration):
            return "A value of \(duration) for BubbleResizeDuration is invalid"
        }
    }
}

struct BonusWidgetSettings: Decodable {
    let accessToken: String
    let bubbleResizeDuration: NSTimeInterval

    static func decode(jsonObject: AnyObject) throws -> BonusWidgetSettings {
        let settings = try BonusWidgetSettings(accessToken: jsonObject => "accessToken",
                                       bubbleResizeDuration: jsonObject => "bubbleResizeDuration")

        guard settings.bubbleResizeDuration > 0 else {
            throw BonusWidgetSettingsError.BubbleResizeDurationInvalid(settings.bubbleResizeDuration)
        }
        return settings
    }
}
