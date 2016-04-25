//
//  HotView.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/20.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class HotView: UIView {
    
    private let iconW = (AppWidth - 2 * HotViewMargin) * 0.25
    private let iconH: CGFloat = 80
    
    var iconClick:((index: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, iconClick: ((index: Int) -> Void)) {
        self.init(frame:frame)
        self.iconClick = iconClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 模型的Set方法
    var headData: adList? {
        didSet {
            if headData?.adlist?.count > 0 {
                
                if headData!.adlist!.count % 4 != 0 {
                    self.rows = headData!.adlist!.count / 4 + 1
                } else {
                    self.rows = headData!.adlist!.count / 4
                }
                var iconX: CGFloat = 0
                var iconY: CGFloat = 0
                
                for i in 0..<headData!.adlist!.count {
                    iconX = CGFloat(i % 4) * iconW + HotViewMargin
                    iconY = iconH * CGFloat(i / 4)
                    let icon = IconImageTextView(frame: CGRectMake(iconX, iconY, iconW, iconH), placeholderImage: UIImage(named: "icon_icons_holder")!)
                    
                    icon.tag = i
                    icon.activitie = Activities()
                    let tap = UITapGestureRecognizer(target: self, action: "iconClick:")
                    icon.addGestureRecognizer(tap)
                    addSubview(icon)
                }
            }
        }
    }
    // MARK: rows数量
    private var rows: Int = 0 {
        willSet {
            bounds = CGRectMake(0, 0, AppWidth, iconH * CGFloat(newValue))
        }
    }
    
    // MARK:- Action
    func iconClick(tap: UITapGestureRecognizer) {
        if iconClick != nil {
            iconClick!(index: tap.view!.tag)
        }
    }
}


