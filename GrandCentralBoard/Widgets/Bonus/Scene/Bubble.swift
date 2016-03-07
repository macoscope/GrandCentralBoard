//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

class Bubble: SKSpriteNode {
    
    private var bonus: Int = 0
    private let initialSize = CGSize(width: 50, height: 50)
    
    init(person: Person) {
        guard let image = person.bubbleImage.remoteImage ?? person.bubbleImage.localImage ?? UIImage(named: "placeholder") else { fatalError()}
        
        self.bonus = person.bonus.total
        let texture = SKTexture(image: image)
        super.init(texture: texture, color: UIColor.clearColor(), size: initialSize)
        
        setUpPhysicsBody(texture, size: initialSize, person: person)
        self.name = person.name
        
        let scaleBy: CGFloat = 1 + CGFloat(person.bonus.total) / 100
        setScale(scaleBy)
    }
    
    private func findImage(person: Person) -> UIImage? {
        return UIImage(named: "placeholder")
    }
    
    private func setUpPhysicsBody(texture: SKTexture, size: CGSize, person: Person) {
        let spacing: CGFloat = 1
        physicsBody = SKPhysicsBody(circleOfRadius: initialSize.width / 2 + spacing)
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.3
        physicsBody?.linearDamping = 0.5
        physicsBody?.allowsRotation = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithNewBonus(newBonus: Int) {
        guard newBonus > 0 else { return }
        
        self.bonus += newBonus
        
        var scaleBy: CGFloat = 2.3
        let scaleUpAction = SKAction.scaleBy(scaleBy, duration: 0.5)
        let scaleDownAction = SKAction.scaleBy(1/scaleBy, duration: 0.1)
        
        scaleBy = 1 + CGFloat(newBonus) / 100
        let finalScaleAction = SKAction.scaleBy(scaleBy, duration: 0.1)
        
        runAction(SKAction.sequence([scaleUpAction, scaleDownAction, finalScaleAction]))
    }
}
