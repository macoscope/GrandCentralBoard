//
//  Created by krris on 23/02/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    private var bonus: Int = 0
    private let initialSize = CGSize(width: 50, height: 50)
    
    init(person: Person) {
        let image = UIImage(named: person.image.imageName) ?? UIImage(named: "placeholder")
        self.bonus = person.bonus.total
        
        let texture = SKTexture(image: image!)
        super.init(texture: texture, color: UIColor.clearColor(), size: initialSize)
        
        setUpPhysicsBody(texture, size: initialSize)
        self.name = person.name
        
        let scaleBy: CGFloat = 1 + CGFloat(person.bonus.total) / 100
        setScale(scaleBy)
    }
    
    private func setUpPhysicsBody(texture: SKTexture, size: CGSize) {
        physicsBody = SKPhysicsBody(texture: texture, size: initialSize)
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.3
        physicsBody?.linearDamping = 0.5
        physicsBody?.allowsRotation = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithBonus(bonus: Bonus) {
        guard bonus.total > self.bonus else { return }
        
        self.bonus += bonus.last
        physicsBody?.mass = CGFloat(bonus.last)
        
        var scaleBy: CGFloat = 2.3
        let scaleUpAction = SKAction.scaleBy(scaleBy, duration: 0.5)
        let scaleDownAction = SKAction.scaleBy(1/scaleBy, duration: 0.1)
        
        scaleBy = 1 + CGFloat(bonus.last) / 100
        let finalScaleAction = SKAction.scaleBy(scaleBy, duration: 0.1)
        
        runAction(SKAction.sequence([scaleUpAction, scaleDownAction, finalScaleAction]))
    }
}
