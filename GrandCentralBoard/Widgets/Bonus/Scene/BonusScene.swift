//
//  Created by Krzysztof Werys on 23/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import SpriteKit

private let pokeTimeInterval: NSTimeInterval = 8
private let resizeWorldInterval: NSTimeInterval = 0.2
private let unitSceneResizeChange: CGFloat = 0.02

class BonusScene: SKScene {
    
    private var viewModel: BonusWidgetViewModel!
    private let world = SKNode()

    override func didMoveToView(view: SKView) {
        assert(viewModel != nil)
        setUpWithViewModel(viewModel)

        NSTimer.scheduledTimerWithTimeInterval(pokeTimeInterval, target: self, selector: #selector(BonusScene.pokeAllBubbles), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(resizeWorldInterval, target: self, selector: #selector(BonusScene.updateWorldSize), userInfo: nil, repeats: true)
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

    func updateWorldSize() {
        guard !world.children.isEmpty else { return }

        let calculatedAccumulatedFrame = world.calculateAccumulatedFrame()
        let nodesFitScreen = CGRectContainsRect(frame, calculatedAccumulatedFrame)
        let nodesToSmall = frame.width > calculatedAccumulatedFrame.width * 1.25 && frame.height > calculatedAccumulatedFrame.height * 1.25
        if !nodesFitScreen {
            scaleBy(1 - unitSceneResizeChange)
        } else if (nodesToSmall) {
            scaleBy(1 + unitSceneResizeChange)
        }
    }

    private func updateWithViewModel(viewModel: BonusWidgetViewModel) {
        self.viewModel = viewModel
        addOrUpdateBubbles()
        removeOldBubbleIfNecessary()
    }

    private func addOrUpdateBubbles() {
        for bubbleViewModel in viewModel.bubbles {
            guard let bubble = world.childNodeWithName(bubbleViewModel.name) as? Bubble else {
                let newBubble = Bubble(bubbleViewModel: bubbleViewModel)
                newBubble.position = randomPosition()
                self.world.addChild(newBubble)
                continue
            }

            bubble.updateWithLastBonusDate(bubbleViewModel.lastBonusDate)
            bubble.updateImage(bubbleViewModel.image)
        }
    }

    private func removeOldBubbleIfNecessary() {
        for node in world.children {
            guard let bubble = node as? Bubble else {
                continue
            }

            let bubbleExistsInNewestViewModel = viewModel.bubbles.contains({ return $0.name == bubble.name })
            if !bubbleExistsInNewestViewModel {
                bubble.removeFromParent()
            }
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

    private func scaleBy(scale: CGFloat, duration: NSTimeInterval = resizeWorldInterval) {
        let action = SKAction.scaleBy(scale, duration: resizeWorldInterval)
        action.timingMode = .Linear
        world.runAction(action)
    }
}
