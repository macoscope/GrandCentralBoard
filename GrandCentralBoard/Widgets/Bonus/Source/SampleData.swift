//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import Foundation

// This is sample data which is displayed by BonusWidget. It could be replaced by real data 
// from Bonusly API https://bonusly.gelato.io/

var sampleData = [
    Person(name: "Agata", image: BubbleImage(imageName: "agata_r"), bonus: Bonus(total: 30)),
    Person(name: "Arek", image: BubbleImage(imageName: "arek_h"), bonus: Bonus(total: 20)),
    Person(name: "Jarek", image: BubbleImage(imageName: "jarek_p"), bonus: Bonus(total: 20)),
    Person(name: "MaciejS", image: BubbleImage(imageName: "maciej_s"), bonus: Bonus(total: 0)),
    Person(name: "Dawid", image: BubbleImage(imageName: "dawid_w"), bonus: Bonus(total: 10)),
    Person(name: "Dominik", image: BubbleImage(imageName: "dominik_s"), bonus: Bonus(total: 20)),
    Person(name: "Mateusz", image: BubbleImage(imageName: "mateusz"), bonus: Bonus(total: 60)),
    Person(name: "Daniel", image: BubbleImage(imageName: "daniel_o"), bonus: Bonus(total: 30)),
    Person(name: "Wojtek", image: BubbleImage(imageName: "wojtek_r"), bonus: Bonus(total: 60)),
    Person(name: "Karol", image: BubbleImage(imageName: "karol_k"), bonus: Bonus(total: 30)),
    Person(name: "Rafał", image: BubbleImage(imageName: "rafal_a"), bonus: Bonus(total: 100)),
    Person(name: "Karolina", image: BubbleImage(imageName: "karolina"), bonus: Bonus(total: 30)),
    Person(name: "Justyna", image: BubbleImage(imageName: "justyna_d"), bonus: Bonus(total: 30)),
    Person(name: "Kasia", image: BubbleImage(imageName: "kasia"), bonus: Bonus(total: 20)),
    Person(name: "Bartek", image: BubbleImage(imageName: "bartek_c"), bonus: Bonus(total: 75)),
    Person(name: "ŁukaszK", image: BubbleImage(imageName: "lukasz_k"), bonus: Bonus(total: 10)),
    Person(name: "Diana", image: BubbleImage(imageName: "diana"), bonus: Bonus(total: 5)),
    Person(name: "ŁukaszF", image: BubbleImage(imageName: "lukasz_f"), bonus: Bonus(total: 0)),
    Person(name: "MichałL", image: BubbleImage(imageName: "michal_l"), bonus: Bonus(total: 0)),
    Person(name: "Krzysztof", image: BubbleImage(imageName: "krzysztof_w"), bonus: Bonus(total: 10)),
    Person(name: "MaciejG", image: BubbleImage(imageName: "maciej_g"), bonus: Bonus(total: 10)),
    Person(name: "ŁukaszC", image: BubbleImage(imageName: "lukasz_c"), bonus: Bonus(total: 20)),
    Person(name: "Przemek", image: BubbleImage(imageName: "przemek_s"), bonus: Bonus(total: 30)),
    Person(name: "Adam", image: BubbleImage(imageName: "adam_s"), bonus: Bonus(total: 35)),
    Person(name: "Virginia", image: BubbleImage(imageName: "virginia"), bonus: Bonus(total: 30)),
    Person(name: "Zuza", image: BubbleImage(imageName: "zuza"), bonus: Bonus(total: 40)),
    Person(name: "Tomek", image: BubbleImage(imageName: "tomek_k"), bonus: Bonus(total: 40)),
    Person(name: "Darek", image: BubbleImage(imageName: "darek"), bonus: Bonus(total: 0))]


func randomBonusUpdate(data: [Person]) -> [Person] {
    let randomIndex = Int(arc4random_uniform(UInt32(data.count)))
    let randomPerson = data[randomIndex]
    
    let bonusRange = (1...50)
    guard let bonus = bonusRange.randomElement() else { fatalError() }
    
    return [Person(name: randomPerson.name,
                  image: randomPerson.image,
                  bonus: Bonus(total: randomPerson.bonus.total + bonus, last: bonus))]
}
