//
//  PayViewController.swift
//  webDemo
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {
    
    
    // MARK: - 属性
    @IBOutlet var tableView: UITableView!
    var payModel: [JFGoodModel] = []
    var sumprice: String!
    var disprice: String!
    var sendTime: String = "尽快送达"
    var noteInfo: String?
    var needPay: String!
    var discount: String!
    var shopNo: String!
    @IBOutlet var sumPrice: UILabel!
    @IBOutlet var discountPrice: UILabel!
    // MARK: - view生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        sumPrice.text = needPay
        discountPrice.text = discount
        tableView.delegate = self
        tableView.dataSource = self
        let frame = CGRectMake(0, 0, 0, -0.0001)
        self.tableView.tableHeaderView = UIView.init(frame: frame)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 10))
        imageView.image = UIImage(named: "彩带")
        tableView.footerViewForSection(0)?.backgroundView = imageView
        self.navigationItem.title = "确认订单"
    }
    
    override func viewWillAppear(animated: Bool){

        super.viewWillAppear(animated)
        DataCenter.shareDataCenter.updateAllCoupons(shopNo) { (couponCount) -> Void in
            
        }
        tableView.reloadData()
        
    }
    
    deinit{
        
        let user = NSUserDefaults.standardUserDefaults()
        user.setObject(nil, forKey: SD_OrderInfo_Note)

    }
    // MARK: - 懒加载TabViewcellId
    private lazy var mineTitles: NSMutableArray = NSMutableArray(array: ["AddressCell", "TimeCell", "RemarksCell", "BillCell", "CouponCell","ShopCell","NoAddressCell"])
}

// MARK: - 按钮响应事件 以及逻辑方法
extension PayViewController {
    
