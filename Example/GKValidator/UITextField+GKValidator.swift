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
            return self.text as AnyObject?
        }
        set {
            self.text = newValue as? String
        }
    }
    
    public func addFieldValueChangedEventForTarget(_ target: AnyObject?, action: Selector) {
        self.addTarget(target, action: action, for: .editingChanged)
    }
    
    public func removeFieldValueChangedEventFromTarget(_ target: AnyObject?, action: Selector) {
        self.removeTarget(target, action: action, for: .editingChanged)
    }
}
