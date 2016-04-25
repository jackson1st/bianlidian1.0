//
//  HTTPManager.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import Alamofire
public class HTTPManager {
    
    static let HTTPURL1 = "http://139.129.45.31:8080"
    static let HTTPURL5 = "http://192.168.31.14:8080"
    static let HTTPURL4 = "http://192.168.199.134:8080"
    static let HTTPURL = "http://120.76.27.227:8080"
    static let HTTPURL2 = "http://192.168.1.178:8080"
    var request: Request!
    static var mbp:MBProgressHUD?
    
    static var HUDCount = 0{
        didSet{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = HTTPManager.HUDCount>0
        }
        
    }
    
    class func POST(contentType: ContentType,params: [String: AnyObject]?) -> HTTPManager {
        HTTPManager.HUDCount++
        
        
        let manager = HTTPManager()
        if(params != nil){
            manager.request = Alamofire.request(.POST, HTTPURL + contentType.rawValue, parameters: params, encoding: .JSON)
        }else{
            manager.request = Alamofire.request(.POST, HTTPURL + contentType.rawValue)
        }
        return manager
        
    }
    
    public class func UPload(contentType: ContentType,params: [String: String]?,multipartFormData: (MultipartFormData)->Void,encodingMemoryThreshold: (Manager.MultipartFormDataEncodingResult -> Void)?){
        
        
        Alamofire.upload(.POST, HTTPURL + contentType.rawValue, headers: params, multipartFormData: multipartFormData,encodingCompletion: encodingMemoryThreshold)
        
    }
    
    public func responseJSON(success: (json:[String: AnyObject]) -> Void, hud:MBProgressHUD? = nil, error: (error: NSError?) -> Void){
        request.responseJSON { (response) -> Void in
            if(response.result.isSuccess){
                success(json:(response.result.value)! as! [String : AnyObject])
                
            }else{
                error(error: response.result.error)
            }
            HTTPManager.HUDCount--
            if let hud = hud{
                hud.hidden = true
            }
        }

    }
    
}

