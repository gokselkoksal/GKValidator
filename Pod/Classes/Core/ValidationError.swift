//
//  ValidationError.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

public struct ValidationError: LocalizedError {
    
    public let code: Int
    public let message: String
    
    public init(code: Int = 0, message: String) {
        self.code = code
        self.message = message
    }
    
    public var errorDescription: String? {
        return message
    }
}
