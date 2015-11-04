//
//  ValidationError.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

public class ValidationError: NSError {
    
    public static let domain = "me.gk.GKValidator.ValidationError"
    
    convenience public init(
        domain: String = ValidationError.domain,
        code: Int,
        localizedDescription: String?,
        userInfo dict: [NSObject: AnyObject]? = nil)
    {
        var userInfoDict: [NSObject: AnyObject]
        
        if let dict = dict {
            userInfoDict = dict
        }
        else {
            userInfoDict = [NSObject: AnyObject]()
        }
        
        if let localizedDescription = localizedDescription {
            userInfoDict[NSLocalizedDescriptionKey] = localizedDescription
        }
        
        self.init(domain: domain, code: code, userInfo: userInfoDict)
    }
}
