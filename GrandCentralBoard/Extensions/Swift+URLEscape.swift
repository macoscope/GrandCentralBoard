//
//  Swift+URLEscape.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 08.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation

extension String {
    func URLEscape() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    }
}
