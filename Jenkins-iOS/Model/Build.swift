//
//  Build.swift
//  Jenkins-iOS
//
//  Created by mini on 10/6/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

public class Build {
    private(set) var name: String = ""
    private(set) var buildStatus: BuildStatus = .aborted
    private(set) var timestamp: Int = 0
    private(set) var url: String = ""
    
    init() {
        
    }
    func setupBuild(name: String, buildStatus: BuildStatus, timestamp: Int, url: String) {
        self.name = name
        self.buildStatus = buildStatus
        self.timestamp = timestamp
        self.url = url
    }
    
    init(name: String, buildStatus: BuildStatus, timestamp: Int, url: String) {
        self.setupBuild(name: name, buildStatus: buildStatus, timestamp: timestamp, url: url)
    }
}

public struct BuildParser {
    func constructBuild(json: JSON) -> Build {
        let build = Build()
        var name = ""
        var buildStatus = BuildStatus.aborted
        var timestamp = 0
        var url = ""
        if let displayName = json["displayName"] as? String {
            name = displayName
        }
        
        if let status = json["result"] as? String {
            buildStatus = BuildStatus(withStatus: status)
        }
        
        if let time = json["timestamp"] as? Int {
            timestamp = time
        }
        
        if let jsonUrl = json["url"] as? String {
            url = jsonUrl
        }
        
        build.setupBuild(name: name, buildStatus: buildStatus, timestamp: timestamp, url: url)
        
        return build
    }
}



