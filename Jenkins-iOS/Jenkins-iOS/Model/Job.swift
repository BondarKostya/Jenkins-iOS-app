//
//  Job.swift
//  Jenkins-iOS
//
//  Created by mini on 10/6/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation


class Job {
    
    private(set) var builds: [Build] = []
    private(set) var buildable: Bool?
    private(set) var lastBuildStatus: BuildStatus = .disable
    private(set) var projectWeather: ProjectWeather = .none
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
            self.lastBuildStatus = BuildStatus(withColor: color)
        }
        
        if let healthReports = json["healthReport"] as? [JSON] {
            for healthReportJSON in healthReports {
                let report = ProjectWeather(withJSON: healthReportJSON)
                self.projectWeather = report
                break
            }
        }
        
    }
    
    func setJobStatus(status: BuildStatus) {
        self.lastBuildStatus = status
    }
    
    func addBuilds(_ builds:[Build]) {
        self.builds.append(contentsOf: builds)
    }
    
    func clearBuilds() {
        self.builds.removeAll()
    }
}
