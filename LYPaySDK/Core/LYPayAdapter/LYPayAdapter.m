//
//  LYPayAdapter.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "LYPayAdapter.h"
#import "LYPayConstant.h"

@implementation LYPayAdapter

#pragma mark --- 微信相关
//微信注册
+ (BOOL)LYPayForRegisterWeChat:(NSString *)appid {
    id adpter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(registerWeChat:)]) {
      return  [adpter registerWeChat:appid];
    }
    return NO;
}

//是否安装微信
+ (BOOL)LYPayIsWeChatAppInstalled {
    id adpter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(isWeChatClientInstalled)]) {
      return   [adpter isWeChatClientInstalled];
    }
    return NO;
}

//是否支持打开API
+ (BOOL)LYPayIsWeChatAppSupportApi {
    id adpter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(isWeChatAppSupportApi)]) {
        return   [adpter isWeChatAppSupportApi];
    }
    return NO;
}

//发起微信支付
+ (BOOL)LYPayForSendWeChatPay:(NSMutableDictionary *)params {
    id adpter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(sendWeChatPay:)]) {
       return [adpter sendWeChatPay:params];
    }
    return NO;
}

//发起支付宝支付
+ (BOOL)LYPayForSendAliPay:(NSMutableDictionary *)params {
    id adpter = [[NSClassFromString(kAlipayAdapter) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(sendAlipay:)]) {
      return  [adpter sendAlipay:params];
    }
    return NO;
}

+ (BOOL)LYPayForSendAliPayWithOrderString:(NSString *)orderString FromScheme:(NSString *)scheme {
    id adpter = [[NSClassFromString(kAlipayAdapter) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(sendAlipayWithOrderString:formscheme:)]) {
       return [adpter sendAlipayWithOrderString:orderString formscheme:scheme];
    }
    return NO;
}


//发起银联支付
+ (BOOL)LYPayForSendUnionPay:(NSMutableDictionary *)params {
    id adpter = [[NSClassFromString(kUnionPayAdapter) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(sendUnionPay:)]) {
        return [adpter sendUnionPay:params];
    }
    return NO;
}


//apply pay
+ (BOOL)LYPayForSendApplyPay:(NSMutableDictionary *)params {
    id adpter = [[NSClassFromString(kApplyPayAdapter) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(sendApplyPay:)]) {
        return [adpter sendApplyPay:params];
    }
    return NO;
}

//判断是否支持苹果支付
+ (BOOL)LYPayForApplyPayCanMakePaymentsUsingNetworksWithMerchantCapabilities:(NSInteger)carType {
    id adpter = [[NSClassFromString(kApplyPayAdapter) alloc] init];
    if (adpter && [adpter respondsToSelector:@selector(canMakePaymentsUsingNetworksWithMerchantCapabilities:)]) {
        return [adpter canMakePaymentsUsingNetworksWithMerchantCapabilities:carType];
    }
    return NO;
}


+ (BOOL)LYPayForSendBaiduPay:(NSMutableDictionary *)params {
    id adapter = [[NSClassFromString(kBaiduPayAdapter) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(sendBaiduPay:)]) {
       return  [adapter sendBaiduPay:params];
    }
    return NO;
}


+ (BOOL)LYPayForRegistJDServiceWithAppID:(NSString *)appID  andMerchantID:(NSString *)merchantID {
    id adapter = [[NSClassFromString(kJDPayAdapter) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(registJDServiceWithAppID:andMerchantID:)]) {
        return  [adapter registJDServiceWithAppID:appID andMerchantID:merchantID];
    }
    return NO;
}

+ (BOOL)LYPayForSendJDPay:(NSMutableDictionary *)params {
    id adapter = [[NSClassFromString(kJDPayAdapter) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(sendJDPay:)]) {
        return  [adapter sendJDPay:params];
    }
    return NO;
}

#pragma mark --- common
+ (BOOL)LYPayWithObject:(NSString *)object handleOpenUrl:(NSURL *)url {
    id adapter = [[NSClassFromString(object) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(handleOpenUrl:)]) {
        return [adapter handleOpenUrl:url];
    }
    return NO;
}
@end