    @IBAction func okSelect(sender: AnyObject) {
        print("我点了确认下单")
        //逻辑检查: 是否已经填写好了收货地址信息
        if UserAccountTool.judgeUserIsAddress() {
            let title = "选择付款方式"
            let messge = ""
            let payFromAddress = "货到付款"
            let payFromZhiFuBao = "支付宝付款"
            let backTitle = "返回"
            let ispay = UIAlertController(title: title, message: messge, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let cancelAction = UIAlertAction(title: backTitle, style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                print("取消了订单")
            }
            let okPayFromAddressAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            let lookPayFromAddressAction = UIAlertAction(title: "查看订单", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                let OrederStoryBoard = UIStoryboard(name: "MyOrderStoryBoard", bundle: nil)
                let orderVC = OrederStoryBoard.instantiateViewControllerWithIdentifier("OrderView") as? OrderViewController
                self.navigationController!.pushViewController(orderVC!, animated: true)
            }
            
            let payFromAddressAction = UIAlertAction(title: payFromAddress, style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                print("使用了货到付款")
                self.sentOrderInformation()
                let titleInfo = "订单确认"
                let message = "订单已经成功生成，商家正在准备配送，3小时后自动确认收货"
                let user = NSUserDefaults.standardUserDefaults()
                user.setObject(nil, forKey: SD_OrderInfo_Note)
                let isOk = UIAlertController(title: titleInfo, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                isOk.addAction(okPayFromAddressAction)
                isOk.addAction(lookPayFromAddressAction)
                self.removeShoppingCartGoods()
                self.presentViewController(isOk, animated: true, completion: nil)
            }
            let payFromZhiFbaoAcction = UIAlertAction(title: payFromZhiFuBao, style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                print("使用了支付宝付款")
            }
            ispay.addAction(cancelAction)
            ispay.addAction(payFromZhiFbaoAcction)
            ispay.addAction(payFromAddressAction)
            self.presentViewController(ispay, animated: true, completion: nil)
            
        }
        else {
            SVProgressHUD.showInfoWithStatus("请填写地址信息")
        }
 
    }
        
    func modelChangeDict() -> NSMutableDictionary{
        //地址信息封装成dictitionary
        let address = UserAccountTool.getUserAddressInformation()!
        let receiveAddress: NSMutableDictionary = NSMutableDictionary()
        receiveAddress.setObject(address[2], forKey: "address")
        receiveAddress.setObject(address[1], forKey: "tel")
        //封装orderinfo
        let orderInfo: NSMutableDictionary = NSMutableDictionary()
        orderInfo.setObject(UserAccountTool.getUserCustNo()!, forKey: "custNo")
        orderInfo.setObject(self.sumprice, forKey: "totalAmt")
        orderInfo.setObject(self.disprice, forKey: "freeAmt")
        orderInfo.setObject("202",forKey: "shopNo")
        orderInfo.setObject("1", forKey: "addrNo")
        orderInfo.setObject(receiveAddress, forKey: "receiveAddress")
        //封装itemList
        let itemList: NSMutableArray = NSMutableArray()
        for var i=0; i<self.payModel.count; i++ {
            //单个商品
            let shop: NSMutableDictionary = NSMutableDictionary()
            shop.setObject(self.payModel[i].barcode!, forKey: "barcode")
            shop.setObject(self.payModel[i].num, forKey: "subQty")
            itemList.addObject(shop)
        }
        let dict: NSMutableDictionary = NSMutableDictionary()
        dict.setObject(orderInfo, forKey: "orderInfo")
        dict.setObject(itemList, forKey: "itemList")
        return dict
    }
    func returnbranchInfo() -> NSMutableDictionary{
        let dict: NSMutableDictionary = NSMutableDictionary()
        let barcodes: NSMutableArray = NSMutableArray()
        for var i=0; i<self.payModel.count; i++ {
            barcodes.addObject(payModel[i].barcode!)
        }
        dict.setObject(barcodes, forKey: "barcodes")
        dict.setObject(payModel[0].custNo!, forKey: "custNo")
        return dict
    }
    func sentOrderInformation() -> Bool{
        let userDefault = NSUserDefaults()
        var userID: String?
        if UserAccountTool.userIsLogin() {
         userID = userDefault.objectForKey(SD_UserDefaults_Account) as? String
        }
        let parameters: [String : AnyObject] =  (modelChangeDict() as? [String : AnyObject])!
        
        HTTPManager.POST(ContentType.OrderAdd, params: parameters).responseJSON({ (json) -> Void in
            
            }) { (error) -> Void in
                SVProgressHUD.showErrorWithStatus("数据加载失败，请检查网络连接", maskType: SVProgressHUDMaskType.Black)
        }
        return true
    }
    //删除已经提交订单的商品
    func removeShoppingCartGoods(){
        for var i = 0; i<Model.defaultModel.shopCart.count; i++ {
            if(Model.defaultModel.shopCart[i].selected == true ) {
                Model.defaultModel.removeAtIndex(i, success: { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("login", object: self)
                })
            }
        }
    }

}
    // MARK: - tableview 的datasource 和 delegate

extension PayViewController: UITableViewDataSource,UITableViewDelegate{
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        }
        else if(section == 1) {
            return 3
        }
        else if(section == 2) {
            return 1
        }
        else {
            return self.payModel.count
        }
    }
    internal func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            if UserAccountTool.judgeUserIsAddress() == false {
                return 52
            }
            else {
                return 80
            }
        }
        else if(indexPath.section == 1 || indexPath.section == 2) {
            return 44
        }
        else {
            return 52
        }
    }
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = ""
        if(indexPath.section == 0){
            if UserAccountTool.judgeUserIsAddress() == false {
                cellId = "NoAddressCell"
            }
            else {
                cellId = mineTitles[indexPath.section + indexPath.row] as! String
            }
        }
        else if(indexPath.section == 1){
        cellId = mineTitles[indexPath.section + indexPath.row] as! String
        }
        else if(indexPath.section == 2){
        cellId = mineTitles[indexPath.section + 2] as! String
        }
        else {
        cellId = mineTitles[5] as! String
        }
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        if indexPath.section == 0 && cellId == "AddressCell"{
           let name = cell?.viewWithTag(10011) as? UILabel
           let tele = cell?.viewWithTag(10012) as? UILabel
           let address = cell?.viewWithTag(10013) as? UILabel
           let ad: [String] = UserAccountTool.getUserAddressInformation()!
           name?.text = ad[0]
           tele?.text = ad[1]
           address?.text = ad[2]
           
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = sendTime
            }
            if indexPath.row == 1 {
                if UserOrderInfo.isNote() {
                cell?.detailTextLabel?.text = UserOrderInfo.orderInfoNote()
                    
                }
                else {
                    cell?.detailTextLabel?.text = "点击添加备注"
                }
            }
        }
        else if indexPath.section == 3 {
           let name = cell?.viewWithTag(20011) as? UILabel
           let remark = cell?.viewWithTag(20012) as? UILabel
           let many = cell?.viewWithTag(20013) as? UILabel
           let price = cell?.viewWithTag(20014) as? UILabel
           name?.text = self.payModel[indexPath.row].itemName
           remark?.text = self.payModel[indexPath.row].itemSize
           many?.text = "×\(self.payModel[indexPath.row].num)"
           price?.text = "￥\(self.payModel[indexPath.row].totalPrice!)"
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let addstroy = UIStoryboard(name: "PayStoryboard", bundle: nil)
        if indexPath.section == 0 {
            let vc = addstroy.instantiateViewControllerWithIdentifier("AddVc") as! AddressController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
              let  pickView = HRHDatePickerView.instanceDatePickerView()
                pickView!.frame = CGRectMake(0, 0, AppWidth, AppHeight + 20);
                pickView!.backgroundColor = UIColor.clearColor()
                pickView!.delegate = self
                var type = DateType.init(0)
                pickView!.type = type
                pickView.datePickerView?.datePickerMode = UIDatePickerMode.DateAndTime
                pickView.datePickerView?.minuteInterval = 15
                pickView.datePickerView?.minimumDate = NSDate()
                pickView!.datePickerView?.setDate(NSDate(), animated: true)
                self.view.addSubview(pickView!)
            }
            if indexPath.row == 1 {
                let vc = addstroy.instantiateViewControllerWithIdentifier("NoteView") as? NoteViewController
                if UserOrderInfo.isNote() {
                    vc?.noteString = UserOrderInfo.orderInfoNote()
                }
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
}

// MARK: - 自定义delegate
extension PayViewController: HRHDatePickerViewDelegate {
    func getSelectDate(date: String!, type: DateType) {
        switch (type) {
        case DateTypeOfStart :
            sendTime = "\(date)"
            self.tableView.reloadData()
            break
        default:
            self.tableView.reloadData()
            break
        }
        
    }
}
