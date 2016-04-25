//
//  UIDevice + Extension.swift
//  Demo
//
//  Created by 黄人煌 on 16/2/22.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

extension UIDevice {
    
    class func currentDeviceScreenMeasurement() -> CGFloat {
        var deviceScree: CGFloat = 3.5
        
        if ((568 == AppHeight  && 320 == AppWidth) || (1136 == AppHeight && 640 == AppHeight)) {
            deviceScree = 4.0;
        } else if ((667 == AppHeight && 375 == AppWidth) || (1334 == AppHeight && 750 == AppWidth)) {
            deviceScree = 4.7;
        } else if ((736 == AppHeight && 414 == AppWidth) || (2208 == AppHeight && 1242 == AppWidth)) {
            deviceScree = 5.5;
        }
        
        return deviceScree
    }
}
