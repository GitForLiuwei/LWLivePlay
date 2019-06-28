//
//  NibLoadable.swift
//  NibLoadable
//
//  Created by liuwei on 2019/6/27.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView {
    static func loadNibWithNibName(_ nibName : String? = nil) -> Self {
        let loadName = nibName == nil ? "\(self)" : nibName!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
