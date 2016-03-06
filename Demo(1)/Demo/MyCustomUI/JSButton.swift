//
//  JSButton.swift
//  Demo
//
//  Created by Jason on 3/5/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit

class JSButton: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var buttonAction:(()->())?
    
    var button:UIButton {
        let btn = UIButton()
        self.addSubview(btn)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        btn.clipsToBounds = true
        btn.addTarget(self, action: "buttonCliked", forControlEvents: .TouchUpInside)
        btn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        return btn
    }
    var labelEdge:UILabel?
    var edge:String?{
        didSet{
            if(labelEdge == nil){
                labelEdge = createLabelEdge()
            }
            labelEdge?.text = edge
            if(edge == nil || edge == "0"){
                EdgeHidden = true
            }else{
                EdgeHidden = false
            }
        }
    }
    var EdgeHidden = true {
        didSet{
            if(labelEdge == nil){
                labelEdge = createLabelEdge()
            }
            labelEdge?.hidden = EdgeHidden
            labelEdge?.layer.cornerRadius = 10
        }
    }
    
    func createLabelEdge() -> UILabel{
        let label = UILabel()
        label.textAlignment = .Center
        label.layer.masksToBounds = true
        label.font = UIFont.boldSystemFontOfSize(14)
        label.backgroundColor = UIColor.redColor()
        label.textColor = UIColor.whiteColor()
        self.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp_right).offset(-5)
            make.centerY.equalTo(self.snp_top).offset(5)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        return label
    }
    
    func buttonClicked(){
        if(buttonAction != nil){
            buttonAction!()
        }
    }
    
    func addTarget(target: AnyObject?, action: Selector, forControlEvents: UIControlEvents){
        button.addTarget(target, action: action, forControlEvents: forControlEvents)
    }

}
