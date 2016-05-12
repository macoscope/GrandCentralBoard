//
// Attachment.swift
//
// Copyright © 2016 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public struct Attachment {
    
    public let fallback: String?
    public let color: String?
    public let pretext: String?
    public let authorName: String?
    public let authorLink: String?
    public let authorIcon: String?
    public let title: String?
    public let titleLink: String?
    public let text: String?
    public let fields: [AttachmentField]?
    public let imageURL: String?
    public let thumbURL: String?

    internal init?(attachment: [String: AnyObject]?) {
        fallback = attachment?["fallback"] as? String
        color = attachment?["color"] as? String
        pretext = attachment?["pretext"] as? String
        authorName = attachment?["author_name"] as? String
        authorLink = attachment?["author_link"] as? String
        authorIcon = attachment?["author_icon"] as? String
        title = attachment?["title"] as? String
        titleLink = attachment?["title_link"] as? String
        text = attachment?["text"] as? String
        imageURL = attachment?["image_url"] as? String
        thumbURL = attachment?["thumb_url"] as? String
        fields = (attachment?["fields"] as? [[String: AnyObject]])?.objectArrayFromDictionaryArray({(field) -> AttachmentField? in
            return AttachmentField(field: field)
        })
    }
    
    public init?(fallback: String, title:String, colorHex: String? = nil, pretext: String? = nil, authorName: String? = nil, authorLink: String? = nil, authorIcon: String? = nil, titleLink: String? = nil, text: String? = nil, fields: [AttachmentField]? = nil, imageURL: String? = nil, thumbURL: String? = nil) {
        self.fallback = fallback
        self.color = colorHex
        self.pretext = pretext
        self.authorName = authorName
        self.authorLink = authorLink
        self.authorIcon = authorIcon
        self.title = title
        self.titleLink = titleLink
        self.text = text
        self.fields = fields
        self.imageURL = imageURL
        self.thumbURL = thumbURL
    }
    
    internal func dictionary() -> [String: AnyObject] {
        var attachment = [String: AnyObject]()
        attachment["fallback"] = fallback
        attachment["color"] = color
        attachment["pretext"] = pretext
        attachment["authorName"] = authorName
        attachment["author_link"] = authorLink
        attachment["author_icon"] = authorIcon
        attachment["title"] = title
        attachment["title_link"] = titleLink
        attachment["text"] = text
        attachment["fields"] = fieldJSONArray(fields)
        attachment["image_url"] = imageURL
        attachment["thumb_url"] = thumbURL
        return attachment
    }
    
    private func fieldJSONArray(fields: [AttachmentField]?) -> [[String: AnyObject]] {
        var returnValue = [[String: AnyObject]]()
        if let f = fields {
            for field in f {
                returnValue.append(field.dictionary())
            }
        }
        return returnValue
    }
    
}

public struct AttachmentField {
    
    public let title: String?
    public let value: String?
    public let short: Bool?
    
    internal init?(field: [String: AnyObject]?) {
        title = field?["title"] as? String
        value = field?["value"] as? String
        short = field?["short"] as? Bool
    }
    
    public init(title:String, value:String, short: Bool? = nil) {
        self.title = title
        self.value = value.slackFormatEscaping()
        self.short = short
    }
    
    internal func dictionary() -> [String: AnyObject] {
        var field = [String: AnyObject]()
        field["title"] = title
        field["value"] = value
        field["short"] = short
        return field
    }
    
}
