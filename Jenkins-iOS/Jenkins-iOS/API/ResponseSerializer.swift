//
//  File.swift
//  Jenkins-iOS
//
//  Created by mini on 10/17/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

class ResponseSerializer {
    func serialize(data: Data) ->  AnyObject? {
        return (String(data: data, encoding: String.Encoding.utf8) as AnyObject?)
    }
}
