//
//  MPVolumeViewExtension.swift
//  FrRadio
//
//  Created by Admin on 4/17/18.
//  Copyright © 2018 HCM. All rights reserved.
//

import MediaPlayer

extension MPVolumeView {
    var volumeSlider: UISlider? {
        for subview in subviews {
            if let v = subview as? UISlider {
                return v
            }
        }
        return nil
    }
}
