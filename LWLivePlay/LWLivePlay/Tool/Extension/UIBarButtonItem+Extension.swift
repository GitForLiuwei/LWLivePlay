//
//  UIBarButtonItem+Extension.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/5/31.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String, selectImageName: String = "", size: CGSize = CGSize.zero, target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        if selectImageName != "" {
            btn.setImage(UIImage(named: selectImageName), for: .selected)
        }
        
        if size != CGSize.zero {
            btn.frame.size = size
        }else {
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: controlEvents)
        
        self.init(customView : btn)
    }
}
