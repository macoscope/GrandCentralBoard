//
//  BubbleScalingController.swift
//  GrandCentralBoard
//
//  Created by Bartłomiej Chlebek on 07/04/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import SpriteKit

protocol BubbleScalingControllerDelegate: class {
    func bubbleScalingController(bubbleScalingController: BubbleScalingController, didScaleSpriteNodeUp spriteNode: SKSpriteNode)
    func bubbleScalingController(bubbleScalingController: BubbleScalingController, didScaleSpriteNodeDown spriteNode: SKSpriteNode)
}

extension BubbleScalingControllerDelegate {
    func bubbleScalingController(bubbleScalingController: BubbleScalingController, didScaleSpriteNodeUp spriteNode: SKSpriteNode) { }
    func bubbleScalingController(bubbleScalingController: BubbleScalingController, didScaleSpriteNodeDown spriteNode: SKSpriteNode) { }
}

final class BubbleScalingController {
    enum State {
        case Idle
        case ScalingUp
        case ScaledUp
        case ScalingDown
    }
    
    private var state: State = .Idle
    private weak var spriteNode: SKSpriteNode?
    private var scaleDownTimer: NSTimer?
    weak var delegate: BubbleScalingControllerDelegate?
    
    init(spriteNode: SKSpriteNode) {
        self.spriteNode = spriteNode
    }
    
    func scaleUp() {
        switch self.state {
        case .Idle: fallthrough
        case .ScalingDown: self.performScaleUpAction()
        case .ScaledUp: self.rescheduleScaleDownDeferTimer()
        case .ScalingUp: return
        }
    }
    
    // MARK - Scale actions
    
    private func performScaleUpAction() {
        guard let spriteNode = self.spriteNode else { return }
        
        let scaleUpAction = SKAction.scaleTo(2.3, duration: 0.5)
        self.state = .ScalingUp
        spriteNode.runAction(scaleUpAction, completion: {
            self.state = .ScaledUp
            self.rescheduleScaleDownDeferTimer()
            self.delegate?.bubbleScalingController(self, didScaleSpriteNodeUp: spriteNode)
        })
    }
    
    @objc private func performScaleDownAction() {
        guard let spriteNode = self.spriteNode else { return }
        
        let scaleDownAction = SKAction.scaleTo(1, duration: 0.5)
        self.state = .ScalingDown
        spriteNode.runAction(scaleDownAction, completion: {
            self.state = .Idle
            self.delegate?.bubbleScalingController(self, didScaleSpriteNodeDown: spriteNode)
        })
    }
    
    // MARK - Scale down timer
    
    private func rescheduleScaleDownDeferTimer() {
        self.scaleDownTimer?.invalidate()
        self.scaleDownTimer = NSTimer.scheduledTimerWithTimeInterval(15,
                                                                     target: self,
                                                                     selector: #selector(performScaleDownAction),
                                                                     userInfo: nil,
                                                                     repeats: false)
    }
}
