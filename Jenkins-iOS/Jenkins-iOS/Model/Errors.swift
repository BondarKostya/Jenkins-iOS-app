//
//  Errors.swift
//  Jenkins
//
//  Created by Patrick Butkiewicz on 8/24/16.
//
//

import Foundation

public struct JenkinsError{
    
    static func generateJenkinsError(httpStatusCode: Int) -> Error {
        let userInfo: [NSObject : String] =
        [
                NSLocalizedDescriptionKey as NSObject : JenkinsError.description(httpStatusCode: httpStatusCode)
        ]
        let jenkinsError = NSError(domain: "", code: httpStatusCode, userInfo: userInfo)
        
        return jenkinsError
    }
    
    static func description(httpStatusCode: Int) -> String {
        switch httpStatusCode {
        case 400:
            return "\(httpStatusCode) - Job requires parameters to build"
        case 404:
            return "\(httpStatusCode) - Resource not found"
        case 403:
            return "\(httpStatusCode) - Session not authorized"
        case 401:
            return "\(httpStatusCode) - Invalid login/password"
        default:
            return "\(httpStatusCode) - Unknown error"
        }
    }
    
}

