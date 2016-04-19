//
//  Created by Oktawian Chojnacki on 09.03.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import GrandCentralBoardCore
@testable import GrandCentralBoard


class AutoStackTests: XCTestCase {

    let autoStack: AutoStack = AutoStack()
    
    func testStackedSixViews() {

        let viewsCount = 6

        for _ in 1...viewsCount {
            let view = UIView()
            autoStack.stackView(view)
        }

        XCTAssertEqual(autoStack.stackedViews.count, 50)
    }
}
