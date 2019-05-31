//
//  Bundle+Extension.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/5/31.
//  Copyright © 2019 liuwei. All rights reserved.
//

import Foundation

extension Bundle {
    var namespace : String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
