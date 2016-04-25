//
//  SVProgressTool.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/22.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import Foundation
import SVProgressHUD

class SVProgressTool: NSObject {
    class func showFailSVProgress(){
        SVProgressHUD.showImage(UIImage(named: "icon_loadfail"), status: "失败喽")
    }
    class func showNoMoreSVProgress(){
        SVProgressHUD.showImage(UIImage(named: "icon_loadfail"), status: "没有更多喽")
    }
    class func showErrorSVProgress(str:String){
        SVProgressHUD.showImage(UIImage(named: "icon_error"), status: str)
    }
}