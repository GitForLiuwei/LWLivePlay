//
//  UIView+Extension.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/5/31.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        
        set {
            frame.origin.x = newValue
        }
        
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        
        set {
            frame.origin.y = newValue
        }
        
        get {
            return frame.origin.y
        }
    }
    
    var w: CGFloat {
        
        set {
            frame.size.width = newValue
        }
        
        get {
            return frame.size.width
        }
    }
    
    var h: CGFloat {
        
        set {
            frame.size.height = newValue
        }
        
        get {
            return frame.size.height
        }
    }
}
