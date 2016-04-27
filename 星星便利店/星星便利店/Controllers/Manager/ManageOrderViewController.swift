//
//  ManageOrderViewController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/4/6.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import SVProgressHUD
class ManageOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var orderStatu: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    var orderInfo: orderMageeModel!
    var after:afterApplyModel!
    var isAfter:Bool = false
    private var rowCout:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.delegate = self
        tabelView.dataSource = self
        if UIDevice.currentDeviceScreenMeasurement() < 4.7 {
            addressLabel.font = UIFont.systemFontOfSize(14)
            NameLabel.font = UIFont.systemFontOfSize(14)
            orderStatu.font = UIFont.systemFontOfSize(12)
            orderTime.font = UIFont.systemFontOfSize(12)
            PhoneLabel.font = UIFont.systemFontOfSize(14)
        }
        if isAfter {
            addressLabel.hidden = true
            NameLabel.text =  "申请类型:" + (after.applyType == "0" ? "退货" : "换货")
            PhoneLabel.text = "申请用户:"+after.username
            orderStatu.text = "订单编号:" + after.applyNo
            orderTime.text = "申请时间:" + "\(after.applyTimeString)"
            orderNo.text = "待审核"
            rowCout = 1
        }
        else {
            addressLabel.text = "用户地址:" + orderInfo.address
            NameLabel.text = "姓名:" + orderInfo.userName
            PhoneLabel.text = "电话:" + orderInfo.tel
            orderNo.text = orderInfo.orderNo
            switch orderInfo.orderStatu {
            case "1":  orderNo.text = "未接单"
            case "2":  orderNo.text = "配送中"
            case "3":  orderNo.text = "已完成"
            case "4":  orderNo.text = "该订单无效"
            default:
                orderNo.text = "该订单无效"
            }
            
            orderTime.text = "下单时间:" + orderInfo.createDateString
            orderStatu.text = "订单编号:" + orderInfo.orderNo
            rowCout = self.orderInfo.orderList.count
        }
        orderTime.sizeToFit()
        orderStatu.sizeToFit()
        tabelView.tableFooterView = UIView()
        title = "订单核查"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if rowCout == 0 {
            return 0
        }
        else {
            return rowCout + 3
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
            if indexPath.row < rowCout + 1 {
                return 44
            }
            else if indexPath.row == rowCout + 1 {
                return 60
            }
            else {
                if UIDevice.currentDeviceScreenMeasurement() < 4.7 {
                    return 60
                }
                else {
                    return 70
                }
            }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < rowCout {
            let cell = tableView.dequeueReusableCellWithIdentifier("goodCell")
            let goodName = cell?.viewWithTag(1) as! UILabel
            let numLabel = cell?.viewWithTag(2) as! UILabel
            let priceLabel = cell?.viewWithTag(3) as! UILabel
            if isAfter {
                goodName.text = after.itemName
                numLabel.text = "×\(after.applyNum)"
                priceLabel.hidden = true
            }
            else {
                goodName.text = orderInfo.orderList[indexPath.row].itemName
                numLabel.text = "×\(orderInfo.orderList[indexPath.row].subQty)"
                priceLabel.text = "\(orderInfo.orderList[indexPath.row].realPrice)"
            }
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        else if  indexPath.row == rowCout {
            let cell = tableView.dequeueReusableCellWithIdentifier("goodCell")
            let goodName = cell?.viewWithTag(1) as! UILabel
            let numLabel = cell?.viewWithTag(2) as! UILabel
            let priceLabel = cell?.viewWithTag(3) as! UILabel
            if isAfter {
                goodName.hidden = true
                numLabel.hidden = true
                priceLabel.hidden = true
            }
            else {
                if indexPath.row == rowCout {
                    goodName.text = "总计"
                    numLabel.text = nil
                    priceLabel.text = "¥\(orderInfo.totalAmt)"
                    priceLabel.textColor = UIColor.redColor()
                }
            }
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        
        else if indexPath.row == rowCout + 1 {
            let cell = tabelView.dequeueReusableCellWithIdentifier("noteCell")
            let noteLabel = cell?.viewWithTag(4) as! UILabel
            if isAfter {
                noteLabel.text = "申请理由:" + after.applyReason
            }
            else {
                if orderInfo.memo != nil  {
                    noteLabel.text = "用户备注:" + orderInfo.memo!
                }
                else {
                    noteLabel.text = "用户备注:"
                }
            }
            noteLabel.sizeToFit()
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        
        else {
            let cell = tabelView.dequeueReusableCellWithIdentifier("btnCell")
            let noButton = cell?.viewWithTag(5) as! UIButton
            let yesButton = cell?.viewWithTag(6) as! UIButton
            noButton.layer.masksToBounds = true
            noButton.layer.cornerRadius = 4
            noButton.addTarget(self, action: #selector(ManageOrderViewController.setNo), forControlEvents: UIControlEvents.TouchUpInside)
            yesButton.layer.masksToBounds = true
            yesButton.layer.cornerRadius = 4
            yesButton.addTarget(self, action: #selector(ManageOrderViewController.setYes), forControlEvents: UIControlEvents.TouchUpInside)
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            if isAfter {
                yesButton.setTitle("审核通过", forState: UIControlState.Normal)
                noButton.setTitle("我拒绝", forState: UIControlState.Normal)
            }
            else {
                switch orderInfo.orderStatu {
                    case "1": yesButton.setTitle("确认接单", forState: UIControlState.Normal)
                    case "2": noButton.hidden = true
                    yesButton.setTitle("确认完成", forState: UIControlState.Normal)
                    case "3": yesButton.hidden = true
                    noButton.hidden = true
                    default: break
                }
            }
            return cell!
        }
    }
    
    func setNo(){
        if isAfter {
            HTTPManager.POST(ContentType.AfterCheck, params: ["applyNo":after.applyNo,"cheakResult":"unPass"]).responseJSON({ (json) in
                print(json)
                    if "success" == json["message"] as! String {
                        SVProgressHUD.showSuccessWithStatus("更新成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    else {
                        SVProgressTool.showErrorSVProgress(json["message"] as! String)
                    }

                }, error: { (error) in
                     SVProgressTool.showErrorSVProgress("网络错误")
            })
        }
        else {
            switch orderInfo.orderStatu {
            case "1":
                HTTPManager.POST(ContentType.AuditOrder, params: ["orderNo":orderInfo.orderNo,"result":"4"]).responseJSON({ (json) in
                    if "OK" == json["message"] as! String {
                        SVProgressHUD.showSuccessWithStatus("更新成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    else {
                        SVProgressTool.showErrorSVProgress("出错了")
                    }
                    }) { (error) in
                        SVProgressTool.showErrorSVProgress("出错了")
                }
            default: break
            }
        }
    }
    
    func setYes(){
        
        if isAfter {
            HTTPManager.POST(ContentType.AfterCheck, params: ["applyNo":after.applyNo,"cheakResult":"Pass"]).responseJSON({ (json) in
                if "success" == json["message"] as! String {
                    SVProgressHUD.showSuccessWithStatus("更新成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    SVProgressTool.showErrorSVProgress(json["message"] as! String)
                }
                
                }, error: { (error) in
                    SVProgressTool.showErrorSVProgress("网络错误")
            })
        }
        else {
            switch orderInfo.orderStatu {
            case "1":
            HTTPManager.POST(ContentType.AuditOrder, params: ["orderNo":orderInfo.orderNo,"result":"2"]).responseJSON({ (json) in
                if "更新成功" == json["message"] as! String {
                    SVProgressHUD.showSuccessWithStatus("更新成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    SVProgressTool.showErrorSVProgress("出错了")
                }
                }) { (error) in
                    SVProgressTool.showErrorSVProgress("出错了")
            }
            case "2":
            HTTPManager.POST(ContentType.SureReceived, params: ["orderNo":orderInfo.orderNo]).responseJSON({ (json) in
                    print(json)
                    if "OK" == json["message"] as! String {
                        SVProgressHUD.showSuccessWithStatus("更新成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    else {
                        SVProgressTool.showErrorSVProgress("出错了")
                    }
                }) { (error) in
                    SVProgressTool.showErrorSVProgress("出错了")
                }
     
            default: break
            
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
