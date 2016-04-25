//
//  DES3Util.h
//  星星便利店
//
//  Created by 黄人煌 on 16/4/22.
//  Copyright © 2016年 黄人煌. All rights reserved.
//
//
//  DES3Util.h
//
#import <Foundation/Foundation.h>
@interface DES3Util : NSObject {
}
// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;
// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;
@end
