//
//  LWPageStyle.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/6/3.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class LWPageStyle {

    var pageTitleViewHeight : CGFloat   = 44
    
    var titleNormalColor    : UIColor   = UIColor(r: 0, g: 0, b: 0)
    var titleSelectColor    : UIColor   = UIColor(r: 255, g: 128, b: 1)
    var titleFont           : UIFont    = UIFont.systemFont(ofSize: 15.0)
    
    var isScaleEnable       : Bool      = false
    var titleFontScale      : CGFloat   = 1.2
    
    var isScrollEnable      : Bool      = false
    var titleMargin         : CGFloat   = 20
    
    var isHaveScrollLine    : Bool      = false
    var scrollLineHeight    : CGFloat   = 2
    var scrollLineMargin    : CGFloat   = 2
    var scrollLineColor     : UIColor   = UIColor(r: 255, g: 128, b: 1)
    
    var isHaveCoverView     : Bool      = false
    var coverViewColor      : UIColor   = UIColor.black
    var coverViewAlpha      : CGFloat   = 0.4
    var coverViewHeight     : CGFloat   = 25
    
}
