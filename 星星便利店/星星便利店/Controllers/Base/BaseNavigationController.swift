//
//  BaseNavigationController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    var isAnimation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer!.delegate = nil
        navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        navigationBar.shadowImage = UIImage()
        navigationBar.lt_setBackgroundColor(HRHNavigationBarRedBackgroundColor)
        navigationBar.tintColor = UIColor.whiteColor()
        let navigationTitleAttribute: NSMutableDictionary = NSMutableDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        navigationBar.titleTextAttributes = navigationTitleAttribute as?[String: AnyObject]
    }
    
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.setImage(UIImage(named: "icon_back"), forState: .Normal)
        backBtn.titleLabel?.hidden = true
        backBtn.addTarget(self, action: "backBtnClick", forControlEvents: .TouchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let btnW: CGFloat = AppWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRectMake(0, 0, btnW, 40)
        
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
        popViewControllerAnimated(isAnimation)
    }
}
