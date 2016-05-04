//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

/**
 Views should show one of these states:

 - Waiting:   starting state, presenting some activity indicator. This state should be set **only** initially and never after).
 - Rendering: presenting information (after render method is called).
 - Failed:    data failed to load, should be avoided if possible.
 */
public enum RenderingState<DataToRender> {
    case Waiting
    case Rendering(DataToRender)
    case Failed
}

/**
 View can render ViewModels.
 */
public protocol ViewModelRendering {

    associatedtype ViewModel

    /// This state is to be read only for debug purposes, not for logic of any kind.
    var state: RenderingState<ViewModel> { get }

    /**
     Render ViewModel.

     **PLEASE NOTE:** The same ViewModel provided should result in the same visual state of the View.

     - parameter viewModel: a special kind of model having all the information about what the view should render.
     */
    func render(viewModel: ViewModel)

    /**
     This method will put view into failed state. Can be ignored.
     */
    func failure()
}
