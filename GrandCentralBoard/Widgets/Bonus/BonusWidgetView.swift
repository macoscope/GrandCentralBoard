//
//  Created by Krzysztof Werys on 24/02/16.
//  Copyright © 2016 Krzysztof Werys. All rights reserved.
//

import UIKit
import SpriteKit

final class BonusWidgetView: UIView {
    
    typealias ViewModel = BonusWidgetViewModel
    
    @IBOutlet private weak var bonusView: SKView!
    @IBOutlet private weak var activityView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
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
        guard let state = state else { return }
        switch (state, toState) {
            case (.Waiting, .Rendering(let viewModel)):
                transitionFromWaitingState()
                scene.setUpWithSceneModel(viewModel.sceneModel)
                bonusView.presentScene(scene)
            case (_, .Rendering(let viewModel)):
                scene.setUpWithSceneModel(viewModel.sceneModel)
            case (_, .Failed):
                transitionToFailedState()
            case (_, .Waiting):
                break
        }
    }
    
    private func transitionFromWaitingState() {
        UIView.animateWithDuration(0.3) {
            self.activityView.alpha = 0
        }
    }
    
    private func transitionToFailedState() {
        UIView.animateWithDuration(0.3) {
            self.activityIndicator.alpha = 0
        }
    }
    
    class func fromNib() -> BonusWidgetView {
        return NSBundle.mainBundle().loadNibNamed("BonusWidgetView", owner: nil, options: nil)[0] as! BonusWidgetView
    }
}
