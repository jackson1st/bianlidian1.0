//
//  smallClassCell.swift
//  Demo
//
//  Created by Jason on 15/12/18.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class smallClassCell: UICollectionViewCell {

    var imgView: UIImageView!
    var textLabel: UILabel!
    var cellData: smallClass? {
        didSet {
            imgView.sd_setImageWithURL(NSURL(string: (cellData?.url)!), placeholderImage: UIImage(named: "v2_placeholder_square"))
            textLabel.text = cellData?.name
        }
    }
    /**
     从nib加载会调用的初始化方式
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        //初始化imgView
        imgView = UIImageView()
        self.contentView.addSubview(imgView)
        
        //初始化textLabel
        textLabel = UILabel()
        textLabel.font = UIFont.systemFontOfSize(13)
        textLabel.textAlignment = .Center
        self.contentView.addSubview(textLabel)

        
    }
    override func layoutSubviews() {
        imgView.frame = CGRectMake(5, 5, width - 10, height - 30)
        textLabel.frame = CGRectMake(0, imgView.frame.maxY + 5, width, 15)
    }
}
