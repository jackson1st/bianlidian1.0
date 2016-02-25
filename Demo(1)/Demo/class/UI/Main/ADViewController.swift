//
//  ADViewController.swift
//  Demo
//
//  Created by 黄人煌 on 16/2/22.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class ADViewController: UIViewController {
    
    private lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.frame = MainBounds
        return backImageView
    }()
    
    var imageName: String? {
        didSet {
            var placeholderImageName: String?
            switch UIDevice.currentDeviceScreenMeasurement() {
            case 3.5:
                placeholderImageName = "iphone4"
            case 4.0:
                placeholderImageName = "iphone5"
            case 4.7:
                placeholderImageName = "iphone6"
            default:
                placeholderImageName = "iphone6s"
            }
            
            backImageView.sd_setImageWithURL(NSURL(string: imageName!), placeholderImage: UIImage(named: placeholderImageName!)) { (image, error, _, _) -> Void in
                if error != nil {
                    //加载广告失败
                    print("加载广告失败")
                    NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadFail, object: nil)
                }
                
                if image != nil {
                    let time = dispatch_time(DISPATCH_TIME_NOW,Int64(1.0 * Double(NSEC_PER_SEC)))
                    dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                        
                        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
                        
                        let time1 = dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC)))
                        dispatch_after(time1, dispatch_get_main_queue(), { () -> Void in
                            NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadSecussed, object: image)
                        })
                        
                    })
                } else {
                    //加载广告失败
                    print("加载广告失败")
                    NSNotificationCenter.defaultCenter().postNotificationName(ADImageLoadFail, object: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backImageView)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
}

