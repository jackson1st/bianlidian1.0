//
//  IitemSearchResultViewCell.swift
//  Demo
//
//  Created by jason on 15/12/10.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class IitemSearchResultViewCell: UITableViewCell {
    @IBOutlet weak var ImgViewPhoto: UIImageView!
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var LabelPrice: UILabel!
    @IBOutlet weak var LabelSaleNum: UILabel!
    private var discountPriceView: DiscountPriceView?
    var data: SearchItemResult?{
        didSet{
            ImgViewPhoto.sd_setImageWithURL(NSURL(string: data!.imgurl!), placeholderImage: UIImage(named: "quesheng"))
            LabelTitle.text = (data?.name)!
            LabelTitle.sizeToFit()
            LabelPrice.text = "¥" + (data?.price)!
            LabelPrice.sizeToFit()
            LabelSaleNum.text = "已售出" + (data?.saleNum)!
            LabelSaleNum.font = UIFont.systemFontOfSize(14)
            LabelSaleNum.sizeToFit()
            if discountPriceView != nil {
                discountPriceView!.removeFromSuperview()
            }
            var marketPrice: String?
            if data?.discountPrice != nil {
                let markePrice = Double(data!.price!)! + Double(data!.discountPrice!)!
                marketPrice = "\(markePrice)"
            }
            discountPriceView = DiscountPriceView(price: "\(data!.price!)", marketPrice: marketPrice)
            addSubview(discountPriceView!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
