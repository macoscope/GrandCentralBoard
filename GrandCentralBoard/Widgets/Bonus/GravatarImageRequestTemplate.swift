//
//  GravatarImageRequestTemplate.swift
//  GrandCentralBoard
//
//  Created by Rafal Augustyniak on 08/04/16.
//


import UIKit
import MD5


final class GravatarImageRequestTemplate: RequestTemplate<UIImage?> {

    init?(email: String) {
        let canonicalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
        if let md5Hash = canonicalEmail.md5Hash() {
            super.init(baseURL: NSURL.init(string: "http://www.gravatar.com/avatar/")!, path: md5Hash,
                       method: .Get(queryParameters: [:]), responseResultType: .Data)
        } else {
            return nil
        }
    }

    override func finalizeWithResponse(response: NSURLResponse, result: AnyObject) throws -> UIImage? {
        guard let data = result as? NSData else {
            throw RequestTemplateError.FinalizeError
        }
        return UIImage.init(data: data)
    }

}
