//
//  HealthReport.swift
//  Jenkins-iOS
//
//  Created by mini on 10/6/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

public struct HealthReport {
    private(set) var report: String
    private(set) var iconClassName: String
    private(set) var score: Int
    
    init(json: JSON) {
        self.report = json["description"] as? String ?? ""
        self.iconClassName = json["iconClassName"] as? String ?? ""
        self.score = json["score"] as? Int ?? 0
    }
}
