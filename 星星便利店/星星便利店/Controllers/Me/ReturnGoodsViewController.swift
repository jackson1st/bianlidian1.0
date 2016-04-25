//
//  ReturnGoodsViewController.swift
//  Demo
//
//  Created by 黄人煌 on 16/3/16.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit
import SVProgressHUD
class ReturnGoodsViewController: BaseViewController {
    
    var orderNo: String!
    var orderSn: Int!
    
    @IBOutlet weak var returnGoodsCount: UITextField!
    @IBOutlet weak var applyForButton: UIButton!
    @IBOutlet weak var returnGoodsExplain: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "申请售后"
        applyForButton.addTarget(self, action: "applyForReturnGoods", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    func applyForReturnGoods(){
        
        if returnGoodsCount.text == nil {
            SVProgressTool.showErrorSVProgress("请填写退货数量")
            return
        }
        if returnGoodsExplain.text == nil {
            SVProgressTool.showErrorSVProgress("请填写退货原因")
            return
        }
        let hub = MBProgressHUD(view: self.view)
        HTTPManager.POST(ContentType.RefundApply, params: ["orderNo":"\(orderNo!)","orderSn":"\(orderSn!)","applyNum":"\(returnGoodsCount.text!)","applyType":"0","applyReason":"\(returnGoodsExplain.text!)"]).responseJSON({ (json) -> Void in
            if "success" == json["message"] as! String{
                SVProgressHUD.showSuccessWithStatus("提交成功,我们会刚正面的!")
                self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                SVProgressTool.showErrorSVProgress(json["message"] as! String)
            }
            },hud: hub) { (error) -> Void in
                SVProgressTool.showErrorSVProgress("出错了")
                print(error?.localizedDescription)
        }
        
        
    }
}
