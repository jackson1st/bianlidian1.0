//
//  AdressTitleView.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class AdressTitleView: UIView {
    
    private let playImageView = UIImageView(image: UIImage(named: "icon_locate"))
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView(image: UIImage(named: "icon_allowblack"))
    var adressWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        playImageView.frame = CGRectMake(0, (frame.size.height - 14) * 0.5, 15, 15)
        addSubview(playImageView)
        
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(15)
//        if let adress = UserInfo.sharedUserInfo.defaultAdress() {
//            if adress.address?.characters.count > 0 {
//                let adressStr = adress.address! as NSString
//                if adressStr.componentsSeparatedByString(" ").count > 1 {
//                    titleLabel.text = adressStr.componentsSeparatedByString(" ")[0]
//                } else {
//                    titleLabel.text = adressStr as String
//                }
//                
//            } else {
//                titleLabel.text = "你在哪里呀"
//            }
        
//        } else {
            titleLabel.text = "你在哪里呀"
//        }
        titleLabel.sizeToFit()
        titleLabel.frame = CGRectMake(CGRectGetMaxX(playImageView.frame) + 3, 0, titleLabel.width, frame.height)
        addSubview(titleLabel)
        
        arrowImageView.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 4, (frame.size.height - 6) * 0.5, 10, 6)
        addSubview(arrowImageView)
        
        adressWidth = CGRectGetMaxX(arrowImageView.frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(text: String) {
        let adressStr = text as NSString
        if adressStr.componentsSeparatedByString(" ").count > 1 {
            titleLabel.text = adressStr.componentsSeparatedByString(" ")[0]
        } else {
            titleLabel.text = adressStr as String
        }
        titleLabel.sizeToFit()
        titleLabel.frame = CGRectMake(CGRectGetMaxX(playImageView.frame) + 3, 0, titleLabel.width, frame.height)
        arrowImageView.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 4, (frame.size.height - arrowImageView.height) * 0.5, arrowImageView.width, arrowImageView.height)
        adressWidth = CGRectGetMaxX(arrowImageView.frame)
    }
}

