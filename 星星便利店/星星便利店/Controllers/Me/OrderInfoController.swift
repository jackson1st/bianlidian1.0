//
//  orderInfoController.swift
//  Demo
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit
import SVProgressHUD
class OrderInfoController: BaseViewController {
    
    var titleLabel: UILabel?
    var subsLabel: UILabel?
    var addressTitleLabel: UILabel?
    var userName: UILabel?
    var addressInfo: UILabel?
    var addressInfoDes: UILabel?
    var addressTele: UILabel?
    var zongjia: UILabel?
    var shuliang: UILabel?
    var mingcheng: UILabel?
    var danjia: UILabel?
    var goodsimage: UIImageView?
    var payButton: UIButton?
    
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var orderInformation: orderInfo?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNetObserve(64)
        self.title = "订单详情"
        tableView.dataSource = self
        tableView.delegate = self
        removeButton.layer.borderWidth = 0.5
        removeButton.layer.cornerRadius = 5
        setRemoveButtom()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //修改取消订单的按钮文字
    func setRemoveButtom(){
        let statue = orderInformation?.orderStatu
        if(statue == "3"){
            removeButton.setTitle("删除订单", forState: .Normal)
            removeButton.addTarget(self, action: "removeOrder", forControlEvents: .TouchUpInside)
        }else{
             removeButton.setTitle("取消订单", forState: .Normal)
            removeButton.addTarget(self, action: "cancelOrder", forControlEvents: .TouchUpInside)
        }
    }
}

extension OrderInfoController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            let statue = orderInformation?.orderStatu
            return  statue == "0" ? 6 : 5
        }
        if(section == 1) {
            return (orderInformation?.itemList!.count)!
        }
        if(section == 2) {
            return 4
        }
        if(section == 3) {
            return 2
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            if(indexPath.row == 2) {
                return 85
            }
            if(indexPath.row == 5) {
                return 40
            }
        }
        if(indexPath.section == 1) {
            return 90
        }
        return 29
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "基本信息"
        }
        if(section == 1){
            return "商品列表"
        }
        if(section == 2) {
            return "价格清单"
        }
        return "发票信息"
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "contextCell"
        if(indexPath.section == 0){
            identifier = "contextCell"
            if(indexPath.row == 2) {
                identifier = "addressCell"
            }
            if(indexPath.row == 5) {
                identifier = "payCell"
            }
        }
        if(indexPath.section == 1){
            identifier = "storeCell"
        }
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        if(identifier == "contextCell"){
        titleLabel = cell?.viewWithTag(110) as? UILabel
        subsLabel = cell?.viewWithTag(111) as? UILabel
        }
        if(identifier == "addressCell"){
        addressTitleLabel = cell?.viewWithTag(210) as? UILabel
        userName = cell?.viewWithTag(211) as? UILabel
        addressInfo = cell?.viewWithTag(212) as? UILabel
        addressInfoDes = cell?.viewWithTag(213) as? UILabel
        addressTele = cell?.viewWithTag(214) as? UILabel
        }
        if(identifier == "payCell"){
        payButton = cell?.viewWithTag(310) as? UIButton
        }
        if(identifier == "storeCell"){
        goodsimage = cell?.viewWithTag(410) as? UIImageView
        mingcheng = cell?.viewWithTag(411) as? UILabel
        danjia = cell?.viewWithTag(412) as? UILabel
        shuliang = cell?.viewWithTag(413) as? UILabel
        zongjia = cell?.viewWithTag(414) as? UILabel
        }
        
        
        if(indexPath.section == 0){
            if(indexPath.row == 0) {
                titleLabel?.text = "订单编号"
                subsLabel?.text = orderInformation?.orderNo
                subsLabel?.textColor = UIColor.lightGrayColor()
            }
            if(indexPath.row == 1) {
                titleLabel?.text = "下单时间"
                subsLabel?.text = orderInformation?.payDate
                subsLabel?.textColor = UIColor.lightGrayColor()
            }
            if(indexPath.row == 2) {
                addressTitleLabel?.text = "收货地址"
                userName?.text = orderInformation!.name
                addressInfo?.text = orderInformation?.address
                addressInfoDes?.text = orderInformation?.address
                addressTele?.text = orderInformation?.tel
                
                userName?.textColor = UIColor.lightGrayColor()
                addressInfo?.textColor = UIColor.lightGrayColor()
                addressInfoDes?.textColor = UIColor.lightGrayColor()
                addressTele?.textColor = UIColor.lightGrayColor()
            }
            if(indexPath.row == 3) {
                titleLabel?.text = "支付方式"
                subsLabel?.textColor = UIColor.colorWith(255, green: 128, blue: 0, alpha: 1)
                if (orderInformation?.orderStatu)! == "1" {
                    subsLabel?.text = "货到付款"
                }
                else {
                    subsLabel?.text = "在线支付"
                }
            }
            if(indexPath.row == 4) {
                let statue = orderInformation?.orderStatu
                
                titleLabel?.text = statue == "1" || statue == "2" ? "还需支付" : "已支付"
                subsLabel?.textColor = UIColor.redColor()
                subsLabel?.text = "¥\((orderInformation?.totalAmt)!.roundedToTwoDecimals())"
            }
            if(indexPath.row == 5) {
                payButton?.layer.cornerRadius = 10
                payButton?.addTarget(self, action: "payForZhiFuBao", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        
        if(indexPath.section == 1){
            goodsimage?.sd_setImageWithURL(NSURL(string: self.orderInformation!.itemList[indexPath.row].url!), placeholderImage: UIImage(named: "quesheng"))
            let attributeText1 = NSMutableAttributedString(string: "数量: \(orderInformation!.itemList[indexPath.row].subQty!)")
            attributeText1.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText1.length - 3))
            shuliang!.attributedText = attributeText1
            mingcheng!.text = orderInformation!.itemList[0].itemName
            danjia!.text = "￥\(orderInformation!.itemList[indexPath.row].realPrice!)"
            let attributeText2 = NSMutableAttributedString(string: "合计: ￥\(self.orderInformation!.itemList[indexPath.row].subAmt!)")
            attributeText2.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText2.length - 3))
            zongjia!.attributedText = attributeText2
            let button = UIButton(frame: CGRect(x: AppWidth - 75, y: 54, width: 80, height: 30))
            button.setTitle("申请退货", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(15)
            cell?.contentView.addSubview(button)
            button.hidden = true
            if (orderInformation?.orderStatu)! == "3" {
                button.hidden = false
            }
            button.tag = indexPath.row
            button.addTarget(self, action: "applyForRetrunGoods:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                titleLabel?.text = "商品总额"
                subsLabel?.textColor = UIColor.redColor()
                subsLabel?.text = "¥\(((orderInformation?.totalAmt)! + (orderInformation?.freeAmt)!).roundedToTwoDecimals())"
            }
            if(indexPath.row == 1){
                titleLabel?.text = "促销立减"
                subsLabel?.textColor = UIColor.colorWith(0, green: 255, blue: 138, alpha: 1)
                subsLabel?.text = "-￥0.00"
            }
            if(indexPath.row == 2){
                titleLabel?.text = "积分优惠"
                subsLabel?.text = "-￥0.00"
                subsLabel?.textColor = UIColor.lightGrayColor()
            }
            if(indexPath.row == 3){
                titleLabel?.text = "应付金额"
                subsLabel?.textColor = UIColor.redColor()
                subsLabel?.text = "¥\((orderInformation?.totalAmt)!.roundedToTwoDecimals())"
            }
        }
        
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                titleLabel?.text = "发票抬头"
                subsLabel?.text = "发票索要中"
                subsLabel?.textColor = UIColor.lightGrayColor()
            }
            if(indexPath.row == 1){
                titleLabel?.text = "发票信息"
                subsLabel?.text = "发票索要中"
                subsLabel?.textColor = UIColor.lightGrayColor()
            }
        }
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
}

