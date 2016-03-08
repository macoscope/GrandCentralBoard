//
//  Created by Krzysztof Werys on 25/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation
import Alamofire

final class BonusSource : Asynchronous {
    
    typealias ResultType = Result<[Person]>

    let sourceType: SourceType = .Cumulative
    let interval: NSTimeInterval = 5
    
    private var people: [String:Person] = [:]
    
    func read(closure: (ResultType) -> Void) {
        
        fetchBonusUpdate { updates in
            self.updatePeople(updates)
            self.fetchImages(closure)
        }
    }
    
    private func updatePeople(updates: [Update]) {
        updates.forEach { update in
            guard let person = people[update.name] else {
                people[update.name] = Person.personFromUpdate(update)
                return
            }
            
            guard person.lastUpdate.isLessThanDate(update.date) else { return }
            people[update.name] = person.copyByUpdating(update)
        }
    }
    
    // MARK: Fetching data from bonus.ly
    
    private func fetchBonusUpdate(completion: ([Update]) -> Void) {
        let path = "https://bonus.ly/api/v1/bonuses"
        let parameters = ["access_token" : "YOUR_TOKEN"]
        Alamofire.request(.GET, path, parameters: parameters).responseJSON { response in
            print(response.request)
            if let json = response.result.value {
                do {
                    let updates = try Updates.decode(json)
                    completion(updates.all.sort({ return $0.date.isLessThanDate($1.date) }))
                } catch {
                    print(error)
                }
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
                self.fetchImage(person, completion: { (success, image, error) -> (Void) in
                    if success {
                        self.people[name] = person.copyPersonWithImage(BubbleImage(image: image))
                        downloadsCounter.increment()
                        if downloadsCounter.value == imagesToDownloadCount {
                            closure(.Success(Array(self.people.values)))
                        }
                    } else {
                        failureCounter.increment()
                        if downloadsCounter.value + failureCounter.value == imagesToDownloadCount {
                            closure(.Success(Array(self.people.values)))
                        }
                    }
                })
            }
        })
        
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
