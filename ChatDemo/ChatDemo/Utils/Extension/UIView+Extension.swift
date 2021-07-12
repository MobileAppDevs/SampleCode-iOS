//
//  UIView+Extension.swift
//  Nibou
//
//  Created by Himanshu Goyal on 15/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

/**
 MARK: - UIView Extension
*/

extension UIView {
    
    @IBInspectable var corners: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            guard let color = layer.borderColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue.cgColor
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    
    @IBInspectable var maxLength: Int {
        get {
            return 10
        }
        set {
            
        }
    }
    
    /* Rounds particular provided Corners. ONLY FOR IOS 11.0 and Later. */
    func roundCornerMask(cornerRadius:CGFloat, _ cornerMask: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        if #available(iOS 11.0, *) {
            self.clipsToBounds = false
            self.layer.cornerRadius = cornerRadius
            self.layer.maskedCorners = cornerMask
        }
    }

}

extension Double {
    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
