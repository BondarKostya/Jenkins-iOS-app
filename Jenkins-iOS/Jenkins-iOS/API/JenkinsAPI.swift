//
//  JenkinsAPI.swift
//  Jenkins-iOS
//
//  Created by mini on 10/5/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import SWXMLHash

typealias JSON = [String: AnyObject]

public class JenkinsAPI {
    
    static let sharedInstance = JenkinsAPI()
    
    private(set) var domainName:String
    private(set) var port:Int
    private(set) var path:String
    private(set) var password:String
    private(set) var userId:String
    
    private var jenkinsURL:URL?
    
    private var networkClient:NetworkClient?
    
    func jenkinsInit(domainName: String, port: Int, path:String, networkClient:NetworkClient) {
        self.domainName = domainName
        self.path = path
        self.port = port
        self.networkClient = networkClient
        
        let urlString = "http://\(self.domainName):\(self.port)/"
        guard let url = URL(string: urlString) else {
            return
        }
        
        self.jenkinsURL = url

    }
    private init() {
        self.domainName = ""
        self.port = 0
        self.path = ""
        self.userId = ""
        self.password = ""
    }
    
    func fetchJobs(callback: @escaping ([Job], Error?) -> Void)  {
        let escapedString = "\(jenkinsURL!.absoluteString)api/json?tree=jobs[name,url,color,healthReport[score]]"
        guard let url = URL(string: escapedString) else {
                return
        }
        
        self.networkClient?.get(path: url, encodeAuth:encodedAuthorizationHeader, serializer: JSONResponseSerializer(), { (response, error) in
            if let error = error as? NSError {
                if  error.code >= 400 {
                    callback([], JenkinsError.generateJenkinsError(httpStatusCode: error.code))
                }else {
                    callback([], error)
                }
                return
            }
            
            guard let jsonWithJobs = response as? JSON ,
                let jsonJobs = jsonWithJobs["jobs"] as? [JSON] else {
                callback([],nil)
                return
            }
            
            let jobs = jsonJobs.map{ json in
                return Job(json:json)
            }
            
            callback(jobs,nil)
        })
    }
    
    func loginRequest(login userLogin: String, password userPassword:String, handler:@escaping (Bool, Error?) -> Void) {
        self.userId = userLogin
        self.password = userPassword
        
        guard let url = URL(string: jenkinsURL!.absoluteString)?
            .appendingPathComponent("user")
            .appendingPathComponent(userLogin)
            .appendingPathComponent("api")
            .appendingPathComponent("json") else {
                return
        }
        self.networkClient?.get(path: url, encodeAuth: encodedAuthorizationHeader, serializer: JSONResponseSerializer(), { (responce, error) in
 
            if let error = error as? NSError {
                if  error.code >= 400 {
                    handler(false, JenkinsError.generateJenkinsError(httpStatusCode: error.code))
                }else {
                    handler(false, error)
                }
            } else {
                handler(true, nil)
            }
        })
    }
    
    func fetchBuilds(withJob jobName: String, callback: @escaping (_ builds:[Build], _ error : Error?) -> Void)  {
        let encodedJob = jobName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        let escapedString = "\(jenkinsURL!.absoluteString)job/\(encodedJob!)/api/json?tree=builds[displayName,result,timestamp,url]"
        
        guard let url = URL(string: escapedString) else {
            return
        }
        self.networkClient?.get(path: url, encodeAuth:encodedAuthorizationHeader, serializer: JSONResponseSerializer(), { (response, error) in
            if let error = error as? NSError {
                if  error.code >= 400 {
                    callback([], JenkinsError.generateJenkinsError(httpStatusCode: error.code))
                }else {
                    callback([], error)
                }
                return
            }
            
            guard let jsonWithJobs = response as? JSON ,
                let jsonJobs = jsonWithJobs["builds"] as? [JSON] else {
                    callback([],nil)
                    return
            }
            
            let builds = jsonJobs.map{ json in
                return Build(json: json)
            }
            callback(builds,nil)
            
        })
    }
    
    func fetchConsoleOutput(withBuildURL buildURL: String , callback: @escaping (_ consoleOutput:String, _ error : Error?) -> Void)  {
        
        let escapedString = "\(buildURL)consoleText"
        guard let url = URL(string: escapedString) else {
            return
        }
        
        self.networkClient?.get(path: url, encodeAuth:encodedAuthorizationHeader,  { (response, error) in
            if let error = error as? NSError {
                if  error.code >= 400 {
                    callback("", JenkinsError.generateJenkinsError(httpStatusCode: error.code))
                }else {
                    callback("", error)
                }
                return
            }
            
            guard let consoleOutput = response as? String else {
                     callback("", nil)
                    return
            }
            
            callback(consoleOutput,nil)
        })
    }
    
    func fetchBuildParameters(withJobURL jobURL: String, callback: @escaping (_ buildParameters: [BuildParameter?], _ error : Error?) -> Void)  {
        let escapedString = "\(jobURL)config.xml"
        
        guard let url = URL(string: escapedString) else {
            return
        }
        
        self.networkClient?.get(path: url, encodeAuth:encodedAuthorizationHeader, { (response, error) in
            if let error = error as? NSError {
                if  error.code >= 400 {
                    callback([], JenkinsError.generateJenkinsError(httpStatusCode: error.code))
                }else {
                    callback([], error)
                }
                return
            }
            
            guard let xmlConfig = response as? String else {
                callback([],nil)
                return
            }
            
            let buildParameters = JenkinsXMLParser().convertXMLToBuildParatemers(withXMLString: xmlConfig)
            
            callback(buildParameters,nil)
        })
        
    }
    
    
    
    func build(_ name: String, parameters: [String : String], _ handler: @escaping (_ error: Error?) -> Void) {
        guard let url = URL(string: jenkinsURL!.absoluteString)?
            .appendingPathComponent("job")
            .appendingPathComponent(name)
            .appendingPathComponent("buildWithParameters") else {
                return
        }
        
        self.networkClient?.post(path: url, encodeAuth:encodedAuthorizationHeader, serializer: JSONResponseSerializer(), params: parameters as [String : AnyObject]) { response, error in
            if let error = error as? NSError {
                if  error.code >= 400 {
                    handler(JenkinsError.generateJenkinsError(httpStatusCode: error.code))
                }else {
                    handler(error)
                }
                return
            }
        }
    }
    
    private var encodedAuthorizationHeader: String {
        if let encoded = "\(userId):\(password)"
            .data(using: String.Encoding.utf8)?
            .base64EncodedString() {
            return "Basic \(encoded)"
        }
        
        return ""
    }
}
