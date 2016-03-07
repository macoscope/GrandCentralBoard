//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Alamofire

final class BonusSource : Asynchronous {
    
    typealias ResultType = Result<[Person]>

    let sourceType: SourceType = .Momentary
    let interval: NSTimeInterval = 5
    
    private var people: [Person] = sampleData
    
    func read(closure: (ResultType) -> Void) {
        
        fetchBonusUpdate { updateWithNewBonuses in
            let peopleWithUpdatedBonuses = self.addBonuses(updateWithNewBonuses)
            self.fetchImages(peopleWithUpdatedBonuses, closure: closure)
        }
    }
    
    private func addBonuses(update: [Person]) -> [Person] {
        var peopleWithUpdatedBonuses = self.people
        update.forEach { person in
            if let index = self.people.indexOf( {$0.name == person.name} ) {
                self.people[index] = self.people[index].copyPersonWithTotalBonus(person.bonus.total)
                peopleWithUpdatedBonuses[index] = person
            }
        }
        return peopleWithUpdatedBonuses
    }
    
    private func fetchImages(var people: [Person], closure: (ResultType) -> Void) {
        let imagesToDownloadCount = people.filter({ person -> Bool in
            if let _ = person.bubbleImage.url where person.bubbleImage.remoteImage == nil {
                return true
            }
            return false
        }).count
        let downloadsCounter = AtomicCounter()
        
        for (index, person) in people.enumerate() {
            guard let _ =  person.bubbleImage.url else { continue }
            
            if person.bubbleImage.remoteImage == nil {
                self.fetchImage(person, completion: { (success, image, error) -> (Void) in
                    if success {
                        people[index] = person.copyPersonWithImage(BubbleImage(image: image))
                        downloadsCounter.increment()
                        if downloadsCounter.value == imagesToDownloadCount {
                            closure(.Success(people))
                        }
                    } else {
                        closure(.Failure(error ?? RemoteImageSourceError.DownloadFailed))
                    }
                })
            }
        }
    }
    
    private func fetchImage(person: Person, completion: (success: Bool, image: UIImage?, error: NSError?) -> (Void)) {
        
        if let path = person.bubbleImage.url {
            Alamofire.request(.GET, path).response { (request, response, data, error) in
                if let data = data, image = UIImage(data: data) {
                    completion(success: true, image: image, error: nil)
                    return
                }
                completion(success: false, image: nil, error: error)
            }
        }
    }
}
