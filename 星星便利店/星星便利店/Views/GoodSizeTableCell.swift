//
//  GoodSizeTableCell.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/20.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class GoodSizeTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    var sizeTag: Int!
    //MARK:进行button的布局
    var buttons: [UIButton]?{
        didSet{
            //这里要完成button的布局。
            let width = buttonView.frame.width
            //用(sx,sy)是当前button应该放的位置
            var sx:CGFloat = 5,sy:CGFloat = 11
            var cur = 1
            for var button in buttons!{
                if(button.frame.width + sx > width){
                    sy = sy + button.frame.height + 10
                    sx = 5
                }
                button.tag = sizeTag + cur
                cur++
                button.frame.origin = CGPoint(x: sx,y: sy)
                button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                button.layer.cornerRadius = 4
                button.layer.borderColor = UIColor.lightGrayColor().CGColor
                button.layer.borderWidth = 0.6
                buttonView.addSubview(button)
                sx += button.frame.width + 5
            }
            buttonView.frame.size.height = sy + 30
            contentView.frame.size.height = sy + 35
            self.setNeedsLayout()
        }
    }
    
    func buttonClicked(sender: AnyObject?){
        let buttonTag = (sender as! UIButton).tag
        var flag = 0
        
        for var button in buttons!{
            if(button.tag != buttonTag){
                button.selected = false
                button.layer.borderColor = UIColor.lightGrayColor().CGColor
            }else{
                if(button.selected != true){
                    button.selected = true
                    button.layer.borderColor = UIColor.colorWith(242, green: 48, blue: 58, alpha: 1).CGColor
                    flag = 1
                }else{
                    button.selected = false
                    button.layer.borderColor = UIColor.lightGrayColor().CGColor
                }
                
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("ChooseSize", object: self, userInfo: ["SizeTag":buttonTag,"flag": flag])
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

