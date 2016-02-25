//
//  Created by krris on 24/02/16.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import Foundation

var sampleData = [
    Person(name: "Agata", image: BubbleImage(imageName: "Agata"), bonus: Bonus(total: 30, last: 0)),
    Person(name: "Arek", image: BubbleImage(imageName: "Arek"), bonus: Bonus(total: 20, last: 5)),
    Person(name: "MaciejS", image: BubbleImage(imageName: "MaciejS"), bonus: Bonus(total: 0, last: 0)),
    Person(name: "Dawid", image: BubbleImage(imageName: "Dawid"), bonus: Bonus(total: 10, last: 0)),
    Person(name: "Dominik", image: BubbleImage(imageName: "Dominik"), bonus: Bonus(total: 20, last: 0)),
    Person(name: "Mateusz", image: BubbleImage(imageName: "Mateusz"), bonus: Bonus(total: 60, last: 0)),
    Person(name: "Daniel", image: BubbleImage(imageName: "Daniel"), bonus: Bonus(total: 30, last: 0)),
    Person(name: "Wojtek", image: BubbleImage(imageName: "Wojtek"), bonus: Bonus(total: 60, last: 0)),
    Person(name: "Karol", image: BubbleImage(imageName: "Karol"), bonus: Bonus(total: 30, last: 0)),
    Person(name: "Rafał", image: BubbleImage(imageName: "Rafał"), bonus: Bonus(total: 100, last: 0)),
    Person(name: "Karolina", image: BubbleImage(imageName: "Karolina"), bonus: Bonus(total: 30, last: 0)),
    Person(name: "Justyna", image: BubbleImage(imageName: "Justyna"), bonus: Bonus(total: 30, last: 0)),
    Person(name: "Kasia", image: BubbleImage(imageName: "Kasia"), bonus: Bonus(total: 20, last: 0)),
    Person(name: "Bartek", image: BubbleImage(imageName: "Bartek"), bonus: Bonus(total: 75, last: 0)),
    Person(name: "ŁukaszK", image: BubbleImage(imageName: "ŁukaszK"), bonus: Bonus(total: 10, last: 0)),
    Person(name: "Diana", image: BubbleImage(imageName: "Diana"), bonus: Bonus(total: 5, last: 0)),
    Person(name: "ŁukaszF", image: BubbleImage(imageName: "ŁukaszF"), bonus: Bonus(total: 0, last: 0)),
    Person(name: "MichałL", image: BubbleImage(imageName: "MichałL"), bonus: Bonus(total: 0, last: 0)),
    Person(name: "Krzysztof", image: BubbleImage(imageName: "Krzysztof"), bonus: Bonus(total: 10, last: 0)),
    Person(name: "MaciejG", image: BubbleImage(imageName: "MaciejG"), bonus: Bonus(total: 10, last: 0)),
    Person(name: "ŁukaszC", image: BubbleImage(imageName: "ŁukaszC"), bonus: Bonus(total: 20, last: 0)),
    Person(name: "Przemek", image: BubbleImage(imageName: "Przemek"), bonus: Bonus(total: 30, last: 0)),
    Person(name: "Adam", image: BubbleImage(imageName: "Adam"), bonus: Bonus(total: 35, last: 0)),
    Person(name: "Virginia", image: BubbleImage(imageName: "Virginia"), bonus: Bonus(total: 30, last: 0)),
    Person(name: "Zuza", image: BubbleImage(imageName: "Zuza"), bonus: Bonus(total: 40, last: 0)),
    Person(name: "Darek", image: BubbleImage(imageName: "Darek"), bonus: Bonus(total: 0, last: 0))]


func randomlyUpdateData(data: [Person]) -> [Person] {
    var updatedData = data
    let randomIndex = Int(arc4random_uniform(UInt32(data.count)))
    let randomPerson = data[randomIndex]
    
    let bonusRange = Array(1...50)
    let randomBounsIndex = Int(arc4random_uniform(UInt32(bonusRange.count)))
    let bonus = bonusRange[randomBounsIndex]
    
    updatedData[randomIndex] = Person(name: randomPerson.name,
                              image: randomPerson.image,
                              bonus: Bonus(total: randomPerson.bonus.total + bonus, last: bonus))
    sampleData = updatedData
    return updatedData
}
