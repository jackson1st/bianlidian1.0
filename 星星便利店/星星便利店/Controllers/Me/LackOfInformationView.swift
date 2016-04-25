//
//  LackOfInformationView.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/18.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class LackOfInformationView: UIView {
    
    var btn: UIButton!
    
    init(frame: CGRect,imageName: String,title: String) {
        super.init(frame: frame)
        btn = MineUpImageDownText(frame: CGRectZero, title: title, imageName: imageName)
        btn.enabled = false
        addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        btn.frame = CGRectMake((width - 92) / 2, (height - 309) / 2, 92, 109)
    }
}

class LackOfInformationButton: UpImageDownTextButton {
    
    init(frame: CGRect, title: String, imageName: String) {
        super.init(frame: frame)
        setTitle(title, forState: .Normal)
        setTitleColor(UIColor.colorWith(80, green: 80, blue: 80, alpha: 1), forState: .Normal)
        setImage(UIImage(named: imageName), forState: .Normal)
        userInteractionEnabled = false
        titleLabel?.font = UIFont.systemFontOfSize(14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}