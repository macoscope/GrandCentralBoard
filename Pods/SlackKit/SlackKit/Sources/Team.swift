//
// Team.swift
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

public struct Team {
    
    public let id: String
    internal(set) public var name: String?
    internal(set) public var domain: String?
    internal(set) public var emailDomain: String?
    internal(set) public var messageEditWindowMinutes: Int?
    internal(set) public var overStorageLimit: Bool?
    internal(set) public var prefs: [String: AnyObject]?
    internal(set) public var plan: String?
    internal(set) public var icon: TeamIcon?
    
    internal init?(team: [String: AnyObject]?) {
        id = team?["id"] as! String
        name = team?["name"] as? String
        domain = team?["domain"] as? String
        emailDomain = team?["email_domain"] as? String
        messageEditWindowMinutes = team?["msg_edit_window_mins"] as? Int
        overStorageLimit = team?["over_storage_limit"] as? Bool
        prefs = team?["prefs"] as? [String: AnyObject]
        plan = team?["plan"] as? String
        icon = TeamIcon(icon: team?["icon"] as? [String: AnyObject])
    }
}

public struct TeamIcon {
    internal(set) public var image34: String?
    internal(set) public var image44: String?
    internal(set) public var image68: String?
    internal(set) public var image88: String?
    internal(set) public var image102: String?
    internal(set) public var image132: String?
    internal(set) public var imageOriginal: String?
    internal(set) public var imageDefault: Bool?
    
    internal init?(icon: [String: AnyObject]?) {
        image34 = icon?["image_34"] as? String
        image44 = icon?["image_44"] as? String
        image68 = icon?["image_68"] as? String
        image88 = icon?["image_88"] as? String
        image102 = icon?["image_102"] as? String
        image132 = icon?["image_132"] as? String
        imageOriginal = icon?["image_original"] as? String
        imageDefault = icon?["image_default"] as? Bool
    }
}

