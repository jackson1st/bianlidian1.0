//
//  HTTPManager.swift
//  Demo
//
//  Created by Jason on 1/18/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit
import Alamofire
public class HTTPManager {
    static let HTTPURL = "http://139.129.45.31:8080"
    static let HTTPURL2 = "http://192.168.199.242:8080"
    static let HTTPURL3 = "http://192.168.199.134:8080"
    var request: Request!
//    static var mbp:MBProgressHUD?
    
    static var HUDCount = 0
    public static func POST(contentType: ContentType,params: [String: AnyObject]?) -> HTTPManager {
//        if(HUDCount == 0){
//            MBProgressHUD.showMessage("")
//            HUDCount = 1
//        }else{
//            HUDCount++
//        }
        
        
//        mbp = MBProgressHUD.showMessage("")
        
        HUDCount++
        
        let manager = HTTPManager()
        if(params != nil){
        manager.request = Alamofire.request(.POST, HTTPURL + contentType.rawValue, parameters: params, encoding: .JSON)
        }else{
            manager.request = Alamofire.request(.POST, HTTPURL + contentType.rawValue)
        }
        return manager
        
//        Alamofire.upload(.POST, HTTPURL + contentType.rawValue, headers: params as! [String: String], data: NSData(contentsOfURL: NSURL(string: SD_UserIconData_Path)!)!).responseJSON { (response) -> Void in
//            print(response)
//        }
    }
    
    public static func UPload(contentType: ContentType,params: [String: String]?,multipartFormData: (MultipartFormData)->Void,encodingMemoryThreshold: (Manager.MultipartFormDataEncodingResult -> Void)?){
        Alamofire.upload(.POST, HTTPURL + contentType.rawValue, headers: params, multipartFormData: multipartFormData,encodingCompletion: encodingMemoryThreshold)
    }
    
    public func responseJSON(success: (json:[String: AnyObject]) -> Void, error: (error: NSError?) -> Void ){
        request.responseJSON { (response) -> Void in
            if(response.result.isSuccess){
                success(json:(response.result.value)! as! [String : AnyObject])
                
            }else{
                error(error: response.result.error)
            }
            
            print("我是httpManagerCount\(HTTPManager.HUDCount)")
//            HTTPManager.mbp?.hide(true)
//            HTTPManager.mbp?.hidden = true
//            print("MBProgressHUD是不是隐藏了呢?\(HTTPManager.mbp?.hidden)")
//            if(HTTPManager.HUDCount == 1){
//                
////                dispatch_async(dispatch_get_main_queue(), { () -> Void in
////                    MBProgressHUD.hideHUD()
////                })
//                HTTPManager.mbp?.hide(true)
//                HTTPManager.HUDCount = 0
//            }else{
//                HTTPManager.HUDCount--
//            }
        }
    }
    
}

//let manager = AFHTTPRequestOperationManager()
//manager.requestSerializer = AFHTTPRequestSerializer()
//manager.responseSerializer = AFHTTPResponseSerializer()
//let parameter: [String : String] = ["custno" : UserAccountTool.userCustNo()!]
//let url = "\(HTTPManager.HTTPURL)/BSMD/userHeadPicSubmit.do"
//
//manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
//manager.POST(url, parameters: parameter, constructingBodyWithBlock: { (formData) -> Void in
//    
//    try! formData.appendPartWithFileURL(NSURL(fileURLWithPath: SD_UserIconData_Path), name: "image.data")
//    }, success: { (opertion, response) -> Void in
//        SVProgressHUD.showSuccessWithStatus("图片上传成功", maskType: SVProgressHUDMaskType.Black)
//    }, failure: { (opertion, error) -> Void in
//        SVProgressHUD.showErrorWithStatus("图片上传失败", maskType: SVProgressHUDMaskType.Black)
//})
//iconView!.iconButton.setImage(UIImage(data: NSData(contentsOfFile: SD_UserIconData_Path)!)!.imageClipOvalImage(), forState: .Normal)
//
//} else {
//    SVProgressHUD.showErrorWithStatus("照片保存失败", maskType: SVProgressHUDMaskType.Black)
//}
