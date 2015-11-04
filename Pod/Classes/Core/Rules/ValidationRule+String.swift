//
//  ValidationRule+String.swift
//  Pods
//
//  Created by Göksel Köksal on 04/11/15.
//
//

import Foundation

public extension ValidationRule where ValidatableType: StringLiteralConvertible {
    
    public init(minLength: UInt) {
        
        self.init(validationBlock: { value in
            if let string = value as? NSString {
                return string.length >= Int(minLength)
            }
            else {
                return false
            }
        });
    }
    
    public init(maxLength: UInt) {
        
        self.init(validationBlock: { value in
            if let string = value as? NSString {
                return string.length <= Int(maxLength)
            }
            else {
                return false
            }
        });
    }
    
    public init(characterSet: NSCharacterSet) {
        
        self.init(validationBlock: { value in
            if let string = value as? NSString {
                let trimmedString: NSString = string.stringByTrimmingCharactersInSet(characterSet)
                return trimmedString.length == 0
            }
            else {
                return false;
            }
            
        });
    }
}
