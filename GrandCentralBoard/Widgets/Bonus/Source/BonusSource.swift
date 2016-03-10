//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Alamofire

final class BonusSource : Asynchronous {
    
    typealias ResultType = Result<[Person]>
    typealias UpdateResultType = Result<Updates>
    typealias ImageResultType = Result<UIImage>

    let sourceType: SourceType = .Cumulative
    let interval: NSTimeInterval = 5
    
    var mapping: Mapping?
    private var people: [String:Person] = [:]
    private let dataDownloader: DataDownloading
    private let settings: BonusWidgetSettings
    
    init(settings: BonusWidgetSettings, dataDownloader: DataDownloading) {
        self.dataDownloader = dataDownloader
        self.settings = settings
    }
    
    func read(closure: (ResultType) -> Void) {
        
        fetchBonusUpdate { result in
            switch result {
                case .Success(let update):
                    let updates = update.all.sort({ return $0.date.isLessThanDate($1.date) })
                    self.updatePeople(updates)
                    self.fetchImages(closure)
                case .Failure(let error):
                    closure(.Failure(error))
            }
        }
    }
    
    private func updatePeople(updates: [Update]) {
        updates.forEach { update in
            guard let person = people[update.name] else {
                people[update.name] = Person.personFromUpdate(update, imageUrl: mapping?.data[update.name])
                return
            }
            
            if let url = mapping?.data[update.name] {
                people[update.name] = person.copyPersonWithImage(BubbleImage(url: url))
            }
            
            guard person.lastUpdate.isLessThanDate(update.date) else { return }
            people[update.name] = person.copyByUpdating(update, imageUrl: mapping?.data[update.name])
        }
    }
    
    // MARK: Fetching data from bonus.ly
    
    private func fetchBonusUpdate(completion: (UpdateResultType) -> Void) {
        dataDownloader.downloadDataAtPath(settings.bonuslyPath) { result in
            switch result {
                case .Success(let data):
                    do {
                        let updates = try Updates.updatesFromData(data)
                        completion(.Success(updates))
                    } catch (let error) {
                        completion(.Failure(error))
                    }
                case .Failure(let error):
                    completion(.Failure(error))
            }
        }
    }
    
    // MARK: Fetching images
    
    private func fetchImages(closure: (ResultType) -> Void) {
        let imagesToDownloadCount = people.filter({ (name, person) -> Bool in
            if let _ = person.bubbleImage.url where person.bubbleImage.remoteImage == nil {
                return true
            }
            return false
        }).count
        
        guard imagesToDownloadCount > 0 else { return closure(.Success(Array(people.values))) }
        let downloadsCounter = AtomicCounter()
        let failureCounter = AtomicCounter()

        people.forEach({ (name, person) in
            guard let _ =  person.bubbleImage.url else { return }
            
            if person.bubbleImage.remoteImage == nil {
                self.fetchImage(person) { result in
                    switch result {
                        case .Success(let image):
                            self.people[name] = person.copyPersonWithImage(BubbleImage(image: image))
                            downloadsCounter.increment()
                            if downloadsCounter.value == imagesToDownloadCount {
                                closure(.Success(Array(self.people.values)))
                            }
                        case .Failure(_):
                            failureCounter.increment()
                            if downloadsCounter.value + failureCounter.value == imagesToDownloadCount {
                                closure(.Success(Array(self.people.values)))
                            }
                    }
                    
                }
            }
        })
    }
    
    private func fetchImage(person: Person, closure: (ImageResultType) -> Void) {
        
        if let path = person.bubbleImage.url {
            dataDownloader.downloadDataAtPath(path) { result in
                switch result {
                    case .Success(let data):
                        if let image = UIImage(data: data) {
                            closure(.Success(image))
                        }
                    case .Failure(let error):
                        closure(.Failure(error))
                }
            }
        }
    }
}
