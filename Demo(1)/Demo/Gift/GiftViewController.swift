//
//  GiftViewController.swift
//  Demo
//
//  Created by jason on 3/7/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit

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
    //标示页面，0：主页调用，1：订单调用，2：个人中心调用
    var selectedCallback:((GiftModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(CouponCell.self)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(mode == 1){
            selectedCallback!(gifts[indexPath.row])
        }
    }
}
