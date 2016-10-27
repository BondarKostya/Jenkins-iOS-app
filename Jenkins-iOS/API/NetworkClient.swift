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
    
    func request(withMethod method: RequestMethod,path: URL, encodeAuth:String!, serializer: ResponseSerializer = ResponseSerializer(), params: [String : AnyObject] = [:], _ handler: @escaping (AnyObject?, NSError?) -> Void) {

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        
        session.dataTask(with: requestFor(path, encodeAuth:encodeAuth, method: method, params: params)) { data, response, error in
            self.decodeResponse(response, serializer: serializer, data: data, error: error as? NSError, handler: handler)
        }.resume()

        
    }

    private func requestFor(_ url: URL,encodeAuth:String!, method: RequestMethod, params: [String : AnyObject] = [:]) -> URLRequest {
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: ApiClientTimeout)
        request.httpMethod = method.stringValue()
        request.addValue(encodeAuth, forHTTPHeaderField: "Authorization")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems: [URLQueryItem] = params.map {
            if let val = $0.value as? String {
                return URLQueryItem(name: $0.key, value: val)
            } else {
                return URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        }
        
        components?.queryItems = queryItems
        request.httpBody = components?.percentEncodedQuery?.data(using: String.Encoding.utf8)
        
        return request
    }
    private func decodeResponse(_ response: URLResponse?, serializer: ResponseSerializer, data: Data?, error: NSError?, handler: @escaping (AnyObject?, NSError?) -> Void) {
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
                let error = NSError(domain: "", code: response.statusCode, userInfo: nil)
                handler(nil, error)
                return
            }
        }

        let serializedData =  serializer.serialize(data: data)
        
        if let serializedData = serializedData {
            handler(serializedData, nil)
        }else {
            let userInfo: [NSObject : String] =
            [
                    NSLocalizedDescriptionKey as NSObject : "Serialization failed"
            ]
            let error = NSError(domain: "", code: 399 , userInfo: userInfo)
            
            handler(nil, error)
        }
        
    }
}
