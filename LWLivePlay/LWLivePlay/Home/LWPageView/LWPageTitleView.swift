//
//  LWPageTitleView.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/6/3.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

protocol LWPageTitleViewDelegate: class {
    func pageTitleView(_ pageTitleView: LWPageTitleView, newIndex: Int)
}

class LWPageTitleView: UIView {
    
    weak var delegate : LWPageTitleViewDelegate?
    
    lazy private var scrollView     : UIScrollView = {
        let scrollView                              = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator   = false
        scrollView.scrollsToTop                     = false
        return scrollView
    }()
    
    lazy private var scrollLine     : UIView = {
        let scrollLine              = UIView()
        scrollLine.y                = self.pageStyle.pageTitleViewHeight - self.pageStyle.scrollLineHeight - self.pageStyle.scrollLineMargin
        scrollLine.h                = self.pageStyle.scrollLineHeight
        scrollLine.backgroundColor  = self.pageStyle.scrollLineColor
        return scrollLine
    }()
   
    lazy private var coverView      : UIView = {
        let coverView               = UIView()
        
        coverView.backgroundColor   = self.pageStyle.coverViewColor
        coverView.alpha             = self.pageStyle.coverViewAlpha
        
        coverView.layer.cornerRadius    = self.pageStyle.coverViewHeight * 0.5
        coverView.layer.masksToBounds   = true
        return coverView
    }()
    
    lazy private var titleLables    : [UILabel] = [UILabel]()
    private var currentIndex = 0;
    
    private var titles      : [String]
    private var pageStyle   : LWPageStyle
    
    init(frame: CGRect, titles: [String], pageStyle: LWPageStyle) {
        self.titles     = titles
        self.pageStyle  = pageStyle
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:-设置UI
extension LWPageTitleView {
    private func setupUI() {
        addSubview(scrollView)
        setTitleLables()
        setTitleLableFrame()
        setScrollLine()
        setCoverView()
    }
    
    private func setTitleLables() {
        for (i, title) in titles.enumerated() {
            let lable               = UILabel()
            lable.text              = title
            lable.textColor         = i == 0 ? pageStyle.titleSelectColor : pageStyle.titleNormalColor
            lable.tag               = i
            lable.font              = pageStyle.titleFont
            lable.textAlignment     = .center
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLableClick))
            lable.addGestureRecognizer(tap)
            lable.isUserInteractionEnabled = true
            
            scrollView.addSubview(lable)
            
            titleLables.append(lable)
        }
    }
   
    private func setTitleLableFrame() {
        
        var x : CGFloat = 0
        let y : CGFloat = 0
        var w : CGFloat = 0
        let h : CGFloat = pageStyle.pageTitleViewHeight
        
        for (i, titleLable) in titleLables.enumerated() {
            
            if !pageStyle.isScrollEnable {  //不可以滚动
                w = (bounds.width - pageStyle.titleMargin * CGFloat(titleLables.count))  / CGFloat(titleLables.count)
            } else {    //可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : pageStyle.titleFont], context: nil).width
            }
            
            if i == 0 {
                x = pageStyle.titleMargin * 0.5
            } else {
                x = titleLables[i - 1].frame.maxX + pageStyle.titleMargin
            }
            titleLable.frame = CGRect(x: x, y: y, width: w, height: h)
            
            //缩放第一个lable
            if pageStyle.isScaleEnable && i == 0 {
                titleLable.transform = CGAffineTransform(scaleX: pageStyle.titleFontScale, y: pageStyle.titleFontScale)
            }
        }
        
        if pageStyle.isScrollEnable {
            scrollView.contentSize.width = titleLables.last!.frame.maxX + 0.5 * pageStyle.titleMargin
        }
    }
    
    private func setScrollLine() {
        guard pageStyle.isHaveScrollLine else {
            return
        }
        
        scrollLine.x = titleLables.first!.x
        scrollLine.w = titleLables.first!.w
        
        scrollView.addSubview(scrollLine)
    }
    
    private func setCoverView() {
        guard pageStyle.isHaveCoverView else {
            return
        }
        
        let coverW = titleLables.first!.w + pageStyle.titleMargin * 0.5
        let coverH = pageStyle.coverViewHeight
        
        coverView.bounds = CGRect(x: 0, y: 0, width: coverW, height: coverH)
        coverView.center = titleLables.first!.center
        scrollView.addSubview(coverView)
    }
}


