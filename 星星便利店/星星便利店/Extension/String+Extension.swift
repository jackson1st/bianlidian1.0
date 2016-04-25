//
//  String+Extension.swift
//  星星便利店
//
//  Created by 黄人煌 on 16/3/19.
//  Copyright © 2016年 黄人煌. All rights reserved.
//

import Foundation


extension String {
    
    /// 清除字符串小数点末尾的0
    func cleanDecimalPointZear() -> String {
        
        let newStr = self as NSString
        var s = NSString()
        
        var offset = newStr.length - 1
        while offset > 0 {
            s = newStr.substringWithRange(NSMakeRange(offset, 1))
            if s.isEqualToString("0") || s.isEqualToString(".") {
                offset--
            } else {
                break
            }
        }
        
        return newStr.substringToIndex(offset + 1)
    }
    
    //  判断会有几行
    func judgeLineNumber(label:UILabel,labelText:String) -> Bool{
        
        if (labelText as! NSString).sizeWithAttributes([NSFontAttributeName:label.font]).width / label.width > 1 {
            return true
        }
        return false
        
    }
}

extension Double {
    
    /// Double 保留两位小数然后返回String
    func roundedToTwoDecimals() -> String {
        
        let oldNum = self as Double
        
        let newStr = String(format: "%.2lf", oldNum)
        
        return newStr
    }
    
}
