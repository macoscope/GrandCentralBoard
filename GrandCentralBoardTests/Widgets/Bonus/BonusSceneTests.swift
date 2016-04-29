//
//  BonusSceneTests.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 29.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import XCTest
import Nimble
@testable import GrandCentralBoard


final class BonusSceneTests: XCTestCase {

    var scene: BonusScene!

    var paddingX: CGFloat {
        return scene.relativeScenePadding.x * scene.frame.width
    }
    var paddingY: CGFloat {
        return scene.relativeScenePadding.y * scene.frame.height
    }
    var paddingFrame: CGRect {
        let frame = scene.frame
        return CGRect(x: frame.minX + paddingX,
                                      y: frame.minY + paddingY,
                                      width: frame.width - 2 * paddingX,
                                      height: frame.height - 2 * paddingY)
    }

    override func setUp() {
        super.setUp()
        scene = BonusScene(size: CGSize(width: 400, height: 500))
    }


    func testSceneNodesNotToSmall() {
        var frame = paddingFrame
        expect(self.scene.areNodesToSmallWithAccumulatedFrame(frame)) == false

        frame.origin.y += 10
        frame.size.height -= 10
        expect(self.scene.areNodesToSmallWithAccumulatedFrame(frame)) == false

        frame.origin.x += 100
        frame.size.width -= 100
        expect(self.scene.areNodesToSmallWithAccumulatedFrame(frame)) == false

        frame = paddingFrame
        frame.origin.x += 80
        frame.size.width -= 200
        expect(self.scene.areNodesToSmallWithAccumulatedFrame(frame)) == false

        frame = paddingFrame
        frame.origin.y += 80
        frame.size.height -= 200
        expect(self.scene.areNodesToSmallWithAccumulatedFrame(frame)) == false
    }

    func testSceneNeedsToResize() {
        var frame = paddingFrame

        frame.origin.y += 10
        frame.size.height -= 20
        frame.origin.x += 10
        frame.size.width -= 20
        expect(self.scene.areNodesToSmallWithAccumulatedFrame(frame)) == true
    }
}
