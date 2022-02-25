//
//  ExtensionLayOut.swift
//  RaoVat
//
//  Created by Trojans on 24/02/2022.
//  Copyright © 2022 Lê Nguyễn Ngọc Quý. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
    @IBInspectable
    var cornerRadius: CGFloat {
         get {
            return layer.cornerRadius
         }
         set {
             layer.cornerRadius = newValue
             
         }
       }

}
