//
//  ApplyPayAdapter.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/14.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "ApplyPayAdapter.h"
#import "NSString+Tool.h"
#import <PassKit/PassKit.h>
#import "UPAPayPlugin.h"
#import "LYPayConstant.h"
#import "LYPayHandle.h"

@interface ApplyPayAdapter ()<UPAPayPluginDelegate>

@end

@implementation ApplyPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ApplyPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ApplyPayAdapter alloc] init];
    });
    return instance;
}

//判断是否支持苹果支付
- (BOOL)canMakePaymentsUsingNetworksWithMerchantCapabilities:(NSInteger)carType {
    
    BOOL status = NO;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version <= 9.2f) return status;
    switch (carType) {
        case 0:
        //判断手机是否支持Apple Pay功能，以及是否已加载有可用的支付卡片
            status = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]];
            break;
        case 1:
            //若商户的业务仅支持借记卡，应额外增加对卡片属性的判断
            status = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay] capabilities:PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityDebit];
        break;
        case 2:
            //若商户的业务仅支持贷记卡支付，应额外增加对卡片属性的判断
            status = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay] capabilities:PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit];
        break;
        default:
            status = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]];
            break;
    }
    return status;
}

- (BOOL)sendApplyPay:(NSMutableDictionary *)dic {
    
    NSString *tn = [dic objectForKey:@"tn"];
    if (![tn isNotBlank]) {
        return NO;
    }
    UIViewController *viewController = [dic objectForKey:@"viewController"];
    NSString *mechantID = [dic objectForKey:@"mechantID"];
    return [UPAPayPlugin startPay:tn mode:@"01" viewController:viewController delegate:self andAPMechantID:mechantID];
}

/**
 *  支付结果回调函数
 *
 *  @param payResult   以UPPayResult结构向商户返回支付结果
 */
-(void) UPAPayPluginResult:(UPPayResult *) payResult {
    
    int errcode = 0;
    NSString *strMsg = nil;
    if (payResult.paymentResultStatus == UPPaymentResultStatusSuccess) {
        errcode = LYErrorCodeSuccess;
        strMsg = @"支付成功";
    } else if (payResult.paymentResultStatus == UPPaymentResultStatusCancel || payResult.paymentResultStatus == UPPaymentResultStatusUnknownCancel) {
        errcode = LYErrorCodeUserCancel;
        strMsg = @"支付取消";
    }else {
        errcode = LYErrorCodeSentFail;
        strMsg = @"支付失败";
    }
    
    LYPayResp *resp = [LYPayHandle sharedInstance].resp;
    resp.errCode = errcode;
    resp.errStr = [NSString stringWithFormat:@"%@ %@",strMsg,payResult.errorDescription];
    [[LYPayHandle sharedInstance] handleResponse];
    
}
@end
