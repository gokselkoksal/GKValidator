//
//  UITextField+GKValidator.swift
//  GKValidator
//
//  Created by Göksel Köksal on 09/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import GKValidator

extension UITextField : ValidatableField {
    
    public var fieldValue: AnyObject? {
        get {
            return self.text
        }
        set {
            self.text = newValue as? String
        }
    }
    
    public func addFieldValueChangedEventForTarget(target: AnyObject?, action: Selector) {
        self.addTarget(target, action: action, forControlEvents: .EditingChanged)
    }
    
    public func removeFieldValueChangedEventFromTarget(target: AnyObject?, action: Selector) {
        self.removeTarget(target, action: action, forControlEvents: .EditingChanged)
    }
}
