//
//  String.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 08/04/16.
//

import Foundation
import MD5


extension String {

    func md5Hash() -> String? {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        return data?.md5Hash()
    }

}