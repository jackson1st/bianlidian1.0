//
//  String+Hash.swift
//  Demo
//
//  Created by 黄人煌 on 16/2/7.
//  Copyright © 2015年 Fjnu. All rights reserved.
//
//  加密措施

/// 注意：要使用本分类，需要在 bridge.h 中添加以下头文件导入
/// #import <CommonCrypto/CommonCrypto.h>
import Foundation

extension String  {
    /// 返回字符串的 MD5 散列结果
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return hash.copy() as! String
    }
}
