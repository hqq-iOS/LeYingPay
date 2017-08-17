//
//  UnionPayAdapter.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/14.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "UnionPayAdapter.h"
#import "UPPaymentControl.h"
#import "LYPayConstant.h"
#import "LYPayResp.h"
#import "LYPayHandle.h"
#import "NSString+Tool.h"

@implementation UnionPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static UnionPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[UnionPayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)isPaymentAppInstalled {
    return [[UPPaymentControl defaultControl] isPaymentAppInstalled];
}

- (BOOL)handleOpenUrl:(NSURL *)url {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        [[UnionPayAdapter sharedInstance] onResponse:code];
    }];
    return YES;
}

- (BOOL)sendUnionPay:(NSMutableDictionary *)dic {
    
    NSString *tn = [dic objectForKey:@"tn"];
    if (![tn isNotBlank]) {
        return NO;
    }
    NSString *scheme = [dic objectForKey:@"scheme"];
    UIViewController *viewController = [dic objectForKey:@"viewController"];
    return  [[UPPaymentControl defaultControl] startPay:tn fromScheme:scheme mode:@"01" viewController:viewController];
}

- (void)onResponse:(NSString *)result {
    int errcode = 0;
    NSString *strMsg = nil;
    if ([result isEqualToString:@"success"]) {
        errcode = LYErrorCodeSuccess;
        strMsg = @"支付成功";
    } else if ([result isEqualToString:@"cancel"]) {
        errcode = LYErrorCodeUserCancel;
        strMsg = @"支付取消";
    }else {
        errcode = LYErrorCodeSentFail;
        strMsg = @"支付失败";
    }
    
    LYPayBaseResp *resp = [LYPayHandle sharedInstance].resp;
    resp.errCode = errcode;
    resp.errStr = strMsg;
    [[LYPayHandle sharedInstance] handleResponse];
}

@end
