//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

class Bubble: SKSpriteNode {
    
    static let shakeActionKey = "shakeAction"
    
    private enum State {
        case Idle
        case ScalingUp
        case ScaledUp
        case ScalingDown
    }

    private var state: State = .Idle
    private var scaleDownDeferTimer: NSTimer?
    
    private var bonus: Int = 0
    private let initialSize = CGSize(width: 100, height: 100)
    
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
        
        switch self.state {
        case .Idle: self.scaleUp()
        case .ScalingUp: break
        case .ScaledUp: self.rescheduleScaleDownDeferTimer()
        case .ScalingDown: self.scaleUp()
        }
    }
    
    // MARK - Scaling
    
    private func scaleUp() {
        self.stopShaking()
        
        let scaleUpAction = SKAction.scaleTo(2.3, duration: 0.5)
        self.state = .ScalingUp
        self.runAction(scaleUpAction, completion: {
            self.state = .ScaledUp
            self.rescheduleScaleDownDeferTimer()
        })
    }
    
    private func rescheduleScaleDownDeferTimer() {
        self.scaleDownDeferTimer?.invalidate()
        self.scaleDownDeferTimer = NSTimer.scheduledTimerWithTimeInterval(15,
                                                                          target: self,
                                                                          selector: #selector(scaleDown),
                                                                          userInfo: nil,
                                                                          repeats: false)
    }
    
    @objc private func scaleDown() {
        let scaleDownAction = SKAction.scaleTo(1, duration: 0.5)
        self.state = .ScalingDown
        self.runAction(scaleDownAction, completion: {
            self.state = .Idle
            self.startShaking()
        })
    }
    
    // MARK - Shaking
    
    private func startShaking() {
        self.runAction(.shakeForever(), withKey: self.dynamicType.shakeActionKey)
    }
    
    private func stopShaking() {
        self.removeActionForKey(self.dynamicType.shakeActionKey)
    }
}

extension SKAction {
    class func shakeForever(amplitudeX: CGFloat = 5, amplitudeY: CGFloat = 5) -> SKAction {

        let forward = SKAction.moveByX(amplitudeX, y:amplitudeY, duration: 0.015)
        let reverse = forward.reversedAction()
        return SKAction.repeatActionForever(SKAction.sequence([forward, reverse]))
    }
}
