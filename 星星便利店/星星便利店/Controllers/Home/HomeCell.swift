//
//  HomeCell.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

enum HomeCellTyep: Int {
    case Horizontal = 0
    case Vertical = 1
}

class HomeCell: UICollectionViewCell {
    
    private lazy var spView: shopView = {
        let spView = shopView()
        return spView
    }()
    
    var addButtonClick:((imageView: UIImageView) -> ())?
    
    // MARK: - 便利构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        addSubview(spView)
    }
    
    
    var goods: itemList? {
        didSet {
            spView.goods = goods
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        spView.frame = bounds
    }
    
}
