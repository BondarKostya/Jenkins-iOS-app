//
//  HealthReport.swift
//  Jenkins-iOS
//
//  Created by mini on 10/6/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import UIKit
//MARK:- Project weather
enum ProjectWeather {
    
    case sunny
    case cloud
    case thunder
    case none
    
    func image() -> UIImage {
        switch self {
        case .sunny:
            return UIImage(named: "weather_sunny")!
        case .cloud:
            return UIImage(named: "weather_cloud")!
        case .thunder:
            return UIImage(named: "weather_thunder")!
        case .none:
            return UIImage()
        }
        
    }
    
    init(withJSON json: JSON) {
        let score = json["score"] as? Int ?? 0
        
        switch score {
        case 100:
            self = .sunny
        case 1..<100:
            self = .cloud
        case 0:
            self = .thunder
        default:
            self = .none
        }
    }
    
    func desctiption() -> String {
        switch self {
        case .sunny:
            return "sunny"
        case .cloud:
            return "cloud"
        case .thunder:
            return "thunder"
        case .none:
            return ""
        }
    }
}

