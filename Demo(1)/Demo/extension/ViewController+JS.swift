//
//  ViewController+JS.swift
//  Demo
//
//  Created by 黄人煌 on 16/1/29.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import Foundation

extension UIViewController{
    
    
    
    func isActived() -> Bool{
        return (self.isViewLoaded() && self.view.window != nil)
    }
    
    func registerNetObserve(y: CGFloat){
        self.view.addNetWorkErrorView(y)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "netWorkOk", name: "netWorkOk", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "netWorkbad", name: "netWorkbad", object: nil)
    }
    
    func netWorkOk(){
        
        if(self.isActived() == false){
            
            return
            
        }
        print("被调用了 网络正常")
        
        let view = self.view.viewWithTag(120)
        
        
        dispatch_async(dispatch_get_main_queue()) {
            
            view?.hidden = true
            
            self.viewDidLoad()

        }

        
    }
    
    func netWorkbad(){
        
        
        if(self.isActived() == false){
            
            return
            
        }
        print(self.isViewLoaded())
        print(self.view.window)
         print("被调用了 网络不正常")
        
        let view = self.view.viewWithTag(120)
        
        
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.view.bringSubviewToFront(view!)
            view?.hidden = false
            if(HTTPManager.HUDCount > 0){
                
                MBProgressHUD.hideHUD()
                
                HTTPManager.HUDCount = 0
            }
        }
        
        
    }
}