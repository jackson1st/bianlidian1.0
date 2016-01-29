//
//  MyCenterController.swift
//  Demo
//
//  Created by mac on 16/1/23.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class MyCenterController: UITableViewController {
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var integral: UILabel!
    @IBOutlet var iconView: IconView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 添加iconImageView

        if let data = NSData(contentsOfFile: SD_UserIconData_Path) {
            iconView.iconButton.setImage(UIImage(data: data)!.imageClipOvalImage(), forState: .Normal)
        } else {
            iconView.iconButton.setImage(UIImage(named: "my"), forState: .Normal)
        }
        
        userName.text = UserAccountTool.userName()
        
        phoneNumber.frame = CGRect(x: AppWidth - 213, y: 12, width: 180, height: 20)
        phoneNumber.text = UserAccountTool.userAccount()
        
        integral.frame = CGRect(x: AppWidth - 213, y: 12, width: 180, height: 20)
        integral.text = "\((UserAccountTool.userIntegral()!))"
        
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
        if(indexPath.section == 0 && indexPath.row == 0){
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "SignOut", object: self))
            let user = NSUserDefaults.standardUserDefaults()
            user.setObject(nil, forKey: SD_UserDefaults_Account)
            user.setObject(nil, forKey: SD_UserDefaults_Password)
            if user.synchronize() {
                navigationController!.popViewControllerAnimated(true)
            }
            do {
                // 将本地的icon图片data删除
                try NSFileManager.defaultManager().removeItemAtPath(SD_UserIconData_Path)
            } catch _ {
            }

        }
    }
}