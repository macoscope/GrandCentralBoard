//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation

// This is sample data which is displayed by BonusWidget. It could be replaced by real data 
// from Bonusly API https://bonusly.gelato.io/

var sampleData = [
    Person(name: "Agata", bubbleImage: BubbleImage(url: "http://macoscope.com/img/Team/Agata.jpg"), bonus: Bonus(total: 30)),
    Person(name: "Arek", bubbleImage: BubbleImage(url: "http://macoscope.com/img/Team/Arek.jpg"), bonus: Bonus(total: 20)),
    Person(name: "Jarek", bubbleImage: BubbleImage(imageName: "jarek_p"), bonus: Bonus(total: 20)),
    Person(name: "MaciejS", bubbleImage: BubbleImage(imageName: "maciej_s"), bonus: Bonus(total: 0)),
    Person(name: "Dawid", bubbleImage: BubbleImage(imageName: "dawid_w"), bonus: Bonus(total: 10)),
    Person(name: "Dominik", bubbleImage: BubbleImage(imageName: "dominik_s"), bonus: Bonus(total: 20)),
    Person(name: "Mateusz", bubbleImage: BubbleImage(imageName: "mateusz"), bonus: Bonus(total: 60)),
    Person(name: "Daniel", bubbleImage: BubbleImage(imageName: "daniel_o"), bonus: Bonus(total: 30)),
    Person(name: "Wojtek", bubbleImage: BubbleImage(imageName: "wojtek_r"), bonus: Bonus(total: 60)),
    Person(name: "Karol", bubbleImage: BubbleImage(imageName: "karol_k"), bonus: Bonus(total: 30)),
    Person(name: "Rafał", bubbleImage: BubbleImage(imageName: "rafal_a"), bonus: Bonus(total: 100)),
    Person(name: "Karolina", bubbleImage: BubbleImage(imageName: "karolina"), bonus: Bonus(total: 30)),
    Person(name: "Justyna", bubbleImage: BubbleImage(imageName: "justyna_d"), bonus: Bonus(total: 30)),
    Person(name: "Kasia", bubbleImage: BubbleImage(imageName: "kasia"), bonus: Bonus(total: 20)),
    Person(name: "Bartek", bubbleImage: BubbleImage(imageName: "bartek_c"), bonus: Bonus(total: 75)),
    Person(name: "ŁukaszK", bubbleImage: BubbleImage(imageName: "lukasz_k"), bonus: Bonus(total: 10)),
    Person(name: "Diana", bubbleImage: BubbleImage(imageName: "diana"), bonus: Bonus(total: 5)),
    Person(name: "ŁukaszF", bubbleImage: BubbleImage(imageName: "lukasz_f"), bonus: Bonus(total: 0)),
    Person(name: "MichałL", bubbleImage: BubbleImage(imageName: "michal_l"), bonus: Bonus(total: 0)),
    Person(name: "Krzysztof", bubbleImage: BubbleImage(imageName: "krzysztof_w"), bonus: Bonus(total: 10)),
    Person(name: "MaciejG", bubbleImage: BubbleImage(imageName: "maciej_g"), bonus: Bonus(total: 10)),
    Person(name: "ŁukaszC", bubbleImage: BubbleImage(imageName: "lukasz_c"), bonus: Bonus(total: 20)),
    Person(name: "Przemek", bubbleImage: BubbleImage(imageName: "przemek_s"), bonus: Bonus(total: 30)),
    Person(name: "Adam", bubbleImage: BubbleImage(imageName: "adam_s"), bonus: Bonus(total: 35)),
    Person(name: "Virginia", bubbleImage: BubbleImage(imageName: "virginia"), bonus: Bonus(total: 30)),
    Person(name: "Zuza", bubbleImage: BubbleImage(imageName: "zuza"), bonus: Bonus(total: 40)),
    Person(name: "Tomek", bubbleImage: BubbleImage(imageName: "tomek_k"), bonus: Bonus(total: 40)),
    Person(name: "Darek", bubbleImage: BubbleImage(imageName: "darek"), bonus: Bonus(total: 0))
]


func randomBonusUpdate(data: [Person]) -> [Person] {
    let randomIndex = Int(arc4random_uniform(UInt32(data.count)))
    let randomPerson = data[randomIndex]
    
    let bonusRange = (1...50)
    guard let bonus = bonusRange.randomElement() else { fatalError() }
    
    return [Person(name: randomPerson.name,
                  bubbleImage: randomPerson.bubbleImage,
                  bonus: Bonus(total: randomPerson.bonus.total + bonus, last: bonus))]
}

func fetchBonusUpdate(completion: ([Person]) -> Void) {
    completion(randomBonusUpdate(sampleData))
}
