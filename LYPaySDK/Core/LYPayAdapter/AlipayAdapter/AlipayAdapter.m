//
//  AlipayAdapter.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/11.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "AlipayAdapter.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+Tool.h"
#import "LYPayConstant.h"
#import "LYPayResp.h"
#import "LYPayHandle.h"

@implementation AlipayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AlipayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[AlipayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)handleOpenUrl:(NSURL *)url {
    //处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
    [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        [self onAliPayResponse:resultDic];
    }];
    return YES;
}

- (BOOL)sendAlipay:(NSMutableDictionary *)dic {
    NSString *orderStr = [dic objectForKey:@"order_string"];
    if (![orderStr isNotBlank]) {
        orderStr = @"";
    }
    NSString *schemeStr = [dic objectForKey:@"scheme"];
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:schemeStr callback:^(NSDictionary *resultDic) {
        [self onAliPayResponse:resultDic];
    }];
    return YES;
}

- (BOOL)sendAlipayWithOrderString:(NSString *)orderString formscheme:(NSString *)schemeStr {
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:schemeStr callback:^(NSDictionary *resultDic) {
         [self onAliPayResponse:resultDic];
    }];
    return YES;
}

- (void)onAliPayResponse:(NSDictionary *)resultDic {
    int status = [resultDic[@"resultStatus"] intValue];
    
    NSString *strMsg;
    int errcode = 0;
    switch (status) {
        case 9000:
            strMsg = @"支付成功";
            errcode = LYErrorCodeSuccess;
            break;
        case 4000:
        case 6002:
            strMsg = @"支付失败";
            errcode = LYErrorCodeSentFail;
            break;
        case 6001:
            strMsg = @"支付取消";
            errcode = LYErrorCodeUserCancel;
            break;
            case 8000:
            case 6004:
            strMsg = @"支付结果未知，请刷新订单";
            errcode = LYErrorCodeUnknown;
            break;
            case 5000:
            strMsg = @"重复请求";
            errcode = LYErrorCodeRepeat;
            break;
        default:
            strMsg = @"未知错误";
            errcode = LYErrorCodeUnsupport;
            break;
    }
    LYPayResp *resp = [LYPayHandle sharedInstance].resp;
    resp.errCode = errcode;
    resp.errStr = strMsg;
    resp.resultDic = resultDic;
    [[LYPayHandle sharedInstance] handleResponse];
}


@end
