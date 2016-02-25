//
//  makePhoneController.swift
//  Demo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class makePassController: UIViewController {
    @IBOutlet var newPassField: UITextField!
    @IBOutlet var makePassButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "修改密码"
        makePassButton.layer.cornerRadius = 4
    }
}

extension makePassController {
    
    @IBAction func makePassAction(sender: AnyObject) {
        
        let param: [String : AnyObject] = ["tel" : UserAccountTool.getUserAccount()! , "password" : newPassField.text! ]
        HTTPManager.POST(ContentType.ValidateAndSend, params: param).responseJSON({ (json) -> Void in
            print("注册界面发送验证码返回数据")
            print(json)
            let info = json as? NSDictionary
            let vc = SentSecurityCodeViewController()
            vc.phoneNumber = param["tel"] as? String
            vc.password = param["password"] as? String
            vc.codeNumber = info!["validateCode"] as? String
            vc.isMakeSecutity = true
            self.navigationController?.pushViewController(vc, animated: true)
            }) { (error) -> Void in
                SVProgressHUD.showErrorWithStatus("发送验证码失败,请点击重试", maskType: SVProgressHUDMaskType.Black)
        }
    }
}