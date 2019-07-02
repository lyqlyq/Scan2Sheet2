//
//  UIViewExtensions.swift
//  iMusic
//
//  Created by Trinh Huy Cuong on 8/17/17.
//  Copyright © 2017 HCM. All rights reserved.
//

import UIKit

extension UIView {
    static func viewFromNib(named : String) -> UIView {
        return UINib(nibName: named, bundle: nil ).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.masksToBounds = true
    }
}
