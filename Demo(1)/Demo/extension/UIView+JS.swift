//
//  UIView+.swift
//  Demo
//
//  Created by jason on 1/28/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import Foundation

extension UIView{
    
    /**
     在view的底部加一条线
     
     - parameter height:      线的厚度
     - parameter offsetLeft:  到左端的距离，大于等于0有效
     - parameter offsetRight: 到右端的距离，小于等于0有效
     */
    func addBottomLine(height: CGFloat,offsetLeft:CGFloat,offsetRight:CGFloat){
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(view)
        view.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(height)
            make.left.equalTo(self).offset(offsetLeft)
            make.right.equalTo(self).offset(offsetRight)
            make.bottom.equalTo(self)
        }
    }
    
    
    /**
     在view的顶部加一条线
     
     - parameter height:      线的厚度
     - parameter offsetLeft:  到左端的距离，大于等于0有效
     - parameter offsetRight: 到右端的距离，小于等于0有效
     */
    func addTopLine(height: CGFloat,offsetLeft:CGFloat,offsetRight:CGFloat){
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(view)
        view.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(height)
            make.left.equalTo(self).offset(offsetLeft)
            make.right.equalTo(self).offset(offsetRight)
            make.top.equalTo(self)
        }
    }
    
    
    func addNetWorkErrorView(y: CGFloat){
        let view = UIView(frame: self.frame)
        view.frame.origin.y = y
        view.backgroundColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
        let imgView = UIImageView(image: UIImage(named: "NetWorkError"))
        view.addSubview(imgView)
        imgView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-70)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.text = "网络请求失败，请检查您的网络设置"
        view.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(imgView.snp_bottom).offset(20)
        }
        view.tag = 120
        view.hidden = true
        self.addSubview(view)
    }
}