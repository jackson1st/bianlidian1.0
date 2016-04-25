//
//  HomeCollectionFooterView.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class HomeCollectionFooterView: UICollectionReusableView {
    
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "点击查看更多商品 >"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textColor = UIColor.colorWithCustom(150, g: 150, b: 150)
        titleLabel.frame = CGRectMake(0, 0, AppWidth, 60)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideLabel() {
        self.titleLabel.hidden = true
    }
    
    func showLabel() {
        self.titleLabel.hidden = false
    }
    
    func setFooterTitle(text: String, textColor: UIColor) {
        titleLabel.text = text
        titleLabel.textColor = textColor
    }
}

class HomeCollectionHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = ""
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.frame = CGRectMake(10, 0, 200, 20)
        titleLabel.textColor = UIColor.colorWithCustom(150, g: 150, b: 150)
        addSubview(titleLabel)
    }
    func setHeaderTitle(text: String) {
        titleLabel.text = text
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}