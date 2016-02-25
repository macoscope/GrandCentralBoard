//
//  Created by krris on 23/02/16.
//  Copyright (c) 2016 Macoscope. All rights reserved.
//

import SpriteKit

private let pokeTimeInterval: NSTimeInterval = 5

class BonusScene: SKScene {
    
    private var sceneModel: BonusSceneModel!
    
    override func didMoveToView(view: SKView) {
        
        assert(sceneModel != nil)
        setUpWithSceneModel(sceneModel)
        
        // Waiting for #selector https://github.com/apple/swift-evolution/blob/master/proposals/0022-objc-selectors.md
        NSTimer.scheduledTimerWithTimeInterval(pokeTimeInterval, target: self, selector: Selector("pokeAllBalls"), userInfo: nil, repeats: true)
    }
    
    func setUpWithSceneModel(sceneModel: BonusSceneModel) {
        
        guard self.sceneModel != nil else {
            setUpWithSceneForTheFirstTimeWithSceneModel(sceneModel)
            return
        }
        updateWithSceneModel(sceneModel)
    }
    
    private func setUpWithSceneForTheFirstTimeWithSceneModel(sceneModel: BonusSceneModel) {
        self.sceneModel = sceneModel
        for person in sceneModel.people {
            let ball = Ball(person: person)
            ball.position = CGPoint(x: 0, y: 0)
            self.addChild(ball)
        }
    }
    
    private func updateWithSceneModel(sceneModel: BonusSceneModel) {
        self.sceneModel = sceneModel
        for person in sceneModel.people {
            if let ball = childNodeWithName(person.name) as? Ball {
                ball.updateWithBonus(person.bonus)
            }
        }
        
        scaleDownIfNeeded()
    }
    
    private func scaleDownIfNeeded() {
        children.forEach { node in
            if let node = node as? Ball {
                if !intersectsNode(node) {
                    scaleDown()
                }
            }
        }
    }
    
    private func scaleDown() {
        let scaleFactor: CGFloat = 1.5
        size = CGSize(width: size.width * scaleFactor, height: size.width * scaleFactor)
    }
    
    func pokeAllBalls() {
        let deltas = [Int](-10...10)
        
        let randomDxIndex = Int(arc4random_uniform(UInt32(deltas.count)))
        let randomDyIndex = Int(arc4random_uniform(UInt32(deltas.count)))
        let vector = CGVector(dx: deltas[randomDxIndex],
                              dy: deltas[randomDyIndex])
        let pokeAction = SKAction.moveBy(vector, duration: 2)
        
        children.forEach { node in
            if node.isKindOfClass(Ball) {
                node.runAction(pokeAction)
            }
        }
    }
}
