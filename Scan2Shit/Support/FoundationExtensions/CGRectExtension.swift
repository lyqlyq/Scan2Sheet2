//
//  CGRectExtension.swift
//  MusicRadio
//
//  Created by Admin on 10/24/18.
//  Copyright © 2018 HCM. All rights reserved.
//

import UIKit

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
