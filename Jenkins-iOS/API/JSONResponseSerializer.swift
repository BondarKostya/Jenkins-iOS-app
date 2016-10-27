//
//  JSONResponseSerializer.swift
//  Jenkins-iOS
//
//  Created by mini on 10/17/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

class JSONResponseSerializer : ResponseSerializer {
    override func serialize(data: Data) -> AnyObject? {
        let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        return json as AnyObject?
    }
}
