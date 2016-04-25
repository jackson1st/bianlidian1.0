//
//  MyCenterController.swift
//  Demo
//
//  Created by mac on 16/1/23.
//  Copyright © 2016年 Fjnu. All rights reserved.
//
//  我的订单

import UIKit
import MJRefresh
import SVProgressHUD
class OrderViewController: BaseViewController{
    
    @IBOutlet var seg: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    private var lackOfInformation: LackOfInformationView!
    private var orderArray: OrderModel!
    private var orderStatu: String = "-1"
    private var pageIndex: Int! = 2
    
    private let orderStatuArray:[String] = ["待接单","待收货","已完成"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNetObserve(64)
        title = "我的订单"
        view.backgroundColor = theme.SDBackgroundColor
        pullRefreshData()
        setTableView()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setTableView(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "ButtonTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "buttonCell1")
        // 设置TableViewHeader
    self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.pullRefreshData()
        })
        
        self.tableView.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: { () -> Void in
            self.dropDownLoading()
        })
        lackOfInformation = LackOfInformationView(frame: CGRectMake(0, 0, AppWidth, AppHeight), imageName: "noorders", title: "没有订单")
        self.tableView.addSubview(lackOfInformation)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        pullRefreshData()
    }
    
    func pullRefreshData(){
        //重新加载所有数据
        orderStatu = "\(seg.selectedSegmentIndex)"
        if seg.selectedSegmentIndex == 0 {
            orderStatu = "\(seg.selectedSegmentIndex - 1)"
        }
       loadDataModel("\(orderStatu)",requestType: true)
    }
    
    func dropDownLoading(){
        //原有数据上增加
        orderStatu = "\(seg.selectedSegmentIndex)"
        if seg.selectedSegmentIndex == 0 {
            orderStatu = "\(seg.selectedSegmentIndex - 1)"
        }
        loadDataModel("\(orderStatu)", requestType: false)
    }
    
}
// MARK: - view 上的处理
extension OrderViewController {

