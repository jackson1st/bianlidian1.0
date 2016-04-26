//
//  ShopManageViewController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/31.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

enum requestType:String {
    case NoReceive = "1"
    case UnReceive = "2"
    case Success = "3"
    case Refuse = "4"
}

class ShopManageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seg: UISegmentedControl!
    private var pageIndex:Int! = 1
    private var orderModel:[orderMageeModel]! = []
    private var afterModel:[afterApplyModel]! = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        title = "店铺订单"
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadDataFormSeg(true)
            self.tableView.mj_header.endRefreshing()
        })
        tableView.mj_footer = MJRefreshBackFooter(refreshingBlock: {
            self.loadDataFormSeg(false)
            self.tableView.mj_footer.endRefreshing()
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFormSeg(true)
    }
    
    @IBAction func segChangeAction(sender: AnyObject) {
        loadDataFormSeg(true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if seg.selectedSegmentIndex == 3 {
            return afterModel.count ?? 0
        }
        else {
            return (orderModel.count) ?? 0
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "OrderCell"
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId)!
        
        let timeLabel = cell.viewWithTag(1) as! UILabel
        let statuLabel = cell.viewWithTag(2) as! UILabel
        let NoLabel = cell.viewWithTag(3) as! UILabel
        timeLabel.font = UIFont.systemFontOfSize(14)
        NoLabel.font = UIFont.systemFontOfSize(14)
        if UIDevice.currentDeviceScreenMeasurement() == 3.5 {
            timeLabel.font = UIFont.systemFontOfSize(12)
            NoLabel.font = UIFont.systemFontOfSize(12)
        }
        if seg.selectedSegmentIndex != 3 {
            
            timeLabel.text = "下单时间：" + orderModel[indexPath.section].createDateString
            switch orderModel[indexPath.section].orderStatu {
            case "1":  statuLabel.text = "未接单"
            case "2":  statuLabel.text = "配送中"
            case "3":  statuLabel.text = "已完成"
            case "4":  statuLabel.text = "该订单无效"
            default:
                statuLabel.text = "该订单无效"
            }
            NoLabel.text = "订单编号：" + orderModel[indexPath.section].orderNo
        }
        else {
            
            timeLabel.text = "时间：\(afterModel[indexPath.section].applyTimeString)"
            NoLabel.text = "订单编号：" + afterModel[indexPath.section].applyNo
            switch afterModel[indexPath.section].applyType {
            case "0":
                statuLabel.text = "未审核"
            default:
                statuLabel.text = "未审核"
            }
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let story = UIStoryboard.init(name: "ManagerStoryboard", bundle: nil)
        let vc = story.instantiateViewControllerWithIdentifier("ManageOrderViewController") as! ManageOrderViewController
        if seg.selectedSegmentIndex == 3 {
            vc.after = self.afterModel[indexPath.section]
            vc.isAfter = true
        }
        else {
            vc.orderInfo = self.orderModel[indexPath.section]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadDataFormSeg(isRefresh: Bool){
        switch seg.selectedSegmentIndex {
        case 0:
            lodDataFormNet(isRefresh, orderType: .NoReceive)
        case 1:
            lodDataFormNet(isRefresh, orderType: .UnReceive)
        case 2:
            lodDataFormNet(isRefresh, orderType: .Success)
        case 3 :
            lodDataFormNet(isRefresh, orderType: .Refuse)
        default:
            break
            
        }
    }
    
}
extension ShopManageViewController {
    func lodDataFormNet(isRefresh:Bool,orderType:requestType){
        
        weak var tmpself = self
        if isRefresh {
             tmpself?.pageIndex = 1
        }
        else {
             tmpself?.pageIndex = (tmpself?.pageIndex)! + 1
        }
        print(tmpself?.pageIndex)
        if orderType.rawValue == "4" {
            let param:[String:AnyObject] = ["No":UserAccountTool.getUserCustNo()!,"pageIndex":"\(self.pageIndex)","pageCount":"10","applyType":"-1","appFlag":"-1"]
            HTTPManager.POST(ContentType.AfterShop, params: param).responseJSON({ (json) in
                print(json)
                if "success" == json["message"] as! String {
                    if isRefresh == true {
                        var after:[afterApplyModel] = []
                        if let array = json["Page"]!["list"] as? NSArray {
                            for x in array {
                                after.append(afterApplyModel(dict: (x as? [String:AnyObject])!))
                            }
                        }
                        tmpself?.afterModel = after
                    }
                    else {
                        if self.pageIndex <= json["pageSize"] as! Int{
                        
                            if let array = json["list"] as? NSArray {
                                for x in array {
                                    tmpself?.afterModel.append(afterApplyModel(dict: x as! [String : AnyObject]))
                                }
                            }
                        }
                        else {
                            SVProgressTool.showErrorSVProgress("没有更多了")
                        }
                    }

                    tmpself?.tableView.reloadData()
                }
                else {
                    SVProgressTool.showErrorSVProgress(json["message"] as! String)
                }
                }, error: { (error) in
                    dPrint(error?.localizedDescription)
                    SVProgressTool.showErrorSVProgress("出错了")
            })
            return
        }
        
        let param:[String:AnyObject] = ["shopNo":(UserAccountTool.getUserShopNo())!,"querystatu":orderType.rawValue,"pageIndex":"\(self.pageIndex)","pageCount":"10","startTime":"","endTime":""]
        HTTPManager.POST(ContentType.SearchManageOrder, params: param ).responseJSON({ (json) -> Void in
            print(json)
            if "success" == json["message"] as! String {
                if isRefresh == true {
                    var orderModelArray:[orderMageeModel] = []
                    if let array = json["orderList"] as? NSArray {
                        for x in array {
                            orderModelArray.append(orderMageeModel(dict: x as! [String:AnyObject]))
                        }
                    }
                    tmpself?.orderModel = orderModelArray
                }
                else {
                    if self.pageIndex <= json["pageSize"] as! Int{
                        if let array = json["orderList"] as? NSArray {
                            for x in array {
                                tmpself?.orderModel.append(orderMageeModel(dict: x as! [String:AnyObject]))
                            }
                        }
                    }
                    else {
                        SVProgressTool.showErrorSVProgress("没有更多了")
                    }
                }
                tmpself?.tableView.reloadData()
            }
            else {
                SVProgressTool.showErrorSVProgress(json["message"] as! String)
            }
            }) { (error) -> Void in
                dPrint(error?.localizedDescription)
                SVProgressTool.showErrorSVProgress("出错了")
        }
        
        
    }
}
