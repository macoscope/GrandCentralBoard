//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

class Bubble: SKSpriteNode, BubbleScalingControllerDelegate {
    
    static let shakeActionKey = "shakeAction"
    
    private var bonus: Int = 0
    private let initialSize = CGSize(width: 100, height: 100)

    private lazy var scalingController: BubbleScalingController = {
        let controller = BubbleScalingController(spriteNode: self)
        controller.delegate = self
        return controller
    }()
    
    init(bubbleViewModel: BubbleViewModel) {
        let image = bubbleViewModel.image
        
        self.bonus = bubbleViewModel.bonus
        let texture = SKTexture(image: image.cropToCircle())
        
        super.init(texture: texture, color: UIColor.clearColor(), size: initialSize)
        
        setUpPhysicsBody(texture, size: initialSize, bubbleViewModel: bubbleViewModel)
        self.name = bubbleViewModel.name
    }
    
    private func findImage(bubbleViewModel: BubbleViewModel) -> UIImage? {
        return UIImage(named: "placeholder")
    }
    
    private func setUpPhysicsBody(texture: SKTexture, size: CGSize, bubbleViewModel: BubbleViewModel) {
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
        self.bonus += difference
        
        // We increase bonus and run animation only if the value of bonus changes for a bigger one.
        guard difference > 0 else { return }
        self.stopShaking()
        self.scalingController.scaleUp()
    }
    
    // MARK - Shaking
    
    private func startShaking() {
        self.runAction(.shakeForever(), withKey: self.dynamicType.shakeActionKey)
    }
    
    private func stopShaking() {
        self.removeActionForKey(self.dynamicType.shakeActionKey)
    }
    
    // MARK - BubbleScalingControllerDelegate
    
    func bubbleScalingController(bubbleScalingController: BubbleScalingController, didScaleSpriteNodeDown spriteNode: SKSpriteNode) {
        self.startShaking()
    }
    
}

extension SKAction {
    class func shakeForever(amplitudeX: CGFloat = 5, amplitudeY: CGFloat = 5) -> SKAction {

        let forward = SKAction.moveByX(amplitudeX, y:amplitudeY, duration: 0.015)
        let reverse = forward.reversedAction()
        return SKAction.repeatActionForever(SKAction.sequence([forward, reverse]))
    }
}
