//
//  LWPageCollectionView.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/6/28.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

protocol LWPageCollectionViewDataScorce : class {
    
    func numberOfSections(in pageCollectionView : LWPageCollectionView, collectionView: UICollectionView) -> Int
    
    func pageCollectionView(_ pageCollectionView : LWPageCollectionView, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    func pageCollectionView(_ pageCollectionView : LWPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class LWPageCollectionView: UIView {
    
    weak var dataScorce : LWPageCollectionViewDataScorce?
    
    private var collectionView : UICollectionView!
    private var pageControl : UIPageControl!
    private var titleView : LWPageTitleView!
    
    private var titles : [String]
    private var pageStyle : LWPageStyle
    private var isTitleTop : Bool
    private var pageControlHeight : CGFloat
    private var collectionViewLayout : LWPageCollectionViewLayout
    
    private var currentSection = 0
    
    
    init(frame: CGRect, titles : [String], pageStyle : LWPageStyle, isTitleTop : Bool, pageControlHeight : CGFloat = 20, collectionViewLayout : LWPageCollectionViewLayout) {
        self.titles = titles
        self.pageStyle = pageStyle
        self.isTitleTop = isTitleTop
        self.pageControlHeight = pageControlHeight
        self.collectionViewLayout = collectionViewLayout
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LWPageCollectionView {
    
    private func setupUI() {
        setupTitleView()
        setupPageControl()
        setupCollectionView()
    }
    
    private func setupTitleView() {
        let titleViewY = isTitleTop ? 0 : bounds.height - pageStyle.pageTitleViewHeight
        let titleViewFrame = CGRect(x: 0, y: titleViewY, width: bounds.width, height: pageStyle.pageTitleViewHeight)
        let titleView = LWPageTitleView(frame: titleViewFrame, titles: titles, pageStyle: pageStyle)
        titleView.delegate = self
        addSubview(titleView)
        titleView.backgroundColor = UIColor.randomColor
        
        self.titleView = titleView
    }
    
    private func setupCollectionView() {
        let collectionViewY = isTitleTop ? pageStyle.pageTitleViewHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - pageStyle.pageTitleViewHeight - pageControlHeight)
        let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: collectionViewLayout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.randomColor
        
        self.collectionView = collectionView
    }
    
    private func setupPageControl() {
        let pageControlY = isTitleTop ? bounds.height - pageControlHeight : bounds.height - pageControlHeight - pageStyle.pageTitleViewHeight
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        let pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.isEnabled = false
        pageControl.numberOfPages = 4
        addSubview(pageControl)
        pageControl.backgroundColor = UIColor.randomColor
        
        self.pageControl = pageControl
    }
}

extension  LWPageCollectionView {
    
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
}

extension LWPageCollectionView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataScorce?.numberOfSections(in: self, collectionView: collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = dataScorce?.pageCollectionView(self, collectionView: collectionView, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (items - 1) / (collectionViewLayout.cols * collectionViewLayout.rows) + 1
        }
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataScorce!.pageCollectionView(self, collectionView: collectionView, cellForItemAt: indexPath)
    }
    
}

extension LWPageCollectionView : UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    func scrollViewEndScroll() {
        guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: collectionView.contentOffset.x + collectionViewLayout.sectionInset.left + 1, y: collectionViewLayout.sectionInset.top + 1)) else {
            return
        }
        
        if indexPath.section != currentSection {

            titleView.setPageTitleView(oldIndex: currentSection, newIndex: indexPath.section, progress: 1)
            let items = collectionView.numberOfItems(inSection: indexPath.section)
            pageControl.numberOfPages = (items - 1) / (collectionViewLayout.cols * collectionViewLayout.rows) + 1
            
            currentSection = indexPath.section
        }
        
        pageControl.currentPage = indexPath.row / (collectionViewLayout.cols * collectionViewLayout.rows)
    }
}

extension LWPageCollectionView : LWPageTitleViewDelegate {
    func pageTitleView(_ pageTitleView: LWPageTitleView, newIndex: Int) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: newIndex), at: .left, animated: false)
        collectionView.contentOffset.x -= collectionViewLayout.sectionInset.left
        scrollViewEndScroll()
    }
}
