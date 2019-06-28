//
//  ViewController.swift
//  NibLoadable
//
//  Created by liuwei on 2019/6/27.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let blueV = blueView.loadNibWithNibName()
        blueV.name = "liuwei"
        view.addSubview(blueV)
        
        let redV = redView.loadNibWithNibName()
        redV.age = 13
        view.addSubview(redV)
    }


}

