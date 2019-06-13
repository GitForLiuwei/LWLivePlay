//
//  LWNavigationController.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/5/31.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class LWNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "", selectImageName: "", target: self, action: #selector(backClick), for: .touchUpInside)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @objc func backClick() {
        self.popViewController(animated: true)
    }
    
}
