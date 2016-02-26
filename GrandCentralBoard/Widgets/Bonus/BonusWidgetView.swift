//
//  Created by krris on 24/02/16.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit
import SpriteKit

final class BonusWidgetView: UIView {
    
    typealias ViewModel = BonusWidgetViewModel
    
    @IBOutlet private weak var bonusView: SKView!
    private var scene: BonusScene!
    
    private(set) var state: RenderingState<ViewModel> = .Waiting {
        didSet { handleTransitionFromState(oldValue, toState: state) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let scene = BonusScene(fileNamed:"BonusScene") else { return }
        
        self.scene = scene
        scene.scaleMode = .AspectFit
    }
    
    func render(viewModel: ViewModel) {
        state = .Rendering(viewModel)
    }

    func failure() {
        state = .Failed
    }
    
    func handleTransitionFromState(state: RenderingState<ViewModel>?, toState: RenderingState<ViewModel>) {
        switch (state, toState) {
            case (_, .Rendering(let viewModel)):
                scene.setUpWithSceneModel(viewModel.sceneModel)
                bonusView.presentScene(scene)
            case (_, .Failed):
                break
            case (_, .Waiting):
                break
        }
    }
    
    class func fromNib() -> BonusWidgetView {
        return NSBundle.mainBundle().loadNibNamed("BonusWidgetView", owner: nil, options: nil)[0] as! BonusWidgetView
    }
}
