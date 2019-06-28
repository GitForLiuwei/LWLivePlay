//
//  CollectItemController.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/6/18.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class CollectItemController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
