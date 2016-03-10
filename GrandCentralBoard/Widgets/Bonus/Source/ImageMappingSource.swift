//
//  Created by Krzysztof Werys on 10/03/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Decodable


struct Mapping : Decodable {
    let data: [String: String]
    
    static func decode(jsonObject: AnyObject) throws -> Mapping {
        let data: [String: String] = try jsonObject => "mapping"
        return Mapping(data: data)
    }   
}

extension Mapping{

    static func mappingFromData(data: NSData) throws -> Mapping {
        
        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
            return try Mapping.decode(jsonResult)
        }

        throw DecodeError.WrongFormat
    }
}

final class ImageMappingSource : Asynchronous {
    
    typealias ResultType = Result<Mapping>

    let interval: NSTimeInterval = 60
    let sourceType: SourceType = .Momentary

    private let path: String
    private let dataDownloader: DataDownloading
    
    init(settings: BonusWidgetSettings, dataDownloader: DataDownloading) {
        self.path = settings.mappingPath
        self.dataDownloader = dataDownloader
    }

    func read(closure: (ResultType) -> Void) {
        
        dataDownloader.downloadDataAtPath(path) { result in
            switch result {
                case .Success(let data):
                    do {
                        let mapping = try Mapping.mappingFromData(data)
                        closure(.Success(mapping))
                    } catch (let error) {
                        closure(.Failure(error))
                    }
                case .Failure(let error):
                    closure(.Failure(error))
            }
        }
    }
}
