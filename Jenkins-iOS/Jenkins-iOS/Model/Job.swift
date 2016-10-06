//
//  Job.swift
//  Jenkins-iOS
//
//  Created by mini on 10/6/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

public enum JobColor: String {
    case Green
    case Red
    case DisabledGrey
    case UnbuiltGrey
    case Unknown
    
    init(color: String) {
        switch color {
        case "notbuilt":
            self = .UnbuiltGrey
        case "disabled":
            self = .DisabledGrey
        case "red":
            self = .Red
        case "green":
            self = .Green
        default:
            self = .Unknown
        }
    }
    
    public var description: String {
        return self.rawValue
    }
}


class Job {
    
    private(set) var builds: [Build] = []
    private(set) var buildable: Bool?
    private(set) var color: JobColor = .Unknown
    private(set) var displayName: String?
    private(set) var healthReports: [HealthReport] = []
    private(set) var name: String
    private(set) var url: String?

    init(json: JSON) {
        guard let url = json["url"] as? String,
            let name = json["name"] as? String else {
                self.name = ""
                self.url = ""
                return
        }
        
        self.name = name
        self.url = url
        
        if let builds = json["builds"] as? [JSON] {
            for buildDict in builds {
                let newBuild = Build(json: buildDict)
                self.builds.append(newBuild)
            }
        }
        
        if let buildable = json["buildable"] as? Bool {
            self.buildable = buildable
        }
//        
        if let color = json["color"] as? String {
            self.color = JobColor(color: color)
        }

        
        if let displayName = json["displayName"] as? String {
            self.displayName = displayName
        }
        
        if let healthReports = json["healthReport"] as? [JSON] {
            for healthReportJSON in healthReports {
                let report = HealthReport(json: healthReportJSON)
                self.healthReports.append(report)
            }
        }
        
    }
}
