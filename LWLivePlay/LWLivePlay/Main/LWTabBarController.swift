//
//  LWTabBarController.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/5/31.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

let kControllerName         =   "controllerName"
let kControllerTitle        =   "controllerTitle"
let kItemImageName          =   "itemImageName"
let kItemSelectImageName    =   "itemSelectImageName"

class LWTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarItemAttributes()
        setupUI()
    }
    
    func setTabBarItemAttributes() {
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], for: .selected)
    }
}

extension LWTabBarController {
    private func setupUI() {
        let controllerInfos = [
            ["controllerName" : "HomeViewController", "controllerTitle" : "home", "itemImageName" : "home_normal", "itemSelectImageName" : "home_selected"]
        ];
        var controllers = [UIViewController]()
        for controllerInfo in controllerInfos {
            let controller = initController(controllerInfo: controllerInfo)
            if let controller = controller {
                controllers.append(controller)
            }
        }
        viewControllers = controllers;
    }
    
    private func initController(controllerInfo: [String:String]) -> UIViewController? {
        guard
            let controllerName      = controllerInfo[kControllerName],
            let cls                 = NSClassFromString(Bundle.main.namespace + "." + controllerName) as? UIViewController.Type,
            let controllerTitle     = controllerInfo[kControllerTitle],
            let itemImageName       = controllerInfo[kItemImageName],
            let itemSelectImageName = controllerInfo[kItemSelectImageName]
        else {
            return nil;
        }
        
        let controller                      = cls.init()
        controller.title                    = controllerTitle
        controller.tabBarItem.image         = UIImage(named: itemImageName)?.original
        controller.tabBarItem.selectedImage = UIImage(named: itemSelectImageName)?.original
        
        return LWNavigationController.init(rootViewController: controller)
    }
}
