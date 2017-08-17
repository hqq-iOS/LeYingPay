//
//  LYPayReq.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/9.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayConstant.h"

#pragma mark - BaseReq
/*! @brief 该类为SDK所有请求类的基类
 *
 */
@interface LYPayBaseReq : NSObject

/** 请求类型 */
@property (nonatomic, assign) int type;

@end





@interface LYPayReq : LYPayBaseReq

/**
 *  支付渠道(WX,Ali,Union)
 */
@property (nonatomic, assign) LYPayChannel channel;
/**
 /**
 *  订单描述,32个字节内,最长16个汉字。必填
 */
@property (nonatomic, copy) NSString *title;
/**
 *  支付金额,以分为单位,必须为正整数,100表示1元。必填
 */
@property (nonatomic, copy) NSString *totalFee;
/**
 *  商户系统内部的订单号,8~32位数字和/或字母组合,确保在商户系统中唯一。必填
 */
@property (nonatomic, copy) NSString *billNo;
/**
 *  商户自定义回调地址。订单支付成功，向notify_url发送异步通知。非必填。
 *  商户可通过此参数设定回调地址，此地址会覆盖用户在控制台设置的回调地址。必须以http://或https://开头
 */
@property (nonatomic, copy) NSString *notify_url;
/**
 *  订单失效时间,必须为非零正整数，单位为秒，建议不小于300。选填
 */
@property (nonatomic, assign) NSInteger billTimeOut;
/**
 *  调用支付的app注册在info.plist中的scheme,支付宝、银联支付必填
 */
@property (nonatomic, copy) NSString *scheme;

/**
 *  Apple Pay必填，0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；默认为0
 */
@property (nonatomic, assign) NSUInteger cardType;

/**
 *Apple Pay必填，.在开发中账号中注册一个merchant ID
 */
@property (nonatomic, copy) NSString *mechantID;

/**
 *  applyPay、银联支付必填
 */
@property (nonatomic, strong) UIViewController *viewController;

/**
 *  扩展参数,可以传入任意数量的key/value对来补充对业务逻辑的需求;此参数会在webhook回调中返回;
 */
@property (nonatomic, strong) NSMutableDictionary *extend;

/**
 *  发起支付(微信、支付宝、银联)
 */
- (void)sendPayReq;

@end
