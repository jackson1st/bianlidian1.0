//
//  ButtonTableViewCell.swift
//  Demo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: NSObjectProtocol{
    func cancelOrder(cell: ButtonTableViewCell)
    func spendOrder(cell: ButtonTableViewCell)
}
class ButtonTableViewCell: UITableViewCell{
    
    @IBOutlet weak var cancelButtonOffSet: NSLayoutConstraint!
    @IBOutlet var statuLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var buyButton: UIButton!
    weak var delegate: ButtonCellDelegate!
    
    var order: String = ""{
        didSet{
            if( order == "0"){
                cancelButton.setTitle("取消订单", forState: .Normal)
                statu = "待付款"
            }else
            if( order == "4" || order == "3") {
                cancelButton.setTitle("删除订单", forState: .Normal)
                statu = "已完成"
                if( order == "4"){
                    buyButton.setTitle("去评价", forState: .Normal)
                }else{
                    buyButton.hidden = true
                    cancelButtonOffSet.constant = 20
                }
            }else{
                cancelButton.hidden = true
                switch(order){
                    case "1": statu = "待发货"
                    case "2": statu = "待评价"
                default: statu = "配送中"
                }
            }
        }
    }
    var statu: String!{
        didSet{
            statuLabel.text = statu
        }
    }
    
    override func awakeFromNib() {
        
        
        
        cancelButton.layer.borderWidth = 0.5
        buyButton.layer.borderWidth = 0.5
        buyButton.layer.borderColor = UIColor.redColor().CGColor
        cancelButton.layer.cornerRadius = 3
        buyButton.layer.cornerRadius = 3
        cancelButton.addTarget(self, action: "cancelOrderAction", forControlEvents: UIControlEvents.TouchDown)
        buyButton.addTarget(self, action: "spendOrderAction", forControlEvents: UIControlEvents.TouchDown)
    }
    
    // MARK: - 响应事件
    /**
    - parameter button: 按钮
    */
    
    @objc private func cancelOrderAction() {
        self.delegate.cancelOrder(self)
    }
    
    @objc private func spendOrderAction() {
        delegate.spendOrder(self)
    }
}
