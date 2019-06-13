//
//  HomeViewController.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/5/31.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        setupUI()
    }

}

// MARK:设置UI界面
extension HomeViewController {
    private func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        //setNavagationBar()
        setPageView()
    }
    
    private func setNavagationBar() {
        
        let logoImage = UIImage(named: "home-logo")
        let logoItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil);
        self.navigationItem.leftBarButtonItem = logoItem
        
        let collectItem = UIBarButtonItem(imageName: "search_btn_follow", target: self, action: #selector(collectItemClick), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = collectItem
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 180, height: 32))
        searchBar.placeholder = "主播昵称/房间号/链接"
        searchBar.searchBarStyle = .minimal
        self.navigationItem.titleView = searchBar
        
    }
    
    private func setPageView() {
        
        let pageStyle = LWPageStyle()
        
        //pageStyle.isScrollEnable = false
        
        let pageViewFrame = CGRect(x: 0, y: kStatuBarHeight + (navigationController?.navigationBar.h ?? 0), width: view.w, height: view.h)
        
        //let pageViewFrame = CGRect(x: 0, y: kStatuBarHeight + 52, width: view.w, height: view.h)
        //print(kStatuBarHeight + (navigationController?.navigationBar.h ?? 0))
        //print(navigationController?.navigationBar.frame.maxY ?? 0)
        
        let titles = ["00000", "11111", "22222", "333333333", "444444444444", "55", "6666", "777777"];
        var vcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            vcs.append(vc)
        }
        
        let pageView = LWPageView(frame: pageViewFrame, titles: titles, childVCs: vcs, parentController: self, pageStyle: pageStyle)
        view.addSubview(pageView)
        
    }
}


// MARK:监听点击事件
extension HomeViewController {
    @objc private func collectItemClick() {
        print("collectItemClick")
    }
}
