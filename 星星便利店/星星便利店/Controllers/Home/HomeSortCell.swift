//
//  HomeSortCell.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/21.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit


protocol HomeSortCellkDelegate: NSObjectProtocol {
    func pushView(spView:shopView)
}
class HomeSortCell: UICollectionViewCell {
    
    var bigClassData: bigClass?{
        didSet {
            flagLabel.text = bigClassData?.classname!
            shopView1!.goods = bigClassData?.itemlist[0]
            shopView2!.goods = bigClassData?.itemlist[1]
            shopView3!.goods = bigClassData?.itemlist[2]
        }
    }
    var color: UIColor? {
        didSet {
            sortFlagView.backgroundColor = color
            flagLabel.textColor = color
        }
    }
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var sortFlagView: UIView!
    @IBOutlet weak var flagLabel: UILabel!
    
    var delegate:HomeSortCellkDelegate?
    var shopView1: shopView? = shopView()
    var shopView2: shopView? = shopView()
    var shopView3: shopView? = shopView()
    var Line1: UIView? = UIView()
    var Line2: UIView? = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.whiteColor()
        addSubview(shopView1!)
        addSubview(shopView2!)
        addSubview(shopView3!)
        Line1?.backgroundColor = UIColor.lightGrayColor()
        Line1?.alpha = 0.3
        Line2?.backgroundColor = Line1?.backgroundColor
        Line2?.alpha = (Line1?.alpha)!
        addSubview(Line1!)
        addSubview(Line2!)
        let viewClick1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewisClick1")
        let viewClick2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewisClick2")
        let viewClick3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewisClick3")
        shopView1?.tag = 100
        shopView1?.addGestureRecognizer(viewClick1)
        shopView2?.addGestureRecognizer(viewClick2)
        shopView3?.addGestureRecognizer(viewClick3)
    }
    
    override func layoutSubviews() {
        flagLabel.sizeToFit()
        shopView1?.frame = CGRect(x: 5, y: 30, width: width/3 - 10, height: 205)
        shopView2?.frame = CGRect(x: (shopView1?.frame.maxX)! + 10, y: (shopView1?.frame.minY)!, width: width/3 - 10, height: (shopView1?.height)!)
        shopView3?.frame = CGRect(x: (shopView2?.frame.maxX)! + 10, y: (shopView1?.frame.minY)!, width: width/3 - 10, height: (shopView1?.height)!)
        Line1!.frame = CGRectMake((shopView1?.frame.maxX)!, (shopView1?.frame.minY)!, 0.5, 180)
        Line2!.frame = CGRectMake((shopView2?.frame.maxX)!, (shopView2?.frame.minY)!, 0.5, 180)
    }
    func viewisClick1() {
        delegate?.pushView(shopView1!)
    }
    func viewisClick2() {
        delegate?.pushView(shopView2!)
    }
    func viewisClick3() {
        delegate?.pushView(shopView3!)
    }
}
