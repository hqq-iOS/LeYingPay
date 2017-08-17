//
//  NSString+Tool.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)

//判断是否为空字符串
- (BOOL)isNotBlank;

//获取UUID
+ (NSString *)stringWithUUID;

//去除收尾空格
- (NSString *)stringByTrim;

+ (NSString *)generateTradeNO;

- (NSUInteger)getBytes;

- (BOOL)isPureInt;

@end
