//
//  LYPayUseAdapterProtocol.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LYPayUseAdapterProtocol <NSObject>

@optional
#pragma mark --- 微信 协议
//WXApi的成员函数，向微信终端程序注册第三方应用。
- (BOOL)registerWeChat:(NSString *)appid;

//检查微信是否已被用户安装
- (BOOL)isWeChatClientInstalled;

//判断当前微信的版本是否支持OpenApi
- (BOOL)isWeChatAppSupportApi;

//吊起微信支付
- (BOOL)sendWeChatPay:(NSMutableDictionary *)dic;


#pragma mark -- alipay
//发起支付宝支付
- (BOOL)sendAlipay:(NSMutableDictionary *)dic;


//通过orderString 发起支付宝支付
- (BOOL)sendAlipayWithOrderString:(NSString *)orderString formscheme:(NSString *)schemeStr;


#pragma mark -- 银联
//吊起银联支付
- (BOOL)sendUnionPay:(NSMutableDictionary *)dic;

//是否安装银联APP
- (BOOL)isPaymentAppInstalled;

#pragma mark --- apply pay
//判断是否支持苹果支付
- (BOOL)canMakePaymentsUsingNetworksWithMerchantCapabilities:(NSInteger)carType;

- (BOOL)sendApplyPay:(NSMutableDictionary *)dic;


#pragma mark --- 百度钱包支付
//吊起百度钱包支付
- (BOOL)sendBaiduPay:(NSMutableDictionary *)dic;

#pragma mark -- 京东支付
- (BOOL)registJDServiceWithAppID:(NSString *)appID  andMerchantID:(NSString *)merchantID;

- (BOOL)sendJDPay:(NSMutableDictionary *)dic;

#pragma mark -- publish
//处理支付通过URL启动App时传递的数据
- (BOOL)handleOpenUrl:(NSURL *)url;


@end