//MARK:-事件处理
extension LWPageTitleView {
    //titleLable点击事件
    @objc private func titleLableClick(tapGes: UITapGestureRecognizer) {
        guard let newLable = tapGes.view as? UILabel else {
            return
        }
        let oldLable = titleLables[currentIndex]
        
        //更新lable的颜色
        oldLable.textColor = pageStyle.titleNormalColor
        newLable.textColor = pageStyle.titleSelectColor
        
        UIView.animate(withDuration: 0.25) {
            //更新scrollLine的位置
            if self.pageStyle.isHaveScrollLine {
                self.scrollLine.x = newLable.x
                self.scrollLine.w = newLable.w
            }
            
            //字体缩放
            if self.pageStyle.isScaleEnable {
                oldLable.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                newLable.transform = CGAffineTransform(scaleX: self.pageStyle.titleFontScale, y: self.pageStyle.titleFontScale)
            }
            
            //更新coverView的位置
            if self.pageStyle.isHaveCoverView {
                self.coverView.w = newLable.w + self.pageStyle.titleMargin * 0.5
                self.coverView.center = newLable.center
            }
        }
        
        //更新选中的位置
        currentIndex = newLable.tag
        
        //调整选中titleLable的位置
        adjustPosition(newLable)
        
        //调整pageContenView位置
        delegate?.pageTitleView(self, newIndex: currentIndex)
    }
   
    //调整scrollView的偏移量 确保选中lable居中
    func adjustPosition(_ lable: UILabel) {
        guard pageStyle.isScrollEnable else {
            return
        }
        
        var offsetX = lable.center.x - scrollView.w * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        
        let maxOffsetX = scrollView.contentSize.width - scrollView.w
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }

        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

//MARK:-LWPageContentViewDelegate
extension LWPageTitleView: LWPageContentViewDelegate {
    
    //滚动过程
    func pageContentView(_ pageContentView: LWPageContentView, newIndex: Int, progress: CGFloat) {
        
        let oldLable = titleLables[currentIndex]
        let newLable = titleLables[newIndex]
       
        // 修改lable颜色
        let selectColor = pageStyle.titleSelectColor
        let normalColor = pageStyle.titleNormalColor
        
        let selectRGB = selectColor.getRGBValue()
        let normalRGB = normalColor.getRGBValue()
        let RGBDelta = selectColor.getRGBDelta(normalColor)
        
        oldLable.textColor = UIColor(red: selectRGB.r - RGBDelta.r * progress, green: selectRGB.g - RGBDelta.g * progress, blue: selectRGB.b - RGBDelta.b * progress, alpha: 1)
        newLable.textColor = UIColor(red: normalRGB.r + RGBDelta.r * progress, green: normalRGB.g + RGBDelta.g * progress, blue: normalRGB.b + RGBDelta.b * progress, alpha: 1)
        
        // 修改scrollLine位置
        if pageStyle.isHaveScrollLine {
            scrollLine.x = oldLable.x + (newLable.x - oldLable.x) * progress
            scrollLine.w = oldLable.w + (newLable.w - oldLable.w) * progress
        }
        
        //修改lable的大小
        if pageStyle.isScaleEnable {
            let oldScale = pageStyle.titleFontScale - (pageStyle.titleFontScale - 1.0) * progress
            oldLable.transform = CGAffineTransform(scaleX: oldScale, y: oldScale)
            
            let newScale = 1.0 + (pageStyle.titleFontScale - 1.0) * progress
            newLable.transform = CGAffineTransform(scaleX: newScale, y: newScale)
        }
       
        //修改coverView的位置
        if pageStyle.isHaveCoverView {
            coverView.w = oldLable.w + (newLable.w - oldLable.w) * progress + pageStyle.titleMargin * 0.5
            coverView.center.x = oldLable.center.x + (newLable.center.x - oldLable.center.x) * progress
        }
    }
    
    //滚动结束
    func pageContentView(_ pageContentView: LWPageContentView, newIndex: Int) {
        let selectLable = titleLables[newIndex]
        
        currentIndex = newIndex
        
        adjustPosition(selectLable)
    }
    
}
