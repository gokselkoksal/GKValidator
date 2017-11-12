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
    
    public var fieldValue: Any? {
        get {
            return self.text
        }
        set {
            self.text = newValue as? String
        }
    }
    
    public func addFieldValueChangedEvent(forTarget target: AnyObject?, action: Selector) {
        self.addTarget(target, action: action, for: .editingChanged)
    }
    
    public func removeFieldValueChangedEvent(fromTarget target: AnyObject?, action: Selector) {
        self.removeTarget(target, action: action, for: .editingChanged)
    }
}