    @IBAction func changeSegment(sender: AnyObject) {
        orderStatu = "\(seg.selectedSegmentIndex)"
        if seg.selectedSegmentIndex == 0 {
            orderStatu = "\(seg.selectedSegmentIndex - 1)"
        }
        loadDataModel(orderStatu,requestType: true)
    }
    //从服务器上载入数据并封装成对象
    func loadDataModel(orderStatu: String, requestType: Bool){
        let custNo: String = UserAccountTool.getUserCustNo()!
        var parameters: [String : AnyObject]
        if(requestType == true) {
            
            parameters = ["No": custNo,"pageIndex":1,"pageCount":10,"orderStatu":orderStatu]
            
        }
        else {
            parameters = ["No": custNo,"pageIndex":self.pageIndex,"pageCount":10,"orderStatu":orderStatu]
            self.pageIndex = self.pageIndex + 1
        }
        HTTPManager.POST(ContentType.UserOrder, params: parameters ).responseJSON({ (json) -> Void in
            print(parameters)
            if let orderpage = json as? NSDictionary {
                if let page = orderpage["orderPage"] as? NSDictionary {
                    let exp = OrderModel()
                    exp.listorder = []
                    exp.dataCount = page["dataCount"] as! Int
                    if let list = page["list"] as? NSArray {
                        for var i=0 ; i<list.count ; i++ {
                            let listorder = orderInfo()
                            if let oinfo = list[i]["orderInfo"] as? NSDictionary {
                                listorder.orderNo = oinfo["orderNo"] as? String
                                listorder.totalAmt = oinfo["totalAmt"] as? Double
                                listorder.freeAmt = oinfo["freeAmt"] as? Double
                                listorder.payDate = oinfo["createDateString"] as! String
                                listorder.orderStatu = oinfo["orderStatu"] as? String
                                listorder.itemNum  = oinfo["itemNum"] as! Int
                                if let receiveAddress = oinfo["receiveAddress"] as? NSDictionary {
                                    listorder.address = receiveAddress["address"] as?
                                    String
                                    listorder.tel = receiveAddress["tel"] as? String
                                    listorder.name = receiveAddress["name"] as? String
                                }
                            }
                            if let item = list[i]["itemList"] as? NSArray {
                                listorder.itemList = []
                                for var j=0 ; j<item.count ; j++ {
                                    let itemList = goodList()
                                    itemList.nowUnit = item[j]["nowUnit"] as? String
                                    itemList.nowPack = item[j]["nowPack"] as! Int
                                    itemList.subQty = item[j]["subQty"] as! Int
                                    itemList.subAmt = item[j]["subAmt"] as? Double
                                    itemList.orgPrice = item[j]["orgPrice"] as? Double
                                    itemList.realPrice = item[j]["realPrice"] as?
                                    Double
                                    itemList.orderSn = item[j]["orderSn"] as! Int
                                    if let good = item[j]["item"] as? NSDictionary {
                                        itemList.itemName = good["itemName"] as? String
                                        itemList.url = good["url"] as? String
                                    }
                                    listorder.itemList?.append(itemList)
                                }
                            }
                            if(requestType == false) {
                                if self.orderArray.listorder.count < exp.dataCount {
                                    self.orderArray.listorder.append(listorder)
                                }
                                else {
                                    SVProgressHUD.showInfoWithStatus("没有更多了..", maskType: SVProgressHUDMaskType.Black)
                                }
                            }
                            exp.listorder?.append(listorder)
                        }
                    }
                    if(requestType == true) {
                        self.orderArray = exp
                        self.pageIndex = 2
                    }
                }
            }
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            }) { (error) -> Void in
                SVProgressTool.showErrorSVProgress("出错了")
                print("发生了错误\(error)")
        }
    }
    
}
// MARK: - tableview 上的数据和协议
extension OrderViewController: UITableViewDataSource,UITableViewDelegate {
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.orderArray == nil {
            return 0
        }
        else {
            if self.orderArray.listorder.count == 0 {
                lackOfInformation.hidden = false
                self.tableView.mj_footer.hidden = true
            }
            else {
                lackOfInformation.hidden = true
                self.tableView.mj_footer.hidden = false
            }
            return self.orderArray.listorder.count
        }
    }
    
    internal func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    internal func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = ""
        if(indexPath.row == 0){
            cellId = "title"
        }
        else if(indexPath.row == 1){
            cellId = "store"
        }
        else if(indexPath.row == 2){
            cellId = "foot"
        }
        else if (indexPath.row == 3) {
//            print(self.orderArray.listorder[indexPath.section].orderNo)
//            if (self.orderArray.listorder[indexPath.section].orderStatu == "0") {
//                cellId = "buttonCell1"
//            }
            cellId = "buttonCell2"
//            else if (self.orderArray.listorder[indexPath.section].orderStatu == "2" || self.orderArray.listorder[indexPath.section].orderStatu == "1") {
//                cellId = "buttonCell2"
//            }
        }
        if(indexPath.row != 3) {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)

        if(cellId == "title"){
            let dingDanHao = cell?.viewWithTag(10001) as! UILabel
            let dingDanZhuangtai = cell?.viewWithTag(10002) as! UILabel
            dingDanHao.text = self.orderArray.listorder[indexPath.section].orderNo
            dingDanZhuangtai.text = self.orderArray.listorder[indexPath.section].payDate
            // cell取消选中效果
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if(cellId == "store"){
            let goodsimage = cell?.viewWithTag(20001) as! UIImageView
            let mingcheng = cell?.viewWithTag(20002) as! UILabel
            let danjia = cell?.viewWithTag(20003) as! UILabel
            let shuliang = cell?.viewWithTag(20004) as! UILabel
            let zongjia = cell?.viewWithTag(20005) as! UILabel
            goodsimage.sd_setImageWithURL(NSURL(string: self.orderArray.listorder[indexPath.section].itemList[0].url!), placeholderImage: UIImage(named: "quesheng"))
            let attributeText1 = NSMutableAttributedString(string: "数量: \(self.orderArray.listorder[indexPath.section].itemList[0].subQty!)")
            attributeText1.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText1.length - 3))
            shuliang.attributedText = attributeText1
            mingcheng.text = self.orderArray.listorder[indexPath.section].itemList[0].itemName
            danjia.text = "￥\(self.orderArray.listorder[indexPath.section].itemList[0].realPrice!.roundedToTwoDecimals())"
            let attributeText2 = NSMutableAttributedString(string: "合计: ￥\(self.orderArray.listorder[indexPath.section].itemList[0].subAmt!.roundedToTwoDecimals())")
            attributeText2.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText2.length - 3))
            zongjia.attributedText = attributeText2
            // cell取消选中效果
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if(cellId == "foot"){
            let shuliang = cell?.viewWithTag(30001) as! UILabel
            let zongjia = cell?.viewWithTag(30003) as! UILabel
            let sl = self.orderArray.listorder[indexPath.section].itemNum
            shuliang.text = "共\(sl!)件商品"
            let attributeText = NSMutableAttributedString(string: "总计: ￥\(self.orderArray.listorder[indexPath.section].totalAmt!.roundedToTwoDecimals())")
            attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText.length - 3))
            zongjia.attributedText = attributeText
            // cell取消选中效果
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if(cellId == "buttonCell2"){
            let button = cell?.viewWithTag(50001) as! UIButton
            let label = cell?.viewWithTag(50002) as! UILabel
            
            label.text = orderStatuArray[Int(orderArray.listorder[indexPath.section].orderStatu!)!]
            
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.grayColor().CGColor
            button.layer.cornerRadius = 3
            if(self.orderArray.listorder[indexPath.section].orderStatu == "1" || self.orderArray.listorder[indexPath.section].orderStatu == "2") {
                button.setTitle("取消订单", forState: UIControlState.Normal)
            }
            else if self.orderArray.listorder[indexPath.section].orderStatu == "3" {
                button.setTitle("删除订单", forState: UIControlState.Normal)
            }
            button.addTarget(self, action: "clickButtonInOrder:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        return cell!
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("buttonCell1") as! ButtonTableViewCell
            cell.delegate = self
            cell.order = self.orderArray.listorder[indexPath.section].orderStatu!
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 40.0
        }
        else if(indexPath.row == 1){
            return 90.0
        }
        else {
            return 40.0
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = myStoryBoard.instantiateViewControllerWithIdentifier("OrderInfoController") as? OrderInfoController
        vc?.orderInformation = self.orderArray.listorder[indexPath.section]
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}

extension OrderViewController: ButtonCellDelegate {
    func cancelOrder(cell: ButtonTableViewCell) {
        // 根据cell获取当前模型
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        
        }
    func spendOrder(cell: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        print("我点击了按钮")
        let alert = UIAlertController(title: cell.buyButton.titleLabel?.text, message: "确定" + (cell.buyButton.titleLabel?.text)! + "?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            if ("2" == self.orderArray.listorder[indexPath.section].orderStatu! || "1" == self.orderArray.listorder[indexPath.section].orderStatu!) {
                let param:[String : AnyObject] = ["orderNo":"\(self.orderArray.listorder[indexPath.section].orderNo!)"]
                HTTPManager.POST(ContentType.OrderCancel, params: param).responseJSON({ (json) -> Void in
                    
                    if "success" == json["message"] as! String {
                        SVProgressHUD.showSuccessWithStatus("订单取消成功")
                        self.pullRefreshData()
                    }
                    else {
                        SVProgressTool.showErrorSVProgress(json["message"] as! String)
                    }
                    }, error: { (error) -> Void in
                        SVProgressTool.showErrorSVProgress("出错了")
                        print(error?.localizedDescription)
                })
            }
            
            if ("3" == self.orderArray.listorder[indexPath.section].orderStatu! || "4" == self.orderArray.listorder[indexPath.section].orderStatu!) {
                let param:[String : AnyObject] = ["orderNo":"\(self.orderArray.listorder[indexPath.section].orderNo!)"]
                HTTPManager.POST(ContentType.OrderDelete, params: param).responseJSON({ (json) -> Void in
                    
                    if "success" == json["message"] as! String {
                        SVProgressHUD.showSuccessWithStatus("订单删除成功")
                        self.pullRefreshData()
                    }
                    else {
                        SVProgressTool.showErrorSVProgress(json["message"] as! String)
                    }
                    }, error: { (error) -> Void in
                        SVProgressTool.showErrorSVProgress("出错了")
                })
                
            }
            
        }))
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        

    }
    
    func clickButtonInOrder(cell: ButtonTableViewCell){
        print(cell)
        // 根据cell获取当前模型
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
    }
}