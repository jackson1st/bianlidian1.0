//
//  MainNavigationController.swift
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer!.delegate = nil;
    }
    
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.setImage(UIImage(named: "back_0"), forState: .Normal)
        backBtn.titleLabel?.hidden = true
        backBtn.addTarget(self, action: "backBtnClick", forControlEvents: .TouchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        let btnW: CGFloat = AppWidth > 375.0 ? 43 : 38
        backBtn.frame = CGRectMake(0, 0, btnW, 38)
        
        return backBtn
    }()
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        viewController.navigationItem.hidesBackButton = true
        if childViewControllers.count > 0 {
            
            UINavigationBar.appearance().backItem?.hidesBackButton = false
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func backBtnClick() {
        self.popViewControllerAnimated(true)
    }
    
}