//
//  LYPay.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "LYPay.h"
#import "NSString+Tool.h"
#import "LYPayAdapter.h"
#import "LYPayTools.h"

@interface LYPay ()

@property (nonatomic, weak) id<LYPayDelegate> delegate;

@end
@implementation LYPay

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LYPay *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[LYPay alloc] init];
    });
    return instance;
}


+ (BOOL)initWithWeChatAppId:(NSString *)appId {
    if (![appId isNotBlank]) {
        return NO;
    }
    
    return [LYPayAdapter LYPayForRegisterWeChat:appId];
}

+ (BOOL)initWithJDServiceWithAppID:(NSString *)appID  andMerchantID:(NSString *)merchantID {
    if (![appID isNotBlank]) {
        return NO;
    }
    if (![merchantID isNotBlank]) {
        return NO;
    }
    return [LYPayAdapter LYPayForRegistJDServiceWithAppID:appID andMerchantID:merchantID];
}

+ (BOOL)isWeChatClientInstalled {
    return [LYPayAdapter LYPayIsWeChatAppInstalled];
}

+ (BOOL)handleOpenUrl:(NSURL *)url {
   LYPayChannel type = [LYPayTools getHandleUrlType:url];
    if (type == LYPayChannelWX) {
       return  [LYPayAdapter LYPayWithObject:kAdapterWXPay handleOpenUrl:url];
    }else if (type == LYPayChannelAli) {
        [LYPayAdapter LYPayWithObject:kAlipayAdapter handleOpenUrl:url];
    }else if (type == LYPayChannelUnionpay) {
        [LYPayAdapter LYPayWithObject:kUnionPayAdapter handleOpenUrl:url];
    }
    return NO;
}

+ (void)setLYPayDelegate:(id<LYPayDelegate>)delegate {
    [LYPay sharedInstance].delegate = delegate;
}


+ (id<LYPayDelegate>)getDelegate {
    return [LYPay sharedInstance].delegate;
}

+ (NSString *)getApiVersion {
    return kApiVersion;
}
+ (void)setPrintLog:(BOOL)flag {
    
}

/**
 *发起支付
 *
 *  @param req 请求体
 *
 *  @return 发送请求是否成功
 */
+ (BOOL)sendPayReq:(LYPayBaseReq *)req {
    [LYPay sharedInstance];
    LYPayReq *payReq = (LYPayReq *)req;
    [payReq sendPayReq];
    return YES;
    
}
@end
