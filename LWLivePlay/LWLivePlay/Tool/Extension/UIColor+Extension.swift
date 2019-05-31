//
//  UIColor+Extension.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/5/31.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

extension UIColor {
    static var randomColor : UIColor {
        return UIColor(
            red:    CGFloat(arc4random_uniform(256) / 255),
            green:  CGFloat(arc4random_uniform(256) / 255),
            blue:   CGFloat(arc4random_uniform(256) / 255),
            alpha:  CGFloat(arc4random_uniform(256) / 255))
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0x00FF00) >> 8
        let b = (hex & 0x0000FF)
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
}
