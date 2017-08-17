//
//  LYPayAdapter.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayUseAdapterProtocol.h"

@interface LYPayAdapter : NSObject

#pragma mark --- 微信相关
//微信注册
+ (BOOL)LYPayForRegisterWeChat:(NSString *)appid;

//是否安装微信
+ (BOOL)LYPayIsWeChatAppInstalled;

//发起微信支付
+ (BOOL)LYPayForSendWeChatPay:(NSMutableDictionary *)params;

//是否支持打开API
+ (BOOL)LYPayIsWeChatAppSupportAp;

#pragma  mark -- 支付宝alipay
//发起支付宝支付
+ (BOOL)LYPayForSendAliPay:(NSMutableDictionary *)params;

+ (BOOL)LYPayForSendAliPayWithOrderString:(NSString *)orderString FromScheme:(NSString *)scheme;


#pragma mark --- 银联
+ (BOOL)LYPayForSendUnionPay:(NSMutableDictionary *)params;

#pragma mark ----apply pay
+ (BOOL)LYPayForSendApplyPay:(NSMutableDictionary *)params;

//判断是否支持苹果支付
+ (BOOL)LYPayForApplyPayCanMakePaymentsUsingNetworksWithMerchantCapabilities:(NSInteger)carType;


#pragma mark --- 百度钱包支付
+ (BOOL)LYPayForSendBaiduPay:(NSMutableDictionary *)params;

#pragma makr -- 京东支付
+ (BOOL)LYPayForRegistJDServiceWithAppID:(NSString *)appID  andMerchantID:(NSString *)merchantID;

+ (BOOL)LYPayForSendJDPay:(NSMutableDictionary *)params;

#pragma mark --- common
//handleURL 
+ (BOOL)LYPayWithObject:(NSString *)object handleOpenUrl:(NSURL *)url;

@end
