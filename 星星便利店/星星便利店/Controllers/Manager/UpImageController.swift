//
//  UpImageController.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/4/23.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class UpImageController: UIViewController,UINavigationControllerDelegate {
    let imageTag = 2000
    let textViewHeight: CGFloat = 100
    let pictureHW = (AppWidth - 5 * 10)/4
    let MaxSmallImageCount = 1
    let MaxImageCount = 9
    let deleImageWH:CGFloat = 25 // 删除按钮的宽高
    let IPCViewHeight: CGFloat = 120
    private var imageClass = 1
    
    private lazy var iconActionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从手机相册选择")
    private lazy var pickVC: UIImagePickerController = {
        let pickVC = UIImagePickerController()
        pickVC.delegate = self
        pickVC.allowsEditing = true
        return pickVC
    }()
    
    @IBOutlet weak var nameLabel: UILabel!
    var data: UpImageModel!
    
    override func viewDidLoad() {
        
        nameLabel.text = data.itemName
        initSmallImageUI()
        initImageUI()
    }
    
    func initSmallImageUI(){
        var imageCount: NSInteger = 0
        if data.url != nil {
             imageCount = 1
        }
        for i in 0 ..< imageCount {
            let pictureImageView = UIImageView(frame: CGRectMake(10+CGFloat(i%4)*(10+pictureHW), 140 + 10 + CGFloat(i/4)*(pictureHW + 10), pictureHW, pictureHW))
            pictureImageView.sd_setImageWithURL(NSURL(string: data.url!), placeholderImage: UIImage(named: "v2_placeholder_square"))
//            //用作放大图片
//            let tap = UITapGestureRecognizer.init(target: self, action: Selector("tapImageView:"))
//            pictureImageView.addGestureRecognizer(tap)
//            //添加删除按钮
//            let dele = UIButton(type: UIButtonType.Custom)
//            dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH)
//            dele.setImage(UIImage(named: "deletePhoto"), forState: UIControlState.Normal)
//            dele.addTarget(self, action: Selector("delePic:"), forControlEvents: UIControlEvents.TouchUpInside)
//            pictureImageView.addSubview(dele)
            
            pictureImageView.tag = Int(imageTag) + i
            pictureImageView.userInteractionEnabled = true

            view.addSubview(pictureImageView)
        }
        if (imageCount < MaxSmallImageCount) {
            let addPictureButton = UIButton(frame: CGRectMake(10 + CGFloat(imageCount%4)*(pictureHW+10), 140 + 10 + CGFloat(imageCount/4)*(pictureHW+10), pictureHW, pictureHW))
            addPictureButton.setBackgroundImage(UIImage(named: "addPictures"), forState:UIControlState.Normal)
            addPictureButton.addTarget(self, action: #selector(UpImageController.addPicture), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(addPictureButton)
        }
        
    }
    
    func initImageUI(){
        let imageCount: NSInteger = data.topUrl.count
        for i in 0 ..< imageCount {
            let pictureImageView = UIImageView(frame: CGRectMake(10+CGFloat(i%4)*(10+pictureHW), 286 + 10 + CGFloat(i/4)*(pictureHW + 10), pictureHW, pictureHW))
            pictureImageView.sd_setImageWithURL(NSURL(string: data.topUrl[i]), placeholderImage: UIImage(named: "v2_placeholder_square"))
            //            //用作放大图片
            //            let tap = UITapGestureRecognizer.init(target: self, action: Selector("tapImageView:"))
            //            pictureImageView.addGestureRecognizer(tap)
            //            //添加删除按钮
            //            let dele = UIButton(type: UIButtonType.Custom)
            //            dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH)
            //            dele.setImage(UIImage(named: "deletePhoto"), forState: UIControlState.Normal)
            //            dele.addTarget(self, action: Selector("delePic:"), forControlEvents: UIControlEvents.TouchUpInside)
            //            pictureImageView.addSubview(dele)
            
            pictureImageView.tag = Int(imageTag) + i
            pictureImageView.userInteractionEnabled = true
            
            view.addSubview(pictureImageView)
        }
        if (imageCount < MaxImageCount) {
            let addPictureButton = UIButton(frame: CGRectMake(10 + CGFloat(imageCount%4)*(pictureHW+10), 286 + 10 + CGFloat(imageCount/4)*(pictureHW+10), pictureHW, pictureHW))
            addPictureButton.setBackgroundImage(UIImage(named: "addPictures"), forState:UIControlState.Normal)
            addPictureButton.addTarget(self, action: #selector(UpImageController.addPicture), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(addPictureButton)
        }
    }
    
    func addPicture(){
       iconActionSheet.showInView(self.view)
    }
}
/// MARK: UIActionSheetDelegate
extension UpImageController: UIActionSheetDelegate {
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex, terminator: "")
        switch buttonIndex {
        case 1:
            openCamera()
        case 2:
            openUserPhotoLibrary()
        default:
            print("", terminator: "")
        }
    }
    
}
/// MARK: 摄像机和相册的操作和代理方法
extension UpImageController: UIImagePickerControllerDelegate {
    
    /// 打开照相功能
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            pickVC.sourceType = .Camera
            imageClass = 1
            self.presentViewController(pickVC, animated: true, completion: nil)
        } else {
            SVProgressHUD.showErrorWithStatus("模拟器没有摄像头,请链接真机调试", maskType: SVProgressHUDMaskType.Black)
        }
    }
    
    /// 打开相册
    private func openUserPhotoLibrary() {
        pickVC.sourceType = .PhotoLibrary
        pickVC.allowsEditing = true
        imageClass = 2
        presentViewController(pickVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 对用户选着的图片进行质量压缩,上传服务器,本地持久化存储
        if let typeStr = info[UIImagePickerControllerMediaType] as? String {
            if typeStr == "public.image" {
                
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    var data: NSData?
                    let smallImage = UIImage.imageClipToNewImage(image, newSize: CGSize.init(width: 120, height: 120))
                    if UIImagePNGRepresentation(smallImage) == nil {
                        data = UIImageJPEGRepresentation(smallImage, 0.8)
                    } else {
                        data = UIImagePNGRepresentation(smallImage)
                    }
                    
                    if data != nil {
                        
                        
                        HTTPManager.UPload(ContentType.ImageUpdate, params: ["itemNo" : self.data.itemNo,"imageClass":"\(imageClass)"], multipartFormData: { (MultipartFormData) -> Void in
                            MultipartFormData.appendBodyPart(data: data!, name: "head", fileName: "head.jpg", mimeType: "image/jpg")
                            }, encodingMemoryThreshold: { (MultipartFormDataEncodingResult) -> Void in
                                switch (MultipartFormDataEncodingResult){
                                case .Success(let upload, _, _):upload.responseJSON(completionHandler: { (response) -> Void in
                                    if response.result.isSuccess {
                                        SVProgressHUD.showSuccessWithStatus("图片上传成功", maskType: SVProgressHUDMaskType.Black)
                                    }
                                    else {
                                        SVProgressHUD.showErrorWithStatus("图片上传失败", maskType: SVProgressHUDMaskType.Black)
                                    }
                                })
                                case .Failure(let x):
                                    SVProgressHUD.showErrorWithStatus("图片上传失败", maskType: SVProgressHUDMaskType.Black)
                                }
                        })
                    }
                    else {
                        SVProgressHUD.showErrorWithStatus("图片无法获取", maskType: SVProgressHUDMaskType.Black)
                    }
                    
                    picker.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        pickVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

