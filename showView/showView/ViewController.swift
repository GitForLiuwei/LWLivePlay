//
//  ViewController.swift
//  showView
//
//  Created by liuwei on 2019/6/14.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var collectionView : UICollectionView = {
        
        let margin : CGFloat = 10
        
        let layout = LWShowViewLayout()
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.scrollDirection = .horizontal
        
        let cols : CGFloat = 2.0
        let itemWidth = self.view.bounds.size.width / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: 50, left: itemWidth / 2, bottom: 40, right: itemWidth / 2)
        
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:"reuseID")
        return collectionView
    }()
    
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setScrollTimer()
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1);
        return cell
    }
    
}

extension ViewController {
    private func setScrollTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scroll), userInfo: self, repeats: true)
    }
    
    @objc private func scroll() {
        let newContentOffset = CGPoint(x: collectionView.contentOffset.x + collectionView.frame.width * 0.5 + 10, y: collectionView.contentOffset.y)
        UIView.animate(withDuration: 0.25) {
            self.collectionView.setContentOffset(newContentOffset, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
}

