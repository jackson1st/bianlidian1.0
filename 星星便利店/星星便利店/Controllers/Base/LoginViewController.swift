//
//  LoginViewController.swift
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//  登陆控制器

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController, UIScrollViewDelegate {
    
    var backScrollView: UIScrollView!
    var topView: UIView!
    var phoneTextField: UITextField!
    var psdTextField: UITextField!
    var loginButton: UIButton!
    var resignButton: UIButton!
    var forgetButton: UIButton!
    let textCoclor: UIColor = UIColor.colorWith(50, green: 50, blue: 50, alpha: 1)
    let loginW: CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "登录"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //添加scrollView
        addScrollView()
        addResignButton()
        addLoginButton()
        addForgetButton()
        // 添加手机文本框和密码文本框
        addTextField()
    }
    
    func addScrollView() {
        backScrollView = UIScrollView(frame: view.bounds)
        backScrollView.backgroundColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
        backScrollView.alwaysBounceVertical = true
        let tap = UITapGestureRecognizer(target: self, action: "backScrollViewTap")
        backScrollView.addGestureRecognizer(tap)
        view.addSubview(backScrollView)
    }
    
    func addLoginButton() {
        loginButton = UIButton(frame: CGRect(x: 30, y: 120, width: AppWidth - 2 * 30, height: 35))
        loginButton.backgroundColor = UIColor.colorWith(90, green: 193, blue: 223, alpha: 1)
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.tintColor = UIColor.whiteColor()
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        loginButton.layer.cornerRadius = 3
        loginButton.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        backScrollView.addSubview(loginButton)
    }
    
    func addForgetButton() {
        forgetButton = UIButton(frame: CGRect(x: 30, y: 165, width: 65, height: 30))
        forgetButton.setTitle("忘记密码?", forState: UIControlState.Normal)
        forgetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        forgetButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        forgetButton.addTarget(self, action: "forgetClick", forControlEvents: UIControlEvents.TouchUpInside)
        backScrollView.addSubview(forgetButton)
    }
    
    func addResignButton(){
        resignButton = UIButton(frame: CGRect(x: AppWidth - 60, y: 165, width: 40, height: 30))
        resignButton.setTitle("注册", forState: UIControlState.Normal)
        resignButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        resignButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        resignButton.addTarget(self, action: "resignClick", forControlEvents: UIControlEvents.TouchUpInside)
        backScrollView.addSubview(resignButton)

    }
    func addTextField() {
        let textH: CGFloat = 40
        let leftDistance: CGFloat = 20
        let leftMargin: CGFloat = 10
        let alphaV: CGFloat = 0.4
        topView = UIView(frame: CGRectMake(0, 20, AppWidth, textH * 2))
        topView?.backgroundColor = UIColor.whiteColor()
        backScrollView.addSubview(topView!)
        
        let line1 = UIView(frame: CGRectMake(0, 0, AppWidth, 0.5))
        line1.backgroundColor = UIColor.lightGrayColor()
        line1.alpha = alphaV
        topView!.addSubview(line1)
        
        phoneTextField = UITextField()
        phoneTextField?.keyboardType = UIKeyboardType.NumberPad
        addTextFieldToTopViewWiht(phoneTextField!, frame: CGRectMake(leftDistance, 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "请输入手机号")
        
        let line2 = UIView(frame: CGRectMake(leftDistance, textH, AppWidth, 0.5))
        line2.backgroundColor = UIColor.lightGrayColor()
        line2.alpha = alphaV
        topView!.addSubview(line2)
        
        psdTextField = UITextField()
        psdTextField.secureTextEntry = true
        addTextFieldToTopViewWiht(psdTextField!, frame: CGRectMake(leftDistance, textH + 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "密码")
        
        let line3 = UIView(frame: CGRectMake(0, textH * 2, AppWidth, 0.5))
        line3.backgroundColor = UIColor.lightGrayColor()
        line3.alpha = alphaV
        topView!.addSubview(line3)
    }
    
    
    func addTextFieldToTopViewWiht(textField: UITextField ,frame: CGRect, placeholder: String) {
        textField.frame = frame
        textField.autocorrectionType = .No
        textField.clearButtonMode = .Always
        textField.backgroundColor = UIColor.whiteColor()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFontOfSize(14)
        topView!.addSubview(textField)
    }
    

    
    /// 登录按钮被点击
    func loginClick() {
        
         NSNotificationCenter.defaultCenter().postNotificationName("Login", object: self)
        if !phoneTextField.text!.validateMobile() {
            SVProgressTool.showErrorSVProgress("输入正确的用户名哦")
            return
        } else if
            psdTextField.text!.isEmpty {
            SVProgressTool.showErrorSVProgress("密码不能为空哦")
            return
        }
        let account = phoneTextField.text
        let psdMD5 = DES3Util.encrypt(psdTextField.text) 
        login(account!, passWord: psdMD5!) { () -> Void in
            //登录成功后执行操作
            DataCenter.shareDataCenter.updateIntegral()
            CollectionModel.CollectionCenter.loadDataFromNet(1, count: 100, success: { (data) -> Void in
                DataCenter.shareDataCenter.user.collect = data.count
                }, callback: nil)
            Model.defaultModel.loadDataForNetWork(nil)
            DataCenter.shareDataCenter.updateAllCoupons("", callBack: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    func forgetClick(){
        
        if !phoneTextField.text!.validateMobile() {
            SVProgressTool.showErrorSVProgress("输入正确的用户名哦")
            return
        }
        
        let vc = myStoryBoard.instantiateViewControllerWithIdentifier("makePassController") as! makePassController
        vc.isForget = true
        vc.Accout = phoneTextField.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resignClick(){
        let vc = ResignViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func backScrollViewTap() {
        view.endEditing(true)
    }
}
extension  LoginViewController {
     func login(userName: String,passWord: String, success: (() -> Void)?) {
        
        let parameters = ["username":userName,
            "password":passWord]
        SVProgressHUD.showWithStatus("加载中", maskType: SVProgressHUDMaskType.Clear)
        HTTPManager.POST(ContentType.LoginMobile, params: parameters).responseJSON({ (json) -> Void in
            print(json)
            let infomation = json as? NSDictionary
            if(infomation!["status"] as? String == "success") {
                
                let custNo = infomation!["userInfo"]!["custNo"] as? String
                let userName = infomation!["userInfo"]!["username"] as? String
                let imageUrl = infomation!["userInfo"]!["imageUrl"] as? String
                let integral = infomation!["userInfo"]!["integral"] as? Int
                let tel = infomation!["userInfo"]!["tel"] as? String
                let userRole = infomation!["userInfo"]!["role"] as? String
                var shopNo: String? = nil
                if userRole == "1" {
                    shopNo = infomation!["userInfo"]!["shopNo"] as? String
                }
                UserAccountTool.setUserInfo(tel!, passWord: passWord, custNo: custNo!, userName: userName!, imageUrl: imageUrl!, integral: integral!,shopNo: shopNo)
                if NSUserDefaults.standardUserDefaults().synchronize() {
                    success!()
                }
                SVProgressHUD.showSuccessWithStatus("登录成功")
                return
            }
            else {
                SVProgressHUD.showErrorWithStatus(infomation!["status"] as? String)
            }
            
            }){ (error) -> Void in
                SVProgressTool.showErrorSVProgress("发生了错误")
        }
    }
}