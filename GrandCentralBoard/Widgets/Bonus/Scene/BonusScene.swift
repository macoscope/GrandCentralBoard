//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

private let pokeTimeInterval: NSTimeInterval = 5

class BonusScene: SKScene {
    
    private var sceneModel: BonusSceneModel!
    
    override func didMoveToView(view: SKView) {
        assert(sceneModel != nil)
        setUpWithSceneModel(sceneModel)
        
        // Waiting for #selector https://github.com/apple/swift-evolution/blob/master/proposals/0022-objc-selectors.md
        NSTimer.scheduledTimerWithTimeInterval(pokeTimeInterval, target: self, selector: Selector("pokeAllBubbles"), userInfo: nil, repeats: true)
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
        let topRightPoint = CGPoint(x: size.width / 2, y: size.height / 2)
        for person in sceneModel.people {
            let bubble = Bubble(person: person)
            let widthRange = Int(-topRightPoint.x) ... Int(topRightPoint.x)
            let heightRange = Int(-topRightPoint.y) ... Int(topRightPoint.y)
            if let x = widthRange.randomElement(), let y = heightRange.randomElement() {
                bubble.position = CGPoint(x: x, y: y)
            } else {
                bubble.position = CGPoint(x: 0, y: 0)
            }
            addChild(bubble)
        }
    }
    
    private func updateWithSceneModel(sceneModel: BonusSceneModel) {
        self.sceneModel = sceneModel
        for person in sceneModel.people {
            if let bubble = childNodeWithName(person.name) as? Bubble {
                bubble.updateWithBonus(person.bonus)
            }
        }
        
        scaleBubblesDownIfNeeded()
    }
    
    private func scaleBubblesDownIfNeeded() {
        children.forEach { node in
            if let node = node as? Bubble {
                if !intersectsNode(node) {
                    scaleBubblesDown()
                }
            }
        }
    }
    
    private func scaleBubblesDown() {
        // Scale bubbles down by increasing size of the scene
        let scaleFactor: CGFloat = 1.5
        size = CGSize(width: size.width * scaleFactor, height: size.width * scaleFactor)
    }
    
    func pokeAllBubbles() {
        let movement = (-10...10)
        guard let dx = movement.randomElement(), let dy = movement.randomElement() else { return }
        
        let vector = CGVector(dx: dx, dy: dy)
        let pokeAction = SKAction.moveBy(vector, duration: 2)
        
        children.forEach { node in
            if node.isKindOfClass(Bubble) {
                node.runAction(pokeAction)
            }
        }
    }
}
