//
//  LYPayHandle.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/10.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "LYPayHandle.h"
#import "LYPay.h"

@implementation LYPayHandle


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static LYPayHandle *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[LYPayHandle alloc] init];
        
    });
    return instance;
}

- (BOOL)handleResponse {
    id<LYPayDelegate> delegate = [LYPay getDelegate];
    if (delegate && [delegate respondsToSelector:@selector(onPaydResponse:)]) {
        [delegate onPaydResponse:[LYPayHandle sharedInstance].resp];
        return YES;
    }
    return NO;
}

- (BOOL)handleErrorResponse:(NSString *)errStr {
    LYPayBaseResp *resp = self.resp;
    resp.errCode = LYErrorCodeCommon;
    resp.errStr = errStr;
   return [self handleResponse];

}


@end
