//
//  ViewController.swift
//  waterfallLayout
//
//  Created by liuwei on 2019/6/17.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var collectionView : UICollectionView = {
        
        let marge : CGFloat = 10

        let waterfallLayout = LWWaterfallLayout()
        
        waterfallLayout.delegate = self
        waterfallLayout.cols = 3
        
        waterfallLayout.sectionInset = UIEdgeInsets(top: 0, left: marge, bottom: 0, right: marge)

        waterfallLayout.minimumLineSpacing = marge
        waterfallLayout.minimumInteritemSpacing = marge
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: waterfallLayout)
  
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1)
        
        return cell
    }
}

extension UIViewController : LWWaterfallLayoutDelegate {
    func waterfallLayout(waterfallLayout: LWWaterfallLayout, heightWithItemIndex index: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(200) + 50)
    }
}


