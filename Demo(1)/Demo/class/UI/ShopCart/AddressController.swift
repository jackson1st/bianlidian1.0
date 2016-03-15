//
//  AddressController.swift
//  Demo
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

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
        let userDefault = NSUserDefaults()
        if (UserAccountTool.judgeUserIsAddress()) {
        ad = UserAccountTool.getUserAddressInformation()!
            if(ad.count > 0) {
            var addressArray = ad[2].componentsSeparatedByString(" ")
            name.text = ad[0]
            piaddress.text = addressArray[0]
            address.text = addressArray[1]
            tele.text = ad[1]
            }
        }
        else {
            piAddress = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
            piaddress.text = piAddress
        }
    }
}

// MARK: - 处理View上的响应事件
extension AddressController {
    func didTappedAddButton() {
        
        if name.text == "" {
            MBProgressHUD.showError("请输入姓名")
            return
        }
        
        if ((tele.text?.validateMobile()) != true) {
            MBProgressHUD.showError("请输入11位正确手机号码")
            return
        }
        
        if address.text == "" {
            MBProgressHUD.showError("请填写具体地址")
            return
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        user.setObject(name.text, forKey: SD_UserDefaults_Name)
        user.setObject(tele.text, forKey: SD_UserDefaults_Telephone)
        user.setObject("\(piaddress.text!) \(address.text!)", forKey: SD_UserDefaults_Address)
        if user.synchronize() {
             self.navigationController?.popViewControllerAnimated(true)
        }
    }
}