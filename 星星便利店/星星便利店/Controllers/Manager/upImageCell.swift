//
//  upImageCell.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/4/22.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class upImageCell: UITableViewCell {

    var data: UpImageModel! {
        didSet {
            GoodsName.text = data.itemName
            HomeCount.text = "首页图片:\(data.indexCount)张"
            OtherCount.text = "详情图片:\(data.roundCount)张"
        }
    }
    
    @IBOutlet weak var GoodsName: UILabel!
    @IBOutlet weak var HomeCount: UILabel!
    @IBOutlet weak var OtherCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
