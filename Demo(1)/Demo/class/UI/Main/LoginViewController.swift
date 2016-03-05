//
//  LoginViewController.swift
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//  登陆控制器

import UIKit


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
        let alphaV: CGFloat = 0.2
        topView = UIView(frame: CGRectMake(0, 20, AppWidth, textH * 2))
        topView?.backgroundColor = UIColor.whiteColor()
        backScrollView.addSubview(topView!)
        
        let line1 = UIView(frame: CGRectMake(0, 0, AppWidth, 1))
        line1.backgroundColor = UIColor.grayColor()
        line1.alpha = alphaV
        topView!.addSubview(line1)
        
        phoneTextField = UITextField()
        phoneTextField?.keyboardType = UIKeyboardType.NumberPad
        addTextFieldToTopViewWiht(phoneTextField!, frame: CGRectMake(leftDistance, 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "请输入手机号")
        
        let line2 = UIView(frame: CGRectMake(0, textH, AppWidth, 1))
        line2.backgroundColor = UIColor.grayColor()
        line2.alpha = alphaV
        topView!.addSubview(line2)
        
        psdTextField = UITextField()
        psdTextField.secureTextEntry = true
        addTextFieldToTopViewWiht(psdTextField!, frame: CGRectMake(leftDistance, textH + 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "密码")
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
            SVProgressHUD.showErrorWithStatus("请输入11位的正确手机号", maskType: SVProgressHUDMaskType.Black)
            return
        } else if
            psdTextField.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("密码不能为空", maskType: SVProgressHUDMaskType.Black)
            return
        }
        let account = phoneTextField.text
        let psdMD5 = psdTextField.text
        login(account!, passWord: psdMD5!) { () -> Void in
            //登录成功后执行操作
            CollectionModel.CollectionCenter.loadDataFromNet(0, count: 100, success: nil, callback: { () -> Void in
                let collectNum = CollectionModel.CollectionCenter.Likes.count
                UserAccountTool.setUserCollectNum(collectNum)
            })
            Model.defaultModel.loadDataForNetWork({ () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }

    func forgetClick(){

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
        MBProgressHUD.showMessage("登录中....")
        HTTPManager.POST(ContentType.LoginMobile, params: parameters).responseJSON({ (json) -> Void in
            print(json)
            
            let infomation = json as? NSDictionary

            if(infomation!["status"] as? String == "success") {
                
                let custNo = infomation!["userInfo"]!["custNo"] as? String
                let userName = infomation!["userInfo"]!["username"] as? String
                let imageUrl = infomation!["userInfo"]!["imageUrl"] as? String
                let integral = infomation!["userInfo"]!["integral"] as? Int
                UserAccountTool.setUserInfo(userName!, passWord: passWord, custNo: custNo!, userName: userName!, imageUrl: imageUrl!, integral: integral!)
                success!()
                MBProgressHUD.hideHUD()
                return
            }
            else {
                MBProgressHUD.hideHUD()
                SVProgressHUD.showErrorWithStatus(infomation!["status"] as? String)
            }
            
            }) { (error) -> Void in
              SVProgressHUD.showErrorWithStatus("登录失败，请检查网络")
               MBProgressHUD.hideHUD()
        }
    }
}