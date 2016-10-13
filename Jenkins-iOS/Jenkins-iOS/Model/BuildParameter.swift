//
//  BuildParameters.swift
//  Jenkins-iOS
//
//  Created by mini on 10/12/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

enum BuildParameterType {
    case boolean(defaultValue: Bool)
    case string(defaultValue: String)
    case text(defaultValue: String)
    case choise(choices: [String])
    
    func booleanValue() -> Bool? {
        switch self {
        case .boolean(let defaultValue):
            return defaultValue
        default:
            return nil
        }
    }
    
    func stringValue() -> String? {
        switch self {
        case .string(let defaultValue):
            return defaultValue
        default:
            return nil
        }
    }
    
    func textValue() -> String? {
        switch self {
        case .text(let defaultValue):
            return defaultValue
        default:
            return nil
        }
    }
    
    func choiseValue() -> [String]? {
        switch self {
        case .choise(let choises):
            return choises
        default:
            return nil
        }
    }
    
}

struct BuildParameter {
    let name: String
    let description: String
    let type: BuildParameterType
    
    init(name: String, description: String, type:BuildParameterType) {
        self.name = name
        self.description = description
        self.type = type
    }
}
