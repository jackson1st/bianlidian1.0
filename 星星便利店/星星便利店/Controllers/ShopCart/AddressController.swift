//
//  AddressController.swift
//  Demo
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddressController: UITableViewController {
    @IBOutlet var name: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var tele: UITextField!
    @IBOutlet weak var piaddress: UITextField!
    var ad: [String] = []
    var piAddress: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
    }
    func setNv() {
        navigationItem.title = "地址信息"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedAddButton")
    }
    // MARK: - 准备UI
    func prepareUI(){
        setNv()
        let frame = CGRectMake(0, 0, 0, -0.000001)
        self.tableView.tableHeaderView = UIView.init(frame: frame)
        let appAddress = UserAccountTool.getAppAddressInfo()
        piAddress = "\(appAddress![0])-\(appAddress![1])-\(appAddress![2])"
        piaddress.text = piAddress
        if (UserAccountTool.judgeUserIsAddress()) {
        ad = UserAccountTool.getUserAddressInformation()!
            if(ad.count > 0) {
            name.text = ad[0]
            self.address.text = ad[2]
                tele.text = ad[1]
            }
        }
    }
}

// MARK: - 处理View上的响应事件
extension AddressController {
    func didTappedAddButton() {
        
        if name.text == "" {
            SVProgressTool.showErrorSVProgress("请输入姓名")
            return
        }
        
        if ((tele.text?.validateMobile()) != true) {
            SVProgressTool.showErrorSVProgress("请输入11位正确手机号码")
            return
        }
        
        if address.text == "" {
            SVProgressTool.showErrorSVProgress("请填写具体地址")
            return
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        user.setObject(name.text, forKey: "UserDefaults_Name")
        user.setObject(tele.text, forKey: "UserDefaults_Telephone")
        user.setObject("\(address.text!)", forKey: "UserDefaults_Address")
        if user.synchronize() {
             self.navigationController?.popViewControllerAnimated(true)
        }
    }
}