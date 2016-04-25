//
//  GiftViewController.swift
//  Demo
//
//  Created by jason on 3/7/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit
import SVProgressHUD
class GiftViewController: UITableViewController {

    var gifts = [GiftModel]()
    var mode:Int!{
        didSet{
            switch(mode){
            case 0:
                self.title = "领取优惠劵"
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: CloseVC)
            case 1:
                self.title = "选择优惠劵"
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: CloseVC)
            case 2:
                self.title = "我的优惠劵"
            default:break
            }
            
        }
    }
    var id: String?
    
    
    
    func prepareData() {
        switch mode {
        case 0:
            gifts = DataCenter.shareDataCenter.canGetCoupons
        case 1:
            break
        case 2:
            gifts = DataCenter.shareDataCenter.allCoupons
        default:
            gifts = []
        }
        tableView.reloadData()
    }
    
    //标示页面，0：主页调用，1：订单调用，2：个人中心调用
    
    var delegate: HRHDataPickViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(CouponCell.self)
        tableView.backgroundColor =  UIColor.colorWithCustom(242, g: 242, b: 242)
        self.tableView.separatorStyle = .None
        prepareData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CouponCell
        cell.coupon = gifts[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(mode == 1 && gifts[indexPath.row].status == 4 || gifts[indexPath.row].status == 5 ){
            let item = gifts.filter({ (GiftModel) -> Bool in
                GiftModel.status == 5
            })
            if item.count > 0 {
                if gifts[indexPath.row].status == 4 {
                    HTTPManager.POST(ContentType.UseStamp, params: ["stampFlowNo":"-1","id":self.id!]).responseJSON({ (json) -> Void in
                        if "success" == json["message"] as! String{
                            self.gifts[indexPath.row].status = 5
                            self.delegate?.selectButtonClick("\(self.gifts[indexPath.row].stampFlowNo!) \(indexPath.row) use change", DataType: 3)
                            tableView.reloadData()
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        }, error: { (error) -> Void in
                            SVProgressTool.showErrorSVProgress("发生了错误")
                            print(error?.localizedDescription)
                    })
                }
                else {
                    gifts[indexPath.row].status = 4
                    delegate?.selectButtonClick("\(gifts[indexPath.row].stampFlowNo!) \(indexPath.row) cancel unchange", DataType: 3)
                    tableView.reloadData()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            else {
                if gifts[indexPath.row].status != 5 {
                    gifts[indexPath.row].status = 5
                    delegate?.selectButtonClick("\(gifts[indexPath.row].stampFlowNo!) \(indexPath.row) use unchange", DataType: 3)
                    tableView.reloadData()
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    gifts[indexPath.row].status = 4
                    delegate?.selectButtonClick("\(gifts[indexPath.row].stampFlowNo!) \(indexPath.row) cancel unchange", DataType: 3)
                    tableView.reloadData()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
}
