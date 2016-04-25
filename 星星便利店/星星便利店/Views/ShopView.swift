//
//  ShopView.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/21.
//  Copyright © 2016年 黄人煌. All rights reserved.
//
import UIKit


class shopView: UIView {
    //MARK: - 初始化子空间
    
    private lazy var goodsImageView: UIImageView = {
        let goodsImageView = UIImageView()
        goodsImageView.contentMode = UIViewContentMode.ScaleAspectFit
        return goodsImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.font = HomeCollectionTextFont
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.numberOfLines = 2
        return nameLabel
    }()
    
    private lazy var fineImageView: UIImageView = {
        let fineImageView = UIImageView()
        fineImageView.image = UIImage(named: "jingxuan.png")
        return fineImageView
    }()
    
    private lazy var giveImageView: UIImageView = {
        let giveImageView = UIImageView()
        giveImageView.image = UIImage(named: "buyOne.png")
        return giveImageView
    }()
    
    private lazy var buyLabel: UILabel = {
        let buyLabel = UILabel()
        buyLabel.numberOfLines = 0
        buyLabel.textAlignment = NSTextAlignment.Right
        buyLabel.font = UIFont.boldSystemFontOfSize(14.0)
        buyLabel.textColor = UIColor.lightGrayColor()
        return buyLabel
    }()
    
    private var discountPriceView: DiscountPriceView?
    
    
    // MARK: - 便利构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        addSubview(goodsImageView)
        addSubview(nameLabel)
        addSubview(fineImageView)
        addSubview(giveImageView)
        addSubview(buyLabel)
    }
    
    // MARK: - 模型set方法
    
    var goods: itemList? {
        didSet {
            goodsImageView.sd_setImageWithURL(NSURL(string: goods!.url!), placeholderImage: UIImage(named: "v2_placeholder_square"))
            nameLabel.text = goods?.itemName
            //            if goods!.pm_desc == "买一赠一" {
            //                giveImageView.hidden = false
            //            } else {
            
            giveImageView.hidden = true
            //            }
            if discountPriceView != nil {
                discountPriceView!.removeFromSuperview()
            }
            var marketPrice: String?
            if goods?.discountPrice != nil {
                let markePrice = Double(goods!.itemSalePrice)! + Double(goods!.discountPrice!)!
                marketPrice = "\(markePrice)"
            }
            discountPriceView = DiscountPriceView(price: "\(goods!.itemSalePrice!)", marketPrice: marketPrice)
            addSubview(discountPriceView!)
            buyLabel.text = "😍\(goods!.itemBynum1)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        goodsImageView.frame = CGRectMake(0, 0, width, width)
        nameLabel.frame = CGRectMake(5, width, width - 15, 40)
        fineImageView.frame = CGRectMake(5, CGRectGetMaxY(nameLabel.frame), 30, 15)
        giveImageView.frame = CGRectMake(CGRectGetMaxX(fineImageView.frame) + 3, fineImageView.y, 35, 15)
        discountPriceView?.frame = CGRectMake(nameLabel.x, CGRectGetMaxY(fineImageView.frame), 60, height - CGRectGetMaxY(fineImageView.frame))
        buyLabel.frame = CGRectMake(width - 85, height - 30, 80, 25)

    }

}
