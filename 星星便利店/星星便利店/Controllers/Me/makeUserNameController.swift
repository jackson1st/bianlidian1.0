//
//  makeUserNameController.swift
//  Demo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit
import SVProgressHUD

class makeUserNameController: BaseViewController {
    
    @IBOutlet var makeUserName: UITextField!
    
    @IBOutlet var makeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "修改用户名"
        makeButton.layer.cornerRadius = 4
    }
}

extension makeUserNameController {
    
    @IBAction func makeAction(sender: AnyObject) {
        
        if  (makeUserName.text?.characters.count)! < 2 || (makeUserName.text?.characters.count)! > 14 {
            SVProgressTool.showErrorSVProgress("请确认用户名长度正确")
            return
        }
        
        else {
            
            let hud = MBProgressHUD(view: self.view)
            HTTPManager.POST(ContentType.updateUserName, params: ["custno":UserAccountTool.getUserCustNo()!,"username":makeUserName.text!]).responseJSON({ (json) -> Void in
                if "success" == json["status"] as! String {
                    SVProgressHUD.showSuccessWithStatus("修改成功喽")
                    UserAccountTool.setUserName(self.makeUserName.text!)
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    SVProgressTool.showErrorSVProgress(json["status"] as! String)
                }
                },hud: hud, error: { (error) -> Void in
                    SVProgressTool.showErrorSVProgress("出错了")
                    print(error)
            })
            
        }
        
        
    }
    
}