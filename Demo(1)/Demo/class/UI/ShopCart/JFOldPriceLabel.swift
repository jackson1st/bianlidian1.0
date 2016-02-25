//
//  JFOldPriceLabel.swift
//  shoppingCart
//
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.

import UIKit

class JFOldPriceLabel: UILabel {

    override func drawRect(rect: CGRect) {
        // 调用父类是为了让Label原有数据正常显示
        super.drawRect(rect)
        
        // 绘制中划线
        let ctx = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(ctx, 0, rect.size.height * 0.5)
        CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height * 0.5)
        CGContextStrokePath(ctx)
    }
}
