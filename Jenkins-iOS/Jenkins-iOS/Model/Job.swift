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
    private(set) var lastBuildStatus: BuildStatus = .disable
    private(set) var projectWeather: ProjectWeather = .none
    private(set) var name = ""
    private(set) var url = ""

    init() {
        
    }
    
    func setupJob(name: String, url: String, builds: [Build], lastBuildStatus: BuildStatus ,projectWeather: ProjectWeather ) {
        self.builds = builds
        self.lastBuildStatus = lastBuildStatus
        self.projectWeather = projectWeather
        self.name = name
        self.url = url
    }
    
    init(name: String, url: String, builds: [Build], lastBuildStatus: BuildStatus ,projectWeather: ProjectWeather ) {
        self.setupJob(name: name, url: url, builds: builds, lastBuildStatus: lastBuildStatus, projectWeather: projectWeather)
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

public struct JobParser {
    func constructJob(json: JSON) -> Job {
        let job = Job()
        var builds = [Build]()
        var lastBuildStatus = BuildStatus.disable
        var projectWeather = ProjectWeather.none
        var name = ""
        var url = ""
        
        if let urlJSON = json["url"] as? String {
            url = urlJSON
        }
        
        if let nameJSON = json["name"] as? String {
            name = nameJSON
        }
        
        if let buildsJson = json["builds"] as? [JSON] {
            for buildDict in buildsJson {
                let newBuild = BuildParser().constructBuild(json: buildDict)
                builds.append(newBuild)
            }
        }
        
        if let color = json["color"] as? String {
            lastBuildStatus = BuildStatus(withColor: color)
        }
        
        if let healthReports = json["healthReport"] as? [JSON] {
            for healthReportJSON in healthReports {
                let score = healthReportJSON["score"] as? Int ?? 0
                let report = ProjectWeather(withScore: score)
                projectWeather = report
                break
            }
        }
        
        job.setupJob(name: name, url: url, builds: builds, lastBuildStatus: lastBuildStatus, projectWeather: projectWeather)
        
        return job
    }
}
