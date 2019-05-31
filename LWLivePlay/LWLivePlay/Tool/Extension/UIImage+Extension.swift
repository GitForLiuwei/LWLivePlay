//
//  UIImage+Extension.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/5/31.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

extension UIImage {
    var original : UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}
