//
//  HomeTableHeadView.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class HomeTableHeadView: UICollectionReusableView {
    
    private var pageScrollView: PageScrollView?
    private var hotView: HotView?
    weak var delegate: HomeTableHeadViewDelegate?
//    var tableHeadViewHeight: CGFloat = 0 {
//        willSet {
//            NSNotificationCenter.defaultCenter().postNotificationName(HomeTableHeadViewHeightDidChange, object: newValue)
//            frame = CGRectMake(0, -newValue, AppWidth, newValue)
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildPageScrollView()
        
//        buildHotView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 模型的set方法
    var headData: adList? {
        didSet {
            pageScrollView?.headData = headData
//            hotView!.headData = headData
        }
    }
    // MARK: 初始化子控件
    func buildPageScrollView() {
        weak var tmpSelf = self
        pageScrollView = PageScrollView(frame: CGRectZero, placeholder: UIImage(named: "v2_placeholder_full_size")!, focusImageViewClick: { (index) -> Void in
            if tmpSelf!.delegate != nil && ((tmpSelf!.delegate?.respondsToSelector("tableHeadView:focusImageViewClick:")) != nil) {
                tmpSelf!.delegate!.tableHeadView!(tmpSelf!, focusImageViewClick: index)
            }
        })
        
        addSubview(pageScrollView!)
    }
    
    func buildHotView() {
        weak var tmpSelf = self
        hotView = HotView(frame: CGRectZero, iconClick: { (index) -> Void in
            if tmpSelf!.delegate != nil && ((tmpSelf!.delegate?.respondsToSelector("tableHeadView:iconClick:")) != nil) {
                tmpSelf!.delegate!.tableHeadView!(tmpSelf!, iconClick: index)
            }
        })
        hotView?.backgroundColor = UIColor.whiteColor()
        addSubview(hotView!)
    }
    
    //MARK: 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageScrollView?.frame = CGRectMake(0, 0, AppWidth, AppWidth * 0.4)
//        hotView?.frame.origin = CGPointMake(0, CGRectGetMaxY((pageScrollView?.frame)!))
        
//        tableHeadViewHeight = CGRectGetMaxY((pageScrollView?.frame)!)
    }
}

// - MARK: Delegate
@objc protocol HomeTableHeadViewDelegate: NSObjectProtocol {
    optional func tableHeadView(headView: HomeTableHeadView, focusImageViewClick index: Int)
    optional func tableHeadView(headView: HomeTableHeadView, iconClick index: Int)
}

