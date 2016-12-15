//
//  ValidationError.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

open class ValidationError: NSError {
    
    open static let domain = "me.gk.GKValidator.ValidationError"
    
    convenience public init(
        domain: String = ValidationError.domain,
        code: Int,
        localizedDescription: String?,
        userInfo dict: [AnyHashable: Any]? = nil)
    {
        var userInfoDict: [AnyHashable: Any]
        
        if let dict = dict {
            userInfoDict = dict
        }
        else {
            userInfoDict = [AnyHashable: Any]()
        }
        
        if let localizedDescription = localizedDescription {
            userInfoDict[NSLocalizedDescriptionKey] = localizedDescription
        }
        
        self.init(domain: domain, code: code, userInfo: userInfoDict)
    }
}
