//
//  File.swift
//  Jenkins-iOS
//
//  Created by mini on 10/13/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

public protocol CellWithSelectedValue {
    func getSelectedValue() -> (name: String, value: String)
}
