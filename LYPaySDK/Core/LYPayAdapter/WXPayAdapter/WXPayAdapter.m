//
//  WXPayAdapter.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/7.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "WXPayAdapter.h"
#import "WXApi.h"
#import "WXPayAdapter.h"
#import "LYPayConstant.h"
#import "LYPayResp.h"
#import "NSString+Tool.h"
#import "LYPayHandle.h"

@interface WXPayAdapter ()<WXApiDelegate>

@end

@implementation WXPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WXPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[WXPayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)registerWeChat:(NSString *)appid {
    return [WXApi registerApp:appid];
}


- (BOOL)handleOpenUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[WXPayAdapter sharedInstance]];
}

/*! @brief 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
- (BOOL)isWeChatClientInstalled {
   return  [WXApi isWXAppInstalled];
}


/*! @brief 判断当前微信的版本是否支持OpenApi
 *
 * @return 支持返回YES，不支持返回NO。
 */
- (BOOL)isWeChatAppSupportApi {
    return [WXApi isWXAppSupportApi];
}

#pragma mark ---  支付
- (BOOL)sendWeChatPay:(NSMutableDictionary *)dic {
    PayReq *request = [[PayReq alloc] init];
    request.openID = [dic objectForKey:@"appid"];
    request.partnerId = [dic objectForKey:@"partnerId"];
    request.prepayId = [dic objectForKey:@"prepayId"];
    request.package = [dic objectForKey:@"package"];
    request.nonceStr = [dic objectForKey:@"nonce_str"];
    NSString *time = [dic objectForKey:@"timeStamp"];
    request.timeStamp = time.intValue;
    request.sign = [dic objectForKey:@"sign"];
    return [WXApi sendReq:request];
}


#pragma mark - 微信支付 WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *tempResp = (PayResp *)resp;
        NSString *strMsg = nil;
        LYErrorCode errcode = 0;
        switch (tempResp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                errcode = LYErrorCodeSuccess;
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付取消";
                errcode = LYErrorCodeUserCancel;
                break;
            default:
                strMsg = @"支付失败";
                errcode = LYErrorCodeSentFail;
                break;
        }
        NSString *result = [tempResp.errStr isNotBlank] ? [NSString stringWithFormat:@"%@,%@",strMsg,tempResp.errStr]:strMsg;
        LYPayBaseResp *resp = [LYPayHandle sharedInstance].resp;
        resp.errCode = errcode;
        resp.errStr = result;
        [[LYPayHandle sharedInstance] handleResponse];
    }
}

@end
