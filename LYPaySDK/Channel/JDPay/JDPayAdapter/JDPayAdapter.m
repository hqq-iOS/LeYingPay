//
//  JDPayAdapter.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/15.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "JDPayAdapter.h"
#import "JDPAuthObject.h"
#import "JDPAuthSDK.h"
#import "NSString+Tool.h"
#import "LYPayConstant.h"
#import "LYPayResp.h"
#import "LYPayHandle.h"

@implementation JDPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JDPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[JDPayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)handleOpenUrl:(NSURL *)url {
   return [[JDPAuthSDK sharedJDPay] handleOpenURL:url];
}


- (BOOL)registJDServiceWithAppID:(NSString *)appID  andMerchantID:(NSString *)merchantID {
    [[JDPAuthSDK sharedJDPay] registServiceWithAppID:appID merchantID:merchantID];
    return YES;
}

- (BOOL)sendJDPay:(NSMutableDictionary *)dic {
    
    UIViewController *viewController = [dic objectForKey:@"viewController"];
    NSString *orderId = [dic objectForKey:@"orderId"];
    if (![orderId isNotBlank]) {
        return NO;
    }
    NSString *signData = [dic objectForKey:@"signData"];
    if (![signData isNotBlank]) {
        return NO;
    }
    [[JDPAuthSDK sharedJDPay] payWithViewController:viewController orderId:orderId signData:signData completion:^(NSDictionary *resultDict) {
        [self onJDResponse:resultDict];
    }];
    return YES;
}

- (void)onJDResponse:(NSDictionary *)resultDic {
    NSString *status = resultDic[@"payStatus"];
    NSString *strMsg;
    int errcode = 0;
    if ([status isEqualToString:@"JDP_PAY_SUCCESS"]) {
        errcode = LYErrorCodeSuccess;
        strMsg = @"支付成功";
    }else if ([status isEqualToString:@"JDP_PAY_CANCEL"]) {
        strMsg = @"支付取消";
        errcode = LYErrorCodeUserCancel;
    }else if ([status isEqualToString:@"JDP_PAY_NONE"]) {
        strMsg = @"未知错误";
        errcode = LYErrorCodeUnsupport;
    }else {
        strMsg = @"支付失败";
        errcode = LYErrorCodeSentFail;
    }
    
    NSString *jdErrorCode = resultDic[@"errorCode"];
    
    LYPayResp *resp = [LYPayHandle sharedInstance].resp;
    resp.errCode = errcode;
    resp.errStr = [NSString stringWithFormat:@"%@ 京东错误码：%@",strMsg,jdErrorCode];
    resp.resultDic = resultDic;
    [[LYPayHandle sharedInstance] handleResponse];
}

@end
