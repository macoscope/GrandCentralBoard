//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import GrandCentralBoardCore

final class BonusSource : Asynchronous {
    
    typealias ResultType = Result<[Person]>
    typealias ImageResultType = Result<UIImage>

    let sourceType: SourceType = .Cumulative
    let interval: NSTimeInterval = 5
    
    var mapping: Mapping?
    private var people: [String:Person] = [:]
    private let dataDownloader: DataDownloading
    private let settings: BonusWidgetSettings
    private let peopleFetchController: PeopleWithBonususFetchController = PeopleWithBonususFetchController()
    private let requestSender: RequestSender = RequestSender()
    
    init(settings: BonusWidgetSettings, dataDownloader: DataDownloading) {
        self.dataDownloader = dataDownloader
        self.settings = settings
    }
    
    func read(closure: (ResultType) -> Void) {

        peopleFetchController.fetchPeopleWithBonuses { result in
            switch result {
            case .Success(let people):
                closure(.Success(people))
            case .Failure(let error):
                closure(.Failure(error))
            }
        }

//        fetchBonusUpdate { result in
//            switch result {
//                case .Success(let allUpdates):
//                    let updates = allUpdates.sort({ return $0.date < $1.date })
//                    self.updatePeople(updates)
//                    self.fetchImages(closure)
//                case .Failure(let error):
//                    closure(.Failure(error))
//            }
//        }
    }
    
//    private func updatePeople(updates: [Update]) {
//        updates.forEach { update in
//            guard let person = people[update.name] else {
//                people[update.name] = Person.personFromUpdate(update, imageUrl: mapping?.data[update.name])
//                return
//            }
//            
//            if let url = mapping?.data[update.name] {
//                people[update.name] = person.copyPersonWithImage(BubbleImage(url: url))
//            }
//            
//            guard person.lastUpdate < update.date else { return }
//            people[update.name] = person.copyByUpdating(update, imageUrl: mapping?.data[update.name])
//        }
//    }
//    
//    // MARK: Fetching data from bonus.ly
//    
//    private func fetchBonusUpdate(completion: (UpdateResultType) -> Void) {
//        dataDownloader.downloadDataAtPath(settings.bonuslyPath) { result in
//            switch result {
//                case .Success(let data):
//                    do {
//                        let updates = try Update.updatesFromData(data)
//                        completion(.Success(updates))
//                    } catch (let error) {
//                        completion(.Failure(error))
//                    }
//                case .Failure(let error):
//                    completion(.Failure(error))
//            }
//        }
//    }

    // MARK: Fetching images
    
//    private func fetchImages(closure: (ResultType) -> Void) {
//        let dispatchGroup = dispatch_group_create()
//        people.forEach({ (name, person) in
//            guard let _ =  person.bubbleImage.url else { return }
//            
//            if person.bubbleImage.remoteImage == nil {
//                dispatch_group_enter(dispatchGroup)
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//                    self.fetchImage(person) { result in
//                        switch result {
//                        case .Success(let image):
//                            self.people[name] = person.copyPersonWithImage(BubbleImage(image: image))
//                        case .Failure(_):
//                            break
//                        }
//                        dispatch_group_leave(dispatchGroup)
//                    }
//                }
//            }
//        })
//
//        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue()) {
//            closure(.Success(Array(self.people.values)))
//        }
//    }
//    
//    private func fetchImage(person: Person, closure: (ImageResultType) -> Void) {
//        
//        if let path = person.bubbleImage.url {
//            dataDownloader.downloadDataAtPath(path) { result in
//                switch result {
//                    case .Success(let data):
//                        if let image = UIImage(data: data) {
//                            closure(.Success(image))
//                        }
//                    case .Failure(let error):
//                        closure(.Failure(error))
//                }
//            }
//        }
//    }
}
