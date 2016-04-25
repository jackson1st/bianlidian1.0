//
//  MyCenterController.swift
//  Demo
//
//  Created by mac on 16/1/23.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class MyCenterController: UITableViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "个人中心"
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius =
            iconImageView.frame.width / 2
        // 添加iconImageView
        navigationController?.setNavigationBarHidden(false, animated: true)
        if let data = NSData(contentsOfFile: SD_UserIconData_Path) {
            iconImageView.image = UIImage(data: data)
        } else {
            iconImageView.image = UIImage(named: "v2_my_avatar")
        }
        
        userName.text = UserAccountTool.getUserName()
        
        phoneNumber.frame = CGRect(x: AppWidth - 213, y: 12, width: 180, height: 20)
        phoneNumber.text = UserAccountTool.getUserAccount()
        let range  = Range(start: phoneNumber.text!.startIndex.advancedBy(3), end: phoneNumber.text!.endIndex.advancedBy(-4))
        phoneNumber.text = "\(phoneNumber.text!.stringByReplacingCharactersInRange(range, withString: "****"))"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.userName.text = UserAccountTool.getUserName()
    }
    
    
    @IBAction func signOutAction(sender: AnyObject) {
        
        HTTPManager.POST(ContentType.logoutMobile, params: nil).responseJSON({ (json) in
            
            if "success" == json["status"] as! String {
                let user = NSUserDefaults.standardUserDefaults()
                user.setObject(nil, forKey: "UserDefaults_Account")
                user.setObject(nil, forKey: "UserDefaults_Password")
                if user.synchronize() {
                    DataCenter.shareDataCenter.updateCanGetCoupons(nil)
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "CarNumChanged", object: self))
                    self.navigationController!.popViewControllerAnimated(true)
                }

            }
            else {
                 SVProgressTool.showErrorSVProgress("出错了")
            }
            
            
            }) { (error) in
                SVProgressTool.showErrorSVProgress("出错了")
        }
    }
}

extension MyCenterController {
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}