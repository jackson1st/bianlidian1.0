//
//  LFBRefreshHeader.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//
import MJRefresh
import UIKit

class LFBRefreshHeader: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        stateLabel?.hidden = false
        lastUpdatedTimeLabel?.hidden = true
        
//        setImages([UIImage(named: "v2_pullRefresh1")!], forState: MJRefreshState.Idle)
//        setImages([UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Pulling)
//        setImages([UIImage(named: "v2_pullRefresh1")!, UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Refreshing)
        
        setTitle("下拉刷新", forState: .Idle)
        setTitle("松手开始刷新", forState: .Pulling)
        setTitle("正在刷新", forState: .Refreshing)
    }
}
