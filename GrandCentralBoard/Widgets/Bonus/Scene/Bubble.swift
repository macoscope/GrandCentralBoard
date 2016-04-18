//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

class Bubble: SKSpriteNode, BubbleScalingAnimatorDelegate {
    
    private let initialSize = CGSize(width: 140, height: 140)
    private var lastBonusDate: NSDate? = nil
    private let bubbleResizeDuration: NSTimeInterval
    private lazy var scalingAnimator: BubbleScalingAnimator = {
        let animator = BubbleScalingAnimator(spriteNode: self, bubbleResizeDuration: self.bubbleResizeDuration)
        animator.delegate = self
        return animator
    }()
    
    init(bubbleViewModel: BubbleViewModel, bubbleResizeDuration: NSTimeInterval) {
        let image = bubbleViewModel.image
        let texture = SKTexture(image: image.cropToCircle())
        self.bubbleResizeDuration = bubbleResizeDuration

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
    
    func updateWithLastBonusDate(lastBonusDate: NSDate) {
        guard self.lastBonusDate != nil else {
            self.lastBonusDate = lastBonusDate
            return
        }

        guard lastBonusDate.timeIntervalSinceDate(self.lastBonusDate!) > 0 else {
            return
        }

        self.lastBonusDate = lastBonusDate
        self.scalingAnimator.scaleUp()
    }

    // MARK - BubbleScalingControllerDelegate
    
    func bubbleScalingAnimator(bubbleScalingAnimator: BubbleScalingAnimator, didScaleSpriteNodeDown spriteNode: SKSpriteNode) { }
    
}
