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
    
    @IBOutlet var statuLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var buyButton: UIButton!
    weak var delegate: ButtonCellDelegate!
    
    var order: String = ""{
        didSet{
            if( order == "0") {
                cancelButton.hidden == true
                
            }
            if( order == "1") {
                cancelButton.hidden == false
            }
        }
    }
    var statu: String = ""{
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
        delegate.cancelOrder(self)
    }
    
    @objc private func spendOrderAction() {
        delegate.spendOrder(self)
    }
}
