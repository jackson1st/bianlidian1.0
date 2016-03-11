//
//  CouponCell.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/3.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell,Reusable {
    
    static private let cellIdentifier = "cuoponCell"
    
    
    private let imageArray = ["","geted","avaliable","used","pasted"]
    let useColor = UIColor.redColor()
    let unUseColor = UIColor.colorWithCustom(158, g: 158, b: 158)
    
    var backImageView: UIImageView? //v2_coupon_gray  v2_coupon_yellow
    var outdateImageView: UIImageView? // v2_coupon_outdated 过期 // v2_coupon_used已使用
    var titleLabel: UILabel?
    var dateLabel: UILabel?
    var descLabel: UILabel?
    var priceLabel: UILabel?
    var memoryLabel: UILabel?
    var line1: UIView?
    var line2: UIView?
    var line3: UIView?
    var dashImageView: UIImageView?
    var upImageView: UIImageView?
    var flagImageView: UIImageView?
    var unUseImageView: UIImageView?
    var getButton: UIButton?
    
    private let circleWidth: CGFloat = AppWidth * 0.16
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        line1 = UIView()
        line1?.backgroundColor = UIColor.colorWithCustom(228, g: 228, b: 228)
        line2 = UIView()
        line2?.backgroundColor = line1?.backgroundColor
        line3 = UIView()
        line3?.backgroundColor = line1?.backgroundColor
        
        upImageView = UIImageView()
        
        selectionStyle = UITableViewCellSelectionStyle.None
        contentView.backgroundColor = UIColor.colorWithCustom(242, g: 242, b: 242)
        
        backImageView = UIImageView(image: UIImage(named: "background_white"))
        contentView.addSubview(backImageView!)
        
        dashImageView = UIImageView()
        
        contentView.addSubview(line1!)
        contentView.addSubview(line2!)
        contentView.addSubview(line3!)
        contentView.addSubview(dashImageView!)
        contentView.addSubview(upImageView!)
        
        dateLabel = UILabel()
        dateLabel?.font = UIFont.systemFontOfSize(10)
        dateLabel?.textAlignment = NSTextAlignment.Left
        contentView.addSubview(dateLabel!)
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        titleLabel?.textAlignment = NSTextAlignment.Left
        contentView.addSubview(titleLabel!)
        
        memoryLabel = UILabel()
        memoryLabel?.font = UIFont.systemFontOfSize(10)
        memoryLabel?.textAlignment = NSTextAlignment.Left
        contentView.addSubview(memoryLabel!)
        
        flagImageView = UIImageView()
        contentView.addSubview(flagImageView!)
        
        unUseImageView = UIImageView()
        contentView.addSubview(unUseImageView!)
        
        getButton = UIButton()
        contentView.addSubview(getButton!)
        
        priceLabel = UILabel()
        priceLabel?.font = UIFont.boldSystemFontOfSize(40)
        priceLabel?.frame = CGRectMake(0, 10, circleWidth, 30)
        priceLabel?.textAlignment = NSTextAlignment.Center
        priceLabel?.textColor = UIColor.redColor()
        contentView.addSubview(priceLabel!)
        
        descLabel = UILabel()
        descLabel?.font = UIFont.systemFontOfSize(10)
        descLabel?.textAlignment = NSTextAlignment.Left
        contentView.addSubview(descLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellWithTableView(tableView: UITableView) -> CouponCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? CouponCell
        if cell == nil {
            cell = CouponCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let starRightL: CGFloat = (AppWidth - 2 * CouponViewControllerMargin) * 0.26 + CouponViewControllerMargin
        let rightWidth: CGFloat = (AppWidth - 2 * CouponViewControllerMargin) * 0.74
        
        backImageView?.frame = CGRectMake(CouponViewControllerMargin, 5, width - 2 * CouponViewControllerMargin, height - 10)
        
        line1?.frame = CGRectMake(CGRectGetMinX((backImageView?.frame)!), 5, 1, height - 11)
        line2?.frame = CGRectMake(CGRectGetMaxX((backImageView?.frame)!), 5, 1, height - 11)
        line3?.frame = CGRectMake(CGRectGetMinX((backImageView?.frame)!), CGRectGetMaxY((backImageView?.frame)!), CGRectGetWidth((backImageView?.frame)!), 1)
        upImageView?.frame = CGRectMake(CGRectGetMinX((backImageView?.frame)!), CGRectGetMinY((backImageView?.frame)!), CGRectGetWidth((backImageView?.frame)!), 3)

        flagImageView?.frame = CGRectMake(CGRectGetMinX((backImageView?.frame)!) + 10 , CGRectGetMaxY((backImageView?.frame)!) - 45, 10, 14)
        priceLabel?.frame = CGRectMake(CGRectGetMinX((flagImageView?.frame)!) + 13, CGRectGetMaxY((flagImageView?.frame)!) - 40, 100, 40)
        priceLabel?.center.y = (backImageView?.center.y)!
        flagImageView?.center.y = (backImageView?.center.y)! + 5
        
        dashImageView?.frame = CGRectMake(CGRectGetMaxX((priceLabel?.frame)!) + 10, 25, 15, CGRectGetMaxY((backImageView?.frame)!) - 40)
        unUseImageView?.frame = CGRectMake(CGRectGetMaxX((backImageView?.frame)!) - 75, 10, 68, 68)
        getButton?.frame = CGRectMake(CGRectGetMaxX((backImageView?.frame)!) - 75, 10, 68, 68)
        
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRectMake(CGRectGetMaxX((dashImageView?.frame)!) + 10, CGRectGetMinY((dashImageView?.frame)!), titleLabel!.width, titleLabel!.height)
        
        descLabel?.sizeToFit()
        descLabel?.frame = CGRectMake(CGRectGetMinX((titleLabel?.frame)!), CGRectGetMaxY(titleLabel!.frame) +   5, (descLabel?.width)!, (descLabel?.height)!)
        
        memoryLabel?.sizeToFit()
        memoryLabel?.frame = CGRectMake(CGRectGetMinX((descLabel?.frame)!), CGRectGetMaxY(descLabel!.frame) + 5, (memoryLabel?.width)!, (memoryLabel?.height)!)
        
        dateLabel?.sizeToFit()
        dateLabel?.frame = CGRectMake(CGRectGetMinX((descLabel?.frame)!), CGRectGetMaxY(memoryLabel!.frame) + 5, dateLabel!.width, dateLabel!.height)
        
    }
    
    var coupon: GiftModel! {
        didSet {
            switch coupon.status {
            case 0:
                setCouponColor(true, statu: 0)
            case 1:
                setCouponColor(false,statu: 1)
                break
            case 2:
                setCouponColor(true,statu: 2)
                break
            case 3:
                setCouponColor(false,statu: 3)
                break
            case 4:
                setCouponColor(false,statu: 4)
                break
            default:
                setCouponColor(false,statu: 4)
                break
            }
            
            let price = String(format: "%.1lf", Double(coupon.amt))
            let AttributedStr = NSMutableAttributedString(string: price)
            
            AttributedStr.setAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(23)], range: NSMakeRange(AttributedStr.length - 1, 1))
            
            
            memoryLabel?.text = "· 一次订单最多使用一张优惠券"
            priceLabel?.attributedText = AttributedStr
            titleLabel?.text = " " + (coupon?.name)! + "  "
            dateLabel?.text = "· 有效期:  " + coupon!.start + "至" + coupon!.end
            descLabel?.text = "· 商品满\(coupon!.minMoney)元使用"
        }
    }
    
    private func setCouponColor(isUse: Bool,statu: Int) {
        
        titleLabel?.textColor = unUseColor
        memoryLabel?.textColor = titleLabel?.textColor
        dateLabel?.textColor = titleLabel?.textColor
        descLabel?.textColor = titleLabel?.textColor
        priceLabel?.textColor = isUse ? useColor : unUseColor
        getButton?.hidden = true
        unUseImageView?.hidden = false
        if 0 == statu {
            unUseImageView?.hidden = isUse
            getButton?.hidden = false
        }
        let imageName = isUse ? "red_bg_left" : "red_disable_bg_left"
        let image = UIImage(named: imageName)
        let resizeImage = image?.resizableImageWithCapInsets(UIEdgeInsetsZero)
        upImageView?.image = resizeImage
        let imageName2 = isUse ? "red_icon_yuan" : "red_icon_disable_yuan"
        flagImageView?.image = UIImage(named: imageName2)
        let imageName3 = "dash_image_gray"
        dashImageView?.image = UIImage(named: imageName3)
        let imageName4 = imageArray[statu]
        unUseImageView?.image = UIImage(named: imageName4)
        getButton?.setTitle("领取", forState: UIControlState.Normal)
        getButton?.titleLabel?.font = UIFont.boldSystemFontOfSize(25)
        getButton?.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        getButton?.addTarget(self, action: "getCouponAction", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func getCouponAction(){
        if UserAccountTool.userIsLogin() {
            
            coupon.getGift(coupon.stampNo) { (result) -> Void in
                if "success" == result {
                    MBProgressHUD.showSuccess("领取成功")
                    self.coupon.status = 1
                    DataCenter.shareDataCenter.updateAllCoupons("", callBack: nil)
                }
                else {
                    MBProgressHUD.showError("领取失败,请重试~~")
                }
            }
        }
            
        else {
            
        }
    }
    
}

