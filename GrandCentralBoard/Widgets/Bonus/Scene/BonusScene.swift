//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

private let pokeTimeInterval: NSTimeInterval = 5

class BonusScene: SKScene {
    
    private var viewModel: BonusWidgetViewModel!
    private let world = SKNode()
    
    override func didMoveToView(view: SKView) {
        assert(viewModel != nil)
        setUpWithViewModel(viewModel)
        
        // Waiting for #selector https://github.com/apple/swift-evolution/blob/master/proposals/0022-objc-selectors.md
        NSTimer.scheduledTimerWithTimeInterval(pokeTimeInterval, target: self, selector: Selector("pokeAllBubbles"), userInfo: nil, repeats: true)
    }
    
    func setUpWithViewModel(viewModel: BonusWidgetViewModel) {
        guard self.viewModel != nil else {
            setUpSceneForTheFirstTimeWithViewModel(viewModel)
            return
        }
        updateWithViewModel(viewModel)
    }
    
    private func setUpSceneForTheFirstTimeWithViewModel(viewModel: BonusWidgetViewModel) {
        self.viewModel = viewModel
        addChild(world)
        
        for bubbleViewModel in viewModel.bubbles {
            let bubble = Bubble(bubbleViewModel: bubbleViewModel)
            bubble.position = randomPosition()
            world.addChild(bubble)
        }
    }
    
    private func updateWithViewModel(viewModel: BonusWidgetViewModel) {
        self.viewModel = viewModel
        for bubbleViewModel in viewModel.bubbles {
            guard let bubble = world.childNodeWithName(bubbleViewModel.name) as? Bubble else {
                let newBubble = Bubble(bubbleViewModel: bubbleViewModel)
                newBubble.position = randomPosition()
                self.world.addChild(newBubble)
                continue
            }

            bubble.updateWithNewBonus(bubbleViewModel.bonus)
            bubble.updateImage(bubbleViewModel.image)
        }
    }
    
    private func randomPosition() -> CGPoint {
        let topRightPoint = CGPoint(x: size.width / 2, y: size.height / 2)
        let widthRange = Int(-topRightPoint.x) ... Int(topRightPoint.x)
        let heightRange = Int(-topRightPoint.y) ... Int(topRightPoint.y)
        if let x = widthRange.randomElement(), let y = heightRange.randomElement() {
            return CGPoint(x: x, y: y)
        } else {
            return CGPoint(x: 0, y: 0)
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
