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
    var sendTime: String!
    var noteInfo: String?
    var stampInfo: String?
    var intrgalInfo: String?
    var shopNo: String!
    
    private var dateArray: [String] = []
    private var id: String!
    
    
    
    
    
    @IBOutlet var sumPrice: UILabel!
    @IBOutlet var discountPrice: UILabel!
    // MARK: - view生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setInformation()
        tableView.delegate = self
        tableView.dataSource = self
        let frame = CGRectMake(0, 0, 0, -0.0001)
        self.tableView.tableHeaderView = UIView.init(frame: frame)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 10))
        imageView.image = UIImage(named: "彩带")
        tableView.footerViewForSection(0)?.backgroundView = imageView
        self.navigationItem.title = "确认订单"
        getOrderInfomation()
    }
    
    override func viewWillAppear(animated: Bool){

        super.viewWillAppear(animated)
        DataCenter.shareDataCenter.updateAllCoupons(shopNo) { (couponCount) -> Void in
            
        }
        tableView.reloadData()
        
    }
    
    func setInformation(){
        
        if DataCenter.shareDataCenter.user.coupon > 0 {
            stampInfo = "有\(DataCenter.shareDataCenter.user.coupon)张优惠券可使用"
        }
        else {
            stampInfo = "暂无可用优惠券"
        }
        sendTime = "尽快送达"
        noteInfo = "请填写备注"
        intrgalInfo = "可用\(DataCenter.shareDataCenter.user.integral)"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let item: NSString = dateFormatter.stringFromDate(NSDate())
        var min: Int = Int(item.substringWithRange(NSMakeRange(3, 2)))!
        var hour: Int = Int(item.substringWithRange(NSMakeRange(0, 2)))!
        dateArray.append("尽快送达")
        while(hour < 24) {
            if 30 > min {
                dateArray.append("\(hour):30~\(hour + 1):00")
                min = 30
            }
            else {
                dateArray.append("\(hour + 1):00~\(hour + 1):30")
                min = 0
                hour = hour + 1
            }
        }
    }
    
    
    deinit{
        
        let user = NSUserDefaults.standardUserDefaults()
        user.setObject(nil, forKey: SD_OrderInfo_Note)

    }
    
    
    // MARK: - 懒加载TabViewcellId
    private lazy var mineTitles: NSMutableArray = NSMutableArray(array: ["AddressCell", "TimeCell", "RemarksCell", "BillCell", "CouponCell","integralCell","ShopCell","NoAddressCell"])
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

                let titleInfo = "订单确认"
                let message = "订单已经成功生成，商家正在准备配送，3小时后自动确认收货"
                let user = NSUserDefaults.standardUserDefaults()
                user.setObject(nil, forKey: SD_OrderInfo_Note)
                let isOk = UIAlertController(title: titleInfo, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                isOk.addAction(okPayFromAddressAction)
                isOk.addAction(lookPayFromAddressAction)
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
        
//    func modelChangeDict() -> NSMutableDictionary{
//        //地址信息封装成dictitionary
//        let address = UserAccountTool.getUserAddressInformation()!
//        let receiveAddress: NSMutableDictionary = NSMutableDictionary()
//        receiveAddress.setObject(address[2], forKey: "address")
//        receiveAddress.setObject(address[1], forKey: "tel")
//        //封装orderinfo
//        let orderInfo: NSMutableDictionary = NSMutableDictionary()
//        orderInfo.setObject(UserAccountTool.getUserCustNo()!, forKey: "custNo")
//        orderInfo.setObject(self.sumprice, forKey: "totalAmt")
////        orderInfo.setObject(self.disprice, forKey: "freeAmt")
//        orderInfo.setObject(self.shopNo,forKey: "shopNo")
//        orderInfo.setObject(receiveAddress, forKey: "receiveAddress")
//        //封装itemList
//        let itemList: NSMutableArray = NSMutableArray()
//        for var i=0; i<self.payModel.count; i++ {
//            //单个商品
//            let shop: NSMutableDictionary = NSMutableDictionary()
//            shop.setObject(self.payModel[i].barcode!, forKey: "barcode")
//            shop.setObject(self.payModel[i].num, forKey: "subQty")
//            itemList.addObject(shop)
//        }
//        let dict: NSMutableDictionary = NSMutableDictionary()
//        dict.setObject(orderInfo, forKey: "orderInfo")
//        dict.setObject(itemList, forKey: "itemList")
//        return dict
//    }
    
    
//    func returnbranchInfo() -> NSMutableDictionary{
//        let dict: NSMutableDictionary = NSMutableDictionary()
//        let barcodes: NSMutableArray = NSMutableArray()
//        for var i=0; i<self.payModel.count; i++ {
//            barcodes.addObject(payModel[i].barcode!)
//        }
//        dict.setObject(barcodes, forKey: "barcodes")
//        dict.setObject(payModel[0].custNo!, forKey: "custNo")
//        return dict
//    }
    
    
//    func sentOrderInformation() -> Bool{
//        let userDefault = NSUserDefaults()
//        var userID: String?
//        if UserAccountTool.userIsLogin() {
//         userID = userDefault.objectForKey(SD_UserDefaults_Account) as? String
//        }
//        let parameters: [String : AnyObject] =  (modelChangeDict() as? [String : AnyObject])!
//        
//        HTTPManager.POST(ContentType.OrderAdd, params: parameters).responseJSON({ (json) -> Void in
//            
//            }) { (error) -> Void in
//                SVProgressHUD.showErrorWithStatus("数据加载失败，请检查网络连接", maskType: SVProgressHUDMaskType.Black)
//        }
//        return true
//    }

    func getOrderInfomation() {

        let itemList: NSMutableArray = NSMutableArray()
        
        for item in payModel {
            
            let info: [String: AnyObject] = ["barcode": "\(item.barcode!)","num": "\(item.num)"]
            itemList.addObject(info)
            
        }
        
        
        let parm: [String:AnyObject] = ["custNo": "\(UserAccountTool.getUserCustNo()!)","shopNo":"\(shopNo)","itemList": itemList]
        
        HTTPManager.POST(ContentType.OrderSetItem, params: parm).responseJSON({ (json) -> Void in
            
            if "success" == json["message"] as! String {
                if let orderPrice = json["orderPrice"] {
                    self.sumPrice.text = "\(orderPrice["realPay"] as! Double)"
                    self.discountPrice.text = "\((orderPrice["stampPrice"] as! Double) + (orderPrice["integralPrice"] as! Double))"
                    self.id = json["id"] as! String
                }
            }
            }) { (error) -> Void in
                print(error?.localizedDescription)
        }
        
//        HTTPManager.POST(ContentType.IntGet, params: ["custNo": "\(UserAccountTool.getUserCustNo()!)"]).responseJSON({ (json) -> Void in
//            if "success" == json["message"] as! String {
//                DataCenter.shareDataCenter.user.integral = json["integral"] as! Int
//                
//                HTTPManager.POST(ContentType.UseIntegral, params: ["integral": DataCenter.shareDataCenter.user.integral,"id": "\(self.id!)"]).responseJSON({ (json) -> Void in
//                    print(json)
//                    if "success" == json["message"] as! String{
//                        if let orderPrice = json["orderPrice"] {
//                           self.discount = orderPrice["integralPrice"] as! Double
//                        }
//                        self.tableView.reloadData()
//                    }
//                    }, error: { (error) -> Void in
//                        print(error?.localizedDescription)
//                })
//                
//                
//            }
//            else {
//                MBProgressHUD.showError("\(json["message"] as! String)")
//            }
//            }) { (error) -> Void in
//                print(error?.localizedDescription)
//        }
        
        
        
    }
    
    func useIntrgalAction(switchButton: UISwitch){
        if true == switchButton.on {
            
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
            return 2
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
        cellId = mineTitles[indexPath.section + 2 + indexPath.row] as! String
        }
        else {
        cellId = mineTitles[6] as! String
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
                cell?.detailTextLabel?.text = sendTime!
            }
            if indexPath.row == 1 {
                cell?.detailTextLabel?.text = noteInfo!
            }
        }
        else if 2 == indexPath.section {
            if 0 == indexPath.row {

                cell?.detailTextLabel?.text = stampInfo!
                
            }
            else {
                let intrgal = cell?.viewWithTag(30011) as? UILabel
                let switchButton = cell?.viewWithTag(30012) as? UISwitch
                intrgal?.text = intrgalInfo!
                switchButton?.setOn(false, animated: true)
                switchButton?.addTarget(self, action: "useIntrgalAction:", forControlEvents: UIControlEvents.EditingChanged)
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
              let  pickView = HRHDataPickView()
              pickView.delegate = self
              pickView.dataArray = self.dateArray
              // ios 8.0 or later 新属性
              pickView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
              pickView.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
              self.presentViewController(pickView, animated: false, completion: { () -> Void in
                 pickView.view.backgroundColor = UIColor.colorWith(0, green: 0, blue: 0, alpha: 0.4)
              })
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

extension PayViewController: HRHDataPickViewDelegate {
    func selectButtonClick(selectString: String) {
        sendTime = selectString
        tableView.reloadData()
    }
}