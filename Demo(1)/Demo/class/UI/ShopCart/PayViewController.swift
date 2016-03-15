//
//  PayViewController.swift
//  webDemo
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {
    
    
    let addstroy = UIStoryboard(name: "PayStoryboard", bundle: nil)
    // MARK: - 属性
    @IBOutlet var tableView: UITableView!
    var payModel: [JFGoodModel] = []
    var sendTime: String!
    var noteInfo: String?
    var stampInfo: String?
    var intrgalInfo: String?
    var shopNo: String!
    
    private var totalPrice: Double!
    private var switchIsFirst: Bool = true
    private var dateArray: [String] = []
    private var id: String!
    var canUseCoupon:[GiftModel]!
    
    private var noteViewController: NoteViewController!
    private var pickView: HRHDataPickView!
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
        tableView.reloadData()
    }
    
    func setInformation(){
        sendTime = "尽快送达"
        noteInfo = ""
        intrgalInfo = "可用\(DataCenter.shareDataCenter.user.integral)积分"
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
        pickView = HRHDataPickView()
        pickView.delegate = self
        pickView.dataArray = self.dateArray
        pickView.view.backgroundColor = UIColor.colorWith(0, green: 0, blue: 0, alpha: 0.4)
        // ios 8.0 or later 新属性
        pickView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        pickView.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        
        noteViewController = addstroy.instantiateViewControllerWithIdentifier("NoteView") as? NoteViewController
        noteViewController?.noteString = noteInfo
        noteViewController?.delegate = self
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
                
                let addre: NSMutableDictionary = NSMutableDictionary()
                addre.setObject("\(NSUserDefaults().stringForKey("firstLocation")!)", forKey: "city")
                addre.setObject("\(NSUserDefaults().stringForKey("secondLocation")!)", forKey: "county")
                addre.setObject("\(NSUserDefaults().stringForKey("thirdLocation")!)", forKey: "area")
                let ad = UserAccountTool.getUserAddressInformation()
                let ad2 = ad![2].componentsSeparatedByString(" ")
                addre.setObject(ad![0], forKey: "name")
                addre.setObject(ad![1], forKey: "tel")
                addre.setObject(ad2[1], forKey: "address")
                
                let params: [String: AnyObject] = ["custNo":"\(UserAccountTool.getUserCustNo()!)","id":self.id,"addrNo":"new","invoiceFlag":"1","arriveTime":"\(self.sendTime)","payWay":"1","memo":"\(self.noteInfo!)","newUserAddr": addre]
                
                HTTPManager.POST(ContentType.OrderAdd, params: params).responseJSON({ (json) -> Void in
                    print(json)
                    if "success" == json["message"] as! String {
                        let titleInfo = "订单确认"
                        let message = "订单已经成功生成，商家正在准备配送，3小时后自动确认收货"
                        let isOk = UIAlertController(title: titleInfo, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        isOk.addAction(okPayFromAddressAction)
                        isOk.addAction(lookPayFromAddressAction)
                        self.presentViewController(isOk, animated: true, completion: nil)
                    }
                    else {
                        MBProgressHUD.showError(json["message"] as! String)
                    }
                    }, error: { (error) -> Void in
                        print(error?.localizedDescription)
                })
                
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
            MBProgressHUD.showError("请填写地址信息")
        }
 
    }
        


    func getOrderInfomation() {

        let itemList: NSMutableArray = NSMutableArray()
        
        for item in payModel {
            
            let info: [String: AnyObject] = ["barcode": "\(item.barcode!)","num": "\(item.num)"]
            itemList.addObject(info)
            
        }
        
        
        let parm: [String:AnyObject] = ["custNo": "\(UserAccountTool.getUserCustNo()!)","shopNo":"\(shopNo)","itemList": itemList]
        
        HTTPManager.POST(ContentType.OrderSetItem, params: parm).responseJSON({ (json) -> Void in
            
            if "success" == json["message"] as! String {
                print(json)
                if let orderPrice = json["orderPrice"] {
                    self.totalPrice = orderPrice["totalPay"] as! Double
                    self.sumPrice.text = "总计:\(orderPrice["realPay"] as! Double)元"
                    self.discountPrice.text = "已优惠:\((orderPrice["stampPrice"] as! Double) + (orderPrice["integralPrice"] as! Double))元"
                    self.id = json["id"] as! String
                }
            }
            }) { (error) -> Void in
                print(error?.localizedDescription)
        }
        
        
    }
    
    func useIntrgalAction(switchButton: UISwitch){
        
        if true == switchButton.on {
        HTTPManager.POST(ContentType.UseIntegral, params: ["id" : self.id,"integral": "-1"]).responseJSON({ (json) -> Void in
             print(json)
            if "success" == json["message"] as! String {
                if let orderPrice = json["orderPrice"] {
                    
                        self.sumPrice.text = "总计:\(orderPrice["realPay"] as! Double)元"
                        self.discountPrice.text = "已优惠:\((orderPrice["stampPrice"] as! Double) + (orderPrice["integralPrice"] as! Double))元"
                }
            }
            else {
                MBProgressHUD.showError(json["message"] as! String)
            }
            }, error: { (error) -> Void in
                print(error?.localizedDescription)
        })
        }
        else {
            HTTPManager.POST(ContentType.UseIntegral, params: ["id" : self.id,"integral": "0"]).responseJSON({ (json) -> Void in
                print(json)
                if "success" == json["message"] as! String {
                    if let orderPrice = json["orderPrice"] {
                            self.sumPrice.text = "总计:\(orderPrice["realPay"] as! Double)元"
                            self.discountPrice.text = "已优惠:\((orderPrice["stampPrice"] as! Double) + (orderPrice["integralPrice"] as! Double))元"
                    }
                }
                else {
                    MBProgressHUD.showError(json["message"] as! String)
                }
                }, error: { (error) -> Void in
                    print(error?.localizedDescription)
            })
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
                if noteInfo != "" {
                    cell?.detailTextLabel?.text = noteInfo!
                }
                else {
                    cell?.detailTextLabel?.text = "请填写订单备注"
                }
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
                if self.switchIsFirst {
                    switchButton?.setOn(false, animated: true)
                    switchIsFirst = false
                }
                switchButton?.addTarget(self, action: "useIntrgalAction:", forControlEvents: UIControlEvents.ValueChanged)
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
        if indexPath.section == 0 {
            let vc = addstroy.instantiateViewControllerWithIdentifier("AddVc") as! AddressController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.presentViewController(pickView, animated: true, completion: nil)
            }
            if indexPath.row == 1 {
                self.navigationController?.pushViewController(noteViewController!, animated: true)
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let vc = GiftViewController()
                vc.mode = 1
                for item in self.canUseCoupon {
                    if Double(item.minMoney) > self.totalPrice {
                        item.status = 6
                    }
                }
                vc.gifts = self.canUseCoupon
                vc.delegate = self
                vc.id = self.id
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension PayViewController: HRHDataPickViewDelegate {
    func selectButtonClick(selectString: String,DataType: Int) {
        
        switch DataType {
        case 1:
            sendTime = selectString
        case 2:
            noteInfo = selectString
        case 3:
            selectStamp(selectString)
        default:
            break
        }

        tableView.reloadData()
    }
    
    func selectStamp(info: String){
        let infoArray: [String]  = info.componentsSeparatedByString(" ")
        var stamp = infoArray[0]
        let Index = Int(infoArray[1])
        if "change" == infoArray[3] {
            for item in self.canUseCoupon {
                item.status = 4
            }
        }
        if "cancel" == infoArray[2] {
            stamp = "-1"
        }
        HTTPManager.POST(ContentType.UseStamp, params: ["stampFlowNo":"\(stamp)","id":self.id]).responseJSON({ (json) -> Void in
            print(json)
            if "success" == json["message"] as! String {
                if let orderPrice = json["orderPrice"] {
                    self.sumPrice.text = "总计:\(orderPrice["realPay"] as! Double)元"
                    self.discountPrice.text = "已优惠:\((orderPrice["stampPrice"] as! Double) + (orderPrice["integralPrice"] as! Double))元"
                    if "-1" == stamp {
                        self.canUseCoupon[Index!].status = 4
                        if self.canUseCoupon.count > 0 {
                            self.stampInfo = "有\(self.canUseCoupon.count)张优惠券可使用"
                        }
                        else {
                            self.stampInfo = "暂无可用优惠券"
                        }
                    }
                    else {
                        self.canUseCoupon[Index!].status = 5
                        self.stampInfo = "已优惠:\((orderPrice["stampPrice"] as! Double))元"
                    }
                    self.tableView.reloadData()
                }
            }
            else {
                MBProgressHUD.showError(json["message"] as! String)
            }
            }, error: { (error) -> Void in
                print(error)
        })
    }
}