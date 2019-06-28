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
        //testPageView()
        testPageCollectionView()
    }
    
    private func testPageCollectionView() {
        let titles : [String] = ["语文", "数学", "英语", "物理"]
        
        let pageStyle = LWPageStyle()
        pageStyle.isHaveScrollLine = true
        
        let collectionViewLayout = LWPageCollectionViewLayout()
        
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 20
        
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionViewLayout.cols = 4
        collectionViewLayout.rows = 2
        
        let pageCollectionView = LWPageCollectionView(frame: CGRect(x: 0, y: kStatuBarHeight + (navigationController?.navigationBar.h ?? 0), width: view.w, height: 400), titles: titles, pageStyle: pageStyle, isTitleTop: false, pageControlHeight: 20, collectionViewLayout: collectionViewLayout)
        pageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        pageCollectionView.dataScorce = self
        view.addSubview(pageCollectionView)
        pageCollectionView.backgroundColor = UIColor.randomColor
    }

}

extension HomeViewController : LWPageCollectionViewDataScorce {
    func numberOfSections(in pageCollectionView: LWPageCollectionView, collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: LWPageCollectionView, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        } else if section == 1 {
            return 20
        } else if section == 2 {
            return 20
        } else {
            return 10
        }
    }
    
    func pageCollectionView(_ pageCollectionView: LWPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        collectionViewCell.backgroundColor = .orange
        return collectionViewCell
    }
    
    
}

extension HomeViewController {
    
    private func setNavagationBar() {
        
        let logoImage = UIImage(named: "home-logo")
        let logoItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil);
        self.navigationItem.leftBarButtonItem = logoItem
        
        let collectItem = UIBarButtonItem(imageName: "search_btn_follow", target: self, action: #selector(collectItemClick), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = collectItem
        
        //        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 180, height: 32))
        //        searchBar.placeholder = "主播昵称/房间号/链接"
        //        searchBar.searchBarStyle = .minimal
        //        self.navigationItem.titleView = searchBar
        
    }
    
    private func testPageView() {
        
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
        let collectItemController = CollectItemController()
        navigationController?.pushViewController(collectItemController, animated: true)
    }
}
