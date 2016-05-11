//
// NetworkInterface.swift
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

internal struct NetworkInterface {
    
    private let apiUrl = "https://slack.com/api/"
    
    internal func request(endpoint: SlackAPIEndpoint, token: String, parameters: [String: AnyObject]?, successClosure: ([String: AnyObject])->Void, errorClosure: (SlackError)->Void) {
        var requestString = "\(apiUrl)\(endpoint.rawValue)?token=\(token)"
        if let params = parameters {
            requestString += requestStringFromParameters(params)
        }
        let request = NSURLRequest(URL: NSURL(string: requestString)!)
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, internalError) -> Void in
            guard let data = data else {
                errorClosure(SlackError.ClientNetworkError)
                return
            }
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
                if (result["ok"] as! Bool == true) {
                    successClosure(result)
                } else {
                    if let errorString = result["error"] as? String {
                        throw ErrorDispatcher.dispatch(errorString)
                    } else {
                        throw SlackError.UnknownError
                    }
                }
            } catch let error {
                if let slackError = error as? SlackError {
                    errorClosure(slackError)
                } else {
                    errorClosure(SlackError.UnknownError)
                }
            }
        }.resume()
    }
    
    internal func uploadRequest(token: String, data: NSData, parameters: [String: AnyObject]?, successClosure: ([String: AnyObject])->Void, errorClosure: (SlackError)->Void) {
        var requestString = "\(apiUrl)\(SlackAPIEndpoint.FilesUpload.rawValue)?token=\(token)"
        if let params = parameters {
            requestString = requestString + requestStringFromParameters(params)
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: requestString)!)
        request.HTTPMethod = "POST"
        let boundaryConstant = randomBoundary()
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        let boundaryStart = "--\(boundaryConstant)\r\n"
        let boundaryEnd = "--\(boundaryConstant)--\r\n"
        let contentDispositionString = "Content-Disposition: form-data; name=\"file\"; filename=\"\(parameters!["filename"])\"\r\n"
        let contentTypeString = "Content-Type: \(parameters!["filetype"])\r\n\r\n"

        let requestBodyData : NSMutableData = NSMutableData()
        requestBodyData.appendData(boundaryStart.dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBodyData.appendData(contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBodyData.appendData(contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBodyData.appendData(data)
        requestBodyData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBodyData.appendData(boundaryEnd.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.HTTPBody = requestBodyData

        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, internalError) -> Void in
            guard let data = data else {
                return
            }
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
                if (result["ok"] as! Bool == true) {
                    successClosure(result)
                } else {
                    if let errorString = result["error"] as? String {
                        throw ErrorDispatcher.dispatch(errorString)
                    } else {
                        throw SlackError.UnknownError
                    }
                }
            } catch let error {
                if let slackError = error as? SlackError {
                    errorClosure(slackError)
                } else {
                    errorClosure(SlackError.UnknownError)
                }
            }
            }.resume()
    }
    
    private func randomBoundary() -> String {
        return String(format: "slackkit.boundary.%08x%08x", arc4random(), arc4random())
    }
    
    private func requestStringFromParameters(parameters: [String: AnyObject]) -> String {
        var requestString = ""
        for key in parameters.keys {
            if let value = parameters[key] as? String, encodedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) {
                requestString += "&\(key)=\(encodedValue)"
            } else if let value = parameters[key] as? Int {
                requestString += "&\(key)=\(value)"
            }
        }
        
        return requestString
    }
    
}
