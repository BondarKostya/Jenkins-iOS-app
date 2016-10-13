//
//  Build.swift
//  Jenkins-iOS
//
//  Created by mini on 10/6/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

public struct Build {
    private(set) var name: String = ""
    private(set) var buildStatus: BuildStatus = .aborted
    private(set) var timestamp: Int = 0
    private(set) var url: String = ""
    
    init(json: JSON) {
        
        if let name = json["displayName"] as? String {
            self.name = name
        }

        if let status = json["result"] as? String {
            self.buildStatus = BuildStatus(withStatus: status)
        }
        
        if let timestamp = json["timestamp"] as? Int {
            self.timestamp = timestamp
        }
        
        if let url = json["url"] as? String {
            self.url = url
        }
    }
}



