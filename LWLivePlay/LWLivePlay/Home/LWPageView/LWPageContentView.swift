//
//  LWPageContentView.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/6/3.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

protocol LWPageContentViewDelegate: class {
    func pageContentView(_ pageContentView: LWPageContentView, newIndex: Int)
    func pageContentView(_ pageContentView: LWPageContentView, oldIndex: Int ,newIndex: Int, progress: CGFloat)
}

private let kCollectionCell : String = "collectionCell"

class LWPageContentView: UIView {
    
    weak var delegate: LWPageContentViewDelegate?
    private var isForbidDelegate: Bool = false
    private var startOffsetX: CGFloat = 0
    
    lazy private var collectionView      : UICollectionView = {
        let flowLayout                      = UICollectionViewFlowLayout()
        flowLayout.itemSize                 = self.bounds.size
        flowLayout.minimumLineSpacing       = 0
        flowLayout.minimumInteritemSpacing  = 0
        flowLayout.scrollDirection          = .horizontal
        
        let collectionView                              = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate                         = self
        collectionView.dataSource                       = self
        collectionView.isPagingEnabled                  = true
        collectionView.scrollsToTop                     = false
        collectionView.showsHorizontalScrollIndicator   = false
        collectionView.bounces                          = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionCell)
        
        return collectionView
    }()

    private var childVCs            : [UIViewController]
    private var parentController    : UIViewController
    
    init(frame: CGRect, childVCs: [UIViewController], parentController: UIViewController) {
        self.childVCs           = childVCs
        self.parentController   = parentController
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:-设置UI
extension LWPageContentView {
    private func setupUI() {
        // 将childVC 添加到父控制中
        for vc in childVCs {
            parentController.addChild(vc)
        }
        
        // 添加collectionView
        addSubview(collectionView)
    }
}

extension LWPageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionCell, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let vc = childVCs[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        cell.addSubview(vc.view)
        return cell
    }
    
}

extension LWPageContentView : UICollectionViewDelegate {
    
    //scrollView 结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    //scrollView 结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //没有减速
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    //滚动结束时调用
    private func scrollViewEndScroll() {
        //获取当前scrollView所在的index
        let newIndex = Int(collectionView.contentOffset.x / collectionView.w)
        delegate?.pageContentView(self, newIndex: newIndex)
    }
    
    //scrollView开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //当前滚动是由collectionView被拖拽引起的 打开代理
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //偏移量没有变化时 或者当前滚动是由点击pageTitleView中的title引起的
        if scrollView.contentOffset.x == startOffsetX || isForbidDelegate {
            return
        }
       
        var currentIndex: Int = 0
        var newIndex: Int   = 0
        var progress: CGFloat = 0

        if scrollView.contentOffset.x > startOffsetX {
            progress = scrollView.contentOffset.x / collectionView.w - floor(scrollView.contentOffset.x / collectionView.w)
            newIndex = Int(ceil(scrollView.contentOffset.x / collectionView.w))
            currentIndex = Int(floor(scrollView.contentOffset.x / collectionView.w))
            if newIndex > childVCs.count - 1 {
                newIndex = childVCs.count - 1
            }
        }else {
            progress = ceil(scrollView.contentOffset.x / collectionView.w) - scrollView.contentOffset.x / collectionView.w
            newIndex = Int(floor(scrollView.contentOffset.x / collectionView.w))
            currentIndex = Int(ceil(scrollView.contentOffset.x / collectionView.w))
            if newIndex < 0 {
                newIndex = 0
            }
        }
        
        delegate?.pageContentView(self, oldIndex: currentIndex, newIndex: newIndex, progress: progress)
    }
}

extension LWPageContentView {
    
    func setCurrentIndex(_ newIndex: Int) {
        // 由pageTitleView引起的collectionView滚动 禁止代理
        isForbidDelegate = true
        
        let indexPath = IndexPath(item: newIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
}
