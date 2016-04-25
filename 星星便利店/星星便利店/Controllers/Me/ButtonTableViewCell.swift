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
    @IBOutlet var buyButton: UIButton!
    weak var delegate: ButtonCellDelegate!
    
    var order: String = ""{
        didSet{
//            if( order == "0"){
//                
//                cancelButton.setTitle("取消订单", forState: .Normal)
//                statu = "待付款"
//                cancelButton.hidden = false
//                buyButton.hidden = false
//                cancelButtonOffSet.constant = 108
//            }else
//            if( order == "4" || order == "3") {
//                cancelButton.hidden = false
//                buyButton.hidden = false
//                cancelButton.setTitle("删除订单", forState: .Normal)
//                cancelButtonOffSet.constant = 108
//                statu = "已完成"
//                if( order == "4"){
//                    buyButton.setTitle("去评价", forState: .Normal)
//                }else{
//                    statu = "已取消"
//                    buyButton.hidden = true
//                    cancelButtonOffSet.constant = 20
//                }
//            }else{
//                buyButton.hidden = false
//                cancelButton.hidden = true
//                cancelButtonOffSet.constant = 108
//                switch(order){
//                    case "1": statu = "待发货"
//                    case "2": statu = "待评价"
//                default: statu = "配送中"
//                }
//            }
            if order == "2" || order == "1" {
                buyButton.setTitle("取消订单", forState: UIControlState.Normal)
            }
            else if order == "3"{
                buyButton.setTitle("删除订单", forState: UIControlState.Normal)
            }
            else if order == "4"{
                buyButton.setTitle("删除订单", forState: UIControlState.Normal)
            }
            switch(order){
                case "1": statu = "商家还未接单"
                case "2": statu = "配送中"
                case "3": statu = "订单已完成"
                case "4": statu = "已取消"
            default: statu = "配送中"
            }
        }
    }
    var statu: String!{
        didSet{
            statuLabel.text = statu
        }
    }
    
    override func awakeFromNib() {
        
        
        
//        cancelButton.layer.borderWidth = 0.5
        buyButton.layer.borderWidth = 0.5
        buyButton.layer.borderColor = UIColor.redColor().CGColor
//        cancelButton.layer.cornerRadius = 3
        buyButton.layer.cornerRadius = 3
//        cancelButton.addTarget(self, action: "cancelOrderAction", forControlEvents: UIControlEvents.TouchDown)
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
