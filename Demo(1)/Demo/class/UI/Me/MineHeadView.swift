//
//  MineHeadView.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/2.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class MineHeadView: UIImageView {
    
    let iconView: IconView = IconView()
    var arrowView: UIImageView!
    var buttonClick:(Void -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        image = UIImage(named: "v2_background")
        arrowView = UIImageView(image: UIImage(named: "icon_go_white"))
        addSubview(arrowView)
        addSubview(iconView)
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconViewWH: CGFloat = 150
        iconView.frame = CGRectMake((width - 370) * 0.5, 30, iconViewWH, iconViewWH)
        
        arrowView.frame = CGRectMake(width - 20, (height - (arrowView.image?.size.height)!) * 0.5, (arrowView.image?.size.width)!, (arrowView.image?.size.height)!)
    }
    
    func setUpButtonClick() {
        buttonClick?()
    }
}


class IconView: UIView {
    
    var iconImageView: UIImageView!
    var userName: UILabel!
    var phoneNum: UILabel!
    var phoneImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        if UserAccountTool.userIsLogin() {
            if let data = NSData(contentsOfFile: SD_UserIconData_Path) {
                iconImageView = UIImageView(image: UIImage(data: data))
            } else {
                iconImageView = UIImageView(image: UIImage(named: "v2_my_avatar"))
            }
        } else {
            iconImageView = UIImageView(image: UIImage(named: "v2_my_avatar"))
        }
        
        addSubview(iconImageView)
        
        phoneImage = UIImageView(image: UIImage(named: "icon_phone"))
        addSubview(phoneImage)
        phoneImage.hidden = true
        
        phoneNum = UILabel()
        phoneNum.text = "登陆后可享受更多特权"
        phoneNum.font = UIFont.systemFontOfSize(13)
        phoneNum.textColor = UIColor.whiteColor()
        phoneNum.textAlignment = .Left
        addSubview(phoneNum)
        
        userName = UILabel()
        userName.text = "登录/注册"
        userName.font = UIFont.systemFontOfSize(22)
        userName.textColor = UIColor.whiteColor()
        userName.textAlignment = .Left
        addSubview(userName)
        
        prepareUIForIsLogin()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRectMake((width - 75) * 0.5, 0, 75, 75)
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        phoneImage.frame = CGRectMake(iconImageView.size.width + 60, 43, 14, 14)
        if UserAccountTool.userIsLogin() {
            phoneNum.frame = CGRectMake(iconImageView.size.width + 75, 35, width, 30)
        }
        else {
            phoneNum.frame = CGRectMake(iconImageView.size.width + 60, 35, width, 30)
        }
        userName.frame = CGRectMake(iconImageView.size.width + 60, 10, width, 30)
    }
    
    func prepareUIForIsLogin(){
        if UserAccountTool.userIsLogin() {
            userName.text = UserAccountTool.getUserName()
            phoneNum.text = UserAccountTool.getUserAccount()
            phoneImage.hidden = false
        }
    }
}