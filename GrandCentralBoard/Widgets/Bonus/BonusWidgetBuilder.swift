//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Decodable
import GrandCentralBoardCore

final class BonusWidgetBuilder : WidgetBuilding {
    
    var name = "bonus"
    
    private let dataDownloader: DataDownloading
    
    init(dataDownloader: DataDownloader) {
        self.dataDownloader = dataDownloader
    }
    
    func build(settings: AnyObject) throws -> Widget {
        
        let settings = try BonusWidgetSettings.decode(settings)
        
        let imageMappingSource = ImageMappingSource(settings: settings, dataDownloader: dataDownloader)
        let bonusSource = BonusSource(settings: settings, dataDownloader: dataDownloader)
        return BonusWidget(sources: [bonusSource, imageMappingSource])
    }
}

struct BonusWidgetSettings: Decodable {
    
    let mappingPath: String
    let bonuslyPath: String
    
    static func decode(jsonObject: AnyObject) throws -> BonusWidgetSettings {
        return try BonusWidgetSettings(mappingPath: jsonObject => "mappingPath", bonuslyPath: jsonObject => "bonusly")
    }
}
