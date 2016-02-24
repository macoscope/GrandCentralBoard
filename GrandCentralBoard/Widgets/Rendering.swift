//
//  Created by Oktawian Chojnacki on 31.12.2015.
//  Copyright © 2015 Oktawian Chojnacki. All rights reserved.
//

import UIKit

enum RenderingState<DataToRender> {
    case Waiting
    case Rendering(DataToRender)
    case Failed
}

protocol ViewModelRendering {

    typealias ViewModel

    var state: RenderingState<ViewModel> { get }

    func render(viewModel: ViewModel)
    func failure()
}