//
//  NetworkManager.swift
//  Jenkins-iOS
//
//  Created by mini on 10/5/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import SWXMLHash

private let ApiClientTimeout: TimeInterval = 30

internal enum RequestMethod {
    case GET
    case POST
    
    func stringValue() -> String {
        switch self {
        case .GET:  return "GET"
        case .POST: return "POST"
        }
    }
}

class NetworkClient:NSObject {
    
    func get(path: URL, encodeAuth:String!, rawResponse: Bool = false, params: [String : AnyObject] = [:],_ handler: @escaping (AnyObject?, Error?) -> Void) {
        let request: URLRequest = requestFor(path,encodeAuth:encodeAuth, method: .GET, params: params)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            self.decodeResponse(response, rawOutput: rawResponse, data: data, error: error, handler: handler)
        }
        
        task.resume()
    }
    
    func post(path: URL, encodeAuth:String!, rawResponse: Bool = false, params: [String : AnyObject] = [:],_ handler: @escaping (AnyObject?, Error?) -> Void) {
        let request: URLRequest = requestFor(path,encodeAuth:encodeAuth, method: .POST, params: params)

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request) { data, response, error in
            self.decodeResponse(response, rawOutput: rawResponse, data: data, error: error, handler: handler)
        }
        
        task.resume()
    }
    
    private func requestFor(_ url: URL,encodeAuth:String!, method: RequestMethod, params: [String : AnyObject] = [:]) -> URLRequest {
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: ApiClientTimeout)
        request.httpMethod = method.stringValue()
        request.addValue(encodeAuth, forHTTPHeaderField: "Authorization")
        return request
    }
    private func decodeResponse(_ response: URLResponse?, rawOutput: Bool, data: Data?, error: Error?, handler: @escaping (AnyObject?, Error?) -> Void) {
        guard let data = data else {
            handler(nil, error)
            return
        }
        
        if let _ = error {
            handler(nil, error)
            return
        }
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode >= 400 {
                print(response)
                let userInfo: [NSObject : String] =
                [
                        NSLocalizedDescriptionKey as NSObject : JenkinsError.description(httpStatusCode: response.statusCode)
                ]
                let error = NSError(domain: "", code: response.statusCode, userInfo: userInfo)
                handler(nil, error)
            }
        }

        if rawOutput {
            handler(String(data: data, encoding: String.Encoding.utf8) as AnyObject?, nil)
        } else {
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            handler(json as AnyObject?, nil)
        }
    }
}

extension NetworkClient: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}