extension OrderInfoController {
    func payForZhiFuBao(){
        SVProgressHUD.showInfoWithStatus("建设中")
    }
    
    
    /**
    *  removeButton的取消订单的方法
    */
    func cancelOrder(){
        let alert = UIAlertController(title: "取消订单", message: "确定取消", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (UIAlertAction) -> Void in
            HTTPManager.POST(ContentType.OrderCancel, params: ["orderNo":(self.orderInformation?.orderNo)!]).responseJSON({ (json) -> Void in
                if "success" == json["message"] as! String {
                    SVProgressHUD.showSuccessWithStatus("订单取消成功")
                }
                else {
                    SVProgressTool.showErrorSVProgress(json["message"] as! String)
                }

                }) { (error) -> Void in
                    SVProgressTool.showErrorSVProgress("出错了")
                    print("发生了错误: " + (error?.localizedDescription)!)
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    /**
    *  removeButton的删除订单的方法
    */
    func removeOrder(){
        
        let alert = UIAlertController(title: "删除订单", message: "确定删除", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (UIAlertAction) -> Void in
            HTTPManager.POST(ContentType.OrderDelete, params: ["orderNo":(self.orderInformation?.orderNo)!]).responseJSON({ (json) -> Void in
                if "success" == json["message"] as! String {
                    SVProgressHUD.showSuccessWithStatus("订单删除成功")
                }
                else {
                    SVProgressTool.showErrorSVProgress(json["message"] as! String)
                }

                }) { (error) -> Void in
                    SVProgressTool.showErrorSVProgress("出错了")
                    print("发生了错误: " + (error?.localizedDescription)!)
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    func applyForRetrunGoods(sender: UIButton){
        let vc = myStoryBoard.instantiateViewControllerWithIdentifier("ReturnGoodsViewController") as! ReturnGoodsViewController
        vc.orderNo = orderInformation?.orderNo
        vc.orderSn = orderInformation?.itemList[sender.tag].orderSn
        self.navigationController?.pushViewController(vc, animated: true)
    }
}