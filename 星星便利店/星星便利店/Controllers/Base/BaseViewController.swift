//
//  BaseViewController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import SVProgressHUD
class BaseViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HRHGlobalBackgroundColor
        // 状态栏设置成白色
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
    }
    
}
