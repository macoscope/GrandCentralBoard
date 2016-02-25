//
//  Created by krris on 23/02/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
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
            let widthRange = Int(-size.width / 2) ... Int(size.width / 2)
            let heightRange = Int(-size.height / 2) ... Int(size.height / 2)
            if let x = widthRange.randomElement(), let y = heightRange.randomElement() {
                ball.position = CGPoint(x: x, y: y)
            } else {
                ball.position = CGPoint(x: 0, y: 0)
            }
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
        let deltas = (-10...10)
        guard let dx = deltas.randomElement(), let dy = deltas.randomElement() else { return }
        
        let vector = CGVector(dx: dx, dy: dy)
        let pokeAction = SKAction.moveBy(vector, duration: 2)
        
        children.forEach { node in
            if node.isKindOfClass(Ball) {
                node.runAction(pokeAction)
            }
        }
    }
}
