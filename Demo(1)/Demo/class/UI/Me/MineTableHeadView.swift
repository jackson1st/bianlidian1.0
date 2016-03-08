//
//  MineTableHeadView.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/1.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

enum MineHeadViewButtonType: Int {
    case Collect = 0
    case Coupon = 1
    case Integral = 2
    case MyCenter = 3
}

class MineTabeHeadView: UIView {
    
    var mineHeadViewClick:((type: MineHeadViewButtonType) -> ())?
    private let orderView = MineOrderView()
    private let couponView = MineCouponView()
    private let messageView = MineMessageView()
    private var headView : MineHeadView!
    private var couponNumber: UIButton?
    private let line1 = UIView()
    private let line2 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let subViewW = width / 3.0
        orderView.frame = CGRectMake(0, height - 70, subViewW, 70)
        couponView.frame = CGRectMake(subViewW, height - 70, subViewW, 70 )
        messageView.frame = CGRectMake(subViewW * 2, height - 70, subViewW,  70)
        couponNumber?.frame = CGRectMake(subViewW * 1.56, 12, 15, 15)
        line1.frame = CGRectMake(subViewW - 0.5,  70 * 0.2 + height - 70, 1, ( 70 ) * 0.6)
        line2.frame = CGRectMake(subViewW * 2 - 0.5, ( 70 ) * 0.2 + height - 70, 1, ( 70 ) * 0.6)
    }
    
    func click(tap: UIGestureRecognizer) {
        if mineHeadViewClick != nil {
            
            switch tap.view!.tag {
                
            case MineHeadViewButtonType.Collect.rawValue:
                mineHeadViewClick!(type: MineHeadViewButtonType.Collect)
                break
                
            case MineHeadViewButtonType.Coupon.rawValue:
                mineHeadViewClick!(type: MineHeadViewButtonType.Coupon)
                break
                
            case MineHeadViewButtonType.Integral.rawValue:
                mineHeadViewClick!(type: MineHeadViewButtonType.Integral)
                break
                
            case MineHeadViewButtonType.MyCenter.rawValue:
                mineHeadViewClick!(type: MineHeadViewButtonType.MyCenter)
                
            default: break
            }
        }
        
    }
    
    private func buildUI() {
        orderView.tag = 0
        addSubview(orderView)
        
        couponView.tag = 1
        addSubview(couponView)
        
        messageView.tag = 2
        addSubview(messageView)
        
        
        headView = MineHeadView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: height - 70))
        headView.tag = 3
        addSubview(headView)
        
        for index in 0...3 {
            let tap = UITapGestureRecognizer(target: self, action: "click:")
            let subView = viewWithTag(index)
            subView?.addGestureRecognizer(tap)
        }
        line1.backgroundColor = UIColor.grayColor()
        line1.alpha = 0.3
        addSubview(line1)
        
        line2.backgroundColor = UIColor.grayColor()
        line2.alpha = 0.3
        addSubview(line2)
        
        couponNumber = UIButton(type: .Custom)
        couponNumber?.setBackgroundImage(UIImage(named: "redCycle"), forState: UIControlState.Normal)
        couponNumber?.setTitleColor(UIColor.redColor(), forState: .Normal)
        couponNumber?.userInteractionEnabled = false
        couponNumber?.titleLabel?.font = UIFont.systemFontOfSize(8)
        couponNumber?.hidden = true
        addSubview(couponNumber!)
    }
    
    func setCouponNumer(number: Int) {
        if number > 0 && number <= 9 {
            couponNumber?.hidden = false
            couponNumber?.setTitle("\(number)", forState: .Normal)
        } else if number > 9 && number < 100 {
            couponNumber?.setTitle("\(number)", forState: .Normal)
            couponNumber?.hidden = false
        } else {
            couponNumber?.hidden = true
        }
    }
}


class MineOrderView: UIView {
    
    var btn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if UserAccountTool.userIsLogin() {
            btn = MineUpLabelDownText(frame: CGRectZero, title: "我的收藏", context: "\(UserAccountTool.getUserCollectNum()!)", unit: "件",color: UIColor.colorWithCustom(234 , g: 128, b: 16))
        }
        else {
            btn = MineUpImageDownText(frame: CGRectZero, title: "我的收藏", imageName: "icon_collect")
        }
        addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btn.frame = CGRectMake(10, 10, width - 20, height - 20)
    }
}

class MineCouponView: UIView {
    
    var btn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if UserAccountTool.userIsLogin() {
            btn = MineUpLabelDownText(frame: CGRectZero, title: "优惠券", context: "\(DataCenter.shareDataCenter.user.coupon!)", unit: "个",color: UIColor.colorWithCustom(235 , g: 79, b: 56))
        }
        else {
            btn = MineUpImageDownText(frame: CGRectZero, title: "优惠劵", imageName: "icon_money")
        }
        addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btn.frame = CGRectMake(10, 10, width - 20, height - 20)
    }
    
}

class MineMessageView: UIView {
    var btn: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        if UserAccountTool.userIsLogin() {
            btn = MineUpLabelDownText(frame: CGRectZero, title: "我的积分", context: "\(UserAccountTool.getUserIntegral()!)", unit: "分",color: UIColor.colorWithCustom(17, g: 205, b: 110))
        }
        else {
            btn = MineUpImageDownText(frame: CGRectZero, title: "我的积分", imageName: "icon_integral")
        }
        addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btn.frame = CGRectMake(10, 10, width - 20, height - 20)
    }
}

class MineUpImageDownText: UpImageDownTextButton {
    
    init(frame: CGRect, title: String, imageName: String) {
        super.init(frame: frame)
        setTitle(title, forState: .Normal)
        setTitleColor(UIColor.colorWith(80, green: 80, blue: 80, alpha: 1), forState: .Normal)
        setImage(UIImage(named: imageName), forState: .Normal)
        userInteractionEnabled = false
        titleLabel?.font = UIFont.systemFontOfSize(13)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MineUpLabelDownText: UpLabelDownTextButton {
    init(frame: CGRect, title: String, context: String, unit: String, color: UIColor) {
        super.init(frame: frame)
        setTitle(title, forState: .Normal)
        setTitleColor(UIColor.colorWith(80, green: 80, blue: 80, alpha: 1), forState: .Normal)
        userInteractionEnabled = false
        titleLabel?.font = UIFont.systemFontOfSize(13)
        contextLabel.font = UIFont.systemFontOfSize(22)
        let AttributedStr = NSMutableAttributedString(string: context + unit)
        AttributedStr.setAttributes([NSForegroundColorAttributeName : color], range: NSMakeRange(0, AttributedStr.length))
        AttributedStr.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(8),NSForegroundColorAttributeName: color], range: NSMakeRange(AttributedStr.length - 1, 1))
        self.contextLabel.attributedText = AttributedStr
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}