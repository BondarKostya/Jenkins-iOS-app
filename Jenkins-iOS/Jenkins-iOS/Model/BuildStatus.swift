//
//  BuildStatus.swift
//  Jenkins-iOS
//
//  Created by mini on 10/11/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

public enum BuildStatus {
    case failed
    case unstable
    case success
    case pending
    case disable
    case aborted
    
    init(withColor colorString: String) {
        switch(colorString) {
        case "blue":
            self = .success
        case "red":
            self = .failed
        case "yellow":
            self = .unstable
        case "disabled":
            self = .disable
        default:
            self = .aborted
            
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .failed:
            return UIColor.red
        case .unstable:
            return UIColor.yellow
        case .success:
            return UIColor.blue
        case .pending:
            return UIColor.lightGray
        case .disable:
            return UIColor.lightGray
        case .aborted:
            return UIColor.lightGray
        }
        
    }
    
    
    func desctiption() -> String {
        switch self {
        case .failed:
            return "failed"
        case .unstable:
            return "unstable"
        case .success:
            return "success"
        case .pending:
            return "pending"
        case .disable:
            return "disable"
        case .aborted:
            return "aborted"
        }
    }
}
