//
//  JenkinsAPI.swift
//  Jenkins-iOS
//
//  Created by mini on 10/5/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

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
    
    func jenkinsInit(domainName: String!, port: Int!, path:String!,userId: String!,password: String!, networkClient:NetworkClient!) {
        self.domainName = domainName
        self.path = path
        self.port = port
        self.userId = userId
        self.password = password
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
    
    func fetchJobs(callback: @escaping ([Job],Error?) -> Void)  {
        guard let url = URL(string: jenkinsURL!.absoluteString)?
            .appendingPathComponent("api")
            .appendingPathComponent("json") else {
                //handler(JenkinsError.InvalidJenkinsURL)
                return
        }
        self.networkClient?.get(path: url,encodeAuth:encodedAuthorizationHeader, { (response, error) in
            print(response)
            if (error != nil) {
                callback([],error)
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
    
    func fetchJob(_ jobName: String ,callback: @escaping (_ job:Job?) -> Void)  {
        guard let url = URL(string: jenkinsURL!.absoluteString)?
            .appendingPathComponent("job")
            .appendingPathComponent(jobName)
            .appendingPathComponent("api")
            .appendingPathComponent("json") else {
                //handler(JenkinsError.InvalidJenkinsURL)
                return
        }
        self.networkClient?.get(path: url,encodeAuth:encodedAuthorizationHeader, { (response, error) in
            print(response)
            guard let json = response as? JSON else {
                    callback(nil)
                    return
            }
            
            let job = Job(json:json)
            
            callback(job)
            
        })
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
