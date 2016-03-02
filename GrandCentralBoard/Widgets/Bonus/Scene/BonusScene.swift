//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

private let pokeTimeInterval: NSTimeInterval = 5

class BonusScene: SKScene {
    
    private var sceneModel: BonusSceneModel!
    private let world = SKNode()
    
    override func didMoveToView(view: SKView) {
        assert(sceneModel != nil)
        setUpWithSceneModel(sceneModel)
        
        // Waiting for #selector https://github.com/apple/swift-evolution/blob/master/proposals/0022-objc-selectors.md
        NSTimer.scheduledTimerWithTimeInterval(pokeTimeInterval, target: self, selector: Selector("pokeAllBubbles"), userInfo: nil, repeats: true)
    }
    
    func setUpWithSceneModel(sceneModel: BonusSceneModel) {
        guard self.sceneModel != nil else {
            setUpSceneForTheFirstTimeWithSceneModel(sceneModel)
            return
        }
        updateWithSceneModel(sceneModel)
    }
    
    private func setUpSceneForTheFirstTimeWithSceneModel(sceneModel: BonusSceneModel) {
        self.sceneModel = sceneModel
        addChild(world)
        
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
            world.addChild(bubble)
        }
    }
    
    private func updateWithSceneModel(sceneModel: BonusSceneModel) {
        self.sceneModel = sceneModel
        for person in sceneModel.people {
            if let bubble = world.childNodeWithName(person.name) as? Bubble {
                bubble.updateWithBonus(person.bonus)
            }
        }
    }
    
    func pokeAllBubbles() {
        let movement = (-10...10)
        guard let dx = movement.randomElement(), let dy = movement.randomElement() else { return }
        
        let vector = CGVector(dx: dx, dy: dy)
        let pokeAction = SKAction.moveBy(vector, duration: 2)
        
        let gravityNode = childNodeWithName("radialGravityField")
        gravityNode?.position = CGPointZero
        gravityNode?.runAction(pokeAction)
    }
    
    override func update(currentTime: NSTimeInterval) {
        guard !world.children.isEmpty else { return }
        
        let nodesFitScreen = CGRectContainsRect(frame, world.calculateAccumulatedFrame())
        if !nodesFitScreen {
            scaleBubblesDown()
        }
    }
    
    private func scaleBubblesDown() {
        // Scale bubbles down by increasing size of the scene
        let scaleFactor: CGFloat = 1.02
        size = CGSize(width: size.width * scaleFactor, height: size.width * scaleFactor)
    }
    
}
