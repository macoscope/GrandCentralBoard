//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

class Bubble: SKSpriteNode {
    
    private var bonus: Int = 0
    private let initialSize = CGSize(width: 100, height: 100)
    
    init(person: Person) {
        guard let image = person.bubbleImage.remoteImage ?? person.bubbleImage.fallbackImage else { fatalError()}
        
        self.bonus = person.bonus
        let texture = SKTexture(image: image.cropToCircle())
        super.init(texture: texture, color: UIColor.clearColor(), size: initialSize)
        
        setUpPhysicsBody(texture, size: initialSize, person: person)
        self.name = person.name
        
        let scaleBy: CGFloat = 1 + CGFloat(person.bonus) / 100
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
    
    func updateImage(image: UIImage) {
        let newImage = image.cropToCircle()
        self.texture = SKTexture(image: newImage)
    }
    
    func updateWithNewBonus(newBonus: Int) {
        let difference = newBonus - self.bonus

        // We increase bonus and run animation only if the value of bonus changes for a bigger one.
        guard difference > 0 else { return }
        
        self.bonus += difference
        
        var scaleBy: CGFloat = 2.3
        let scaleUpAction = SKAction.scaleBy(scaleBy, duration: 0.5)
        let scaleDownAction = SKAction.scaleBy(1/scaleBy, duration: 0.1)
        
        scaleBy = 1 + CGFloat(difference) / 100
        let finalScaleAction = SKAction.scaleBy(scaleBy, duration: 0.1)

        parent?.children.forEach({ node in
            node.removeActionForKey("shakeAction")
        })
        runAction(SKAction.sequence([scaleUpAction, scaleDownAction, finalScaleAction]), completion: {
            self.runAction(SKAction.shakeForever(), withKey: "shakeAction")
        })
    }
}

extension SKAction {
    class func shakeForever(amplitudeX: CGFloat = 5, amplitudeY: CGFloat = 5) -> SKAction {

        let forward = SKAction.moveByX(amplitudeX, y:amplitudeY, duration: 0.015)
        let reverse = forward.reversedAction()
        return SKAction.repeatActionForever(SKAction.sequence([forward, reverse]))
    }
}
