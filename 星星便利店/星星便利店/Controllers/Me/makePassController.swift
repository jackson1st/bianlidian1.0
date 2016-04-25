//
//  makePhoneController.swift
//  Demo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit
import SVProgressHUD
class makePassController: BaseViewController {
    @IBOutlet var newPassField: UITextField!
    @IBOutlet var makePassButton: UIButton!
    var isForget: Bool = false
    var Accout: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "修改密码"
        makePassButton.layer.cornerRadius = 4
    }
}

extension makePassController {
    
    @IBAction func makePassAction(sender: AnyObject) {
        
        
        let param: [String : AnyObject] = ["tel" :  isForget == true ?  Accout! : UserAccountTool.getUserAccount()!, "password" : DES3Util.encrypt(newPassField.text!)]
        HTTPManager.POST(ContentType.ValidateAndSend, params: param).responseJSON({ (json) -> Void in
           
            let info = json as? NSDictionary
            let vc = SentSecurityCodeViewController()
            vc.phoneNumber = param["tel"] as? String
            vc.password = param["password"] as? String
            vc.id = info!["id"] as? String
            vc.isMakeSecutity = true
            self.navigationController?.pushViewController(vc, animated: true)
            }) { (error) -> Void in
                SVProgressTool.showErrorSVProgress("发送验证码失败,请点击重试")
        }
    }
}