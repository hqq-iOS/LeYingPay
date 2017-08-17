//
//  LYPayTools.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "LYPayTools.h"

@implementation LYPayTools

+ (LYPayChannel)getHandleUrlType:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"])
        return LYPayChannelAli;
    else if ([url.scheme hasPrefix:@"wx"] && [url.host isEqualToString:@"pay"])
        return LYPayChannelWX;
    else if ([url.host isEqualToString:@"uppayresult"]) {
        return  LYPayChannelUnionpay;
    }
    return LYPayChannelDefault;
}

@end
