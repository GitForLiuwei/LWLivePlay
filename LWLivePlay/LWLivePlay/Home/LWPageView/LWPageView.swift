//
//  LWPageView.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/6/3.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class LWPageView: UIView {
    private var titles              : [String]
    private var childVCs            : [UIViewController]
    private var parentController    : UIViewController
    private var pageStyle           : LWPageStyle
    
    init(frame: CGRect, titles: [String], childVCs: [UIViewController], parentController: UIViewController, pageStyle: LWPageStyle) {
        self.titles             = titles
        self.childVCs           = childVCs
        self.parentController   = parentController
        self.pageStyle          = pageStyle
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LWPageView {
    private func setupUI() {
        let pageTitleViewFrame      = CGRect(x: 0, y: 0, width: bounds.width, height: pageStyle.pageTitleViewHeight)
        let pageTitleView           = LWPageTitleView(frame: pageTitleViewFrame, titles: titles, pageStyle: pageStyle)
        addSubview(pageTitleView)
        
        let pageContentViewFrame    = CGRect(x: 0, y: pageTitleView.frame.maxY, width: bounds.width, height: bounds.height - pageTitleView.h)
        let pageContentView         = LWPageContentView(frame: pageContentViewFrame, childVCs: childVCs, parentController: parentController)
        addSubview(pageContentView)
        
        pageTitleView.delegate      = pageContentView
        pageContentView.delegate    = pageTitleView
    }
}
