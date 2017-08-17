//
//  LYPayConstant.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef LYPayConstant_h
#define LYPayConstant_h


static NSString * const kApiVersion = @"1.0.0";//api版本号


//Adapter
//微信适配器实体
static NSString * const kAdapterWXPay = @"WXPayAdapter";

//支付宝适配器实体
static NSString * const kAlipayAdapter = @"AlipayAdapter";

//银联适配器实体
static NSString * const kUnionPayAdapter = @"UnionPayAdapter";

//苹果适配器实体
static NSString * const kApplyPayAdapter = @"ApplyPayAdapter";

//百度适配器实体
static NSString * const kBaiduPayAdapter = @"BaiduPayAdapter";

//京东适配器实体
static NSString * const kJDPayAdapter = @"JDPayAdapter";





/*****************************************错误码定义*****************************************************/
/*****************************************错误码定义*****************************************************/

typedef NS_ENUM(NSInteger, LYErrorCode) {
    LYErrorCodeSuccess    = 0,    /**< 成功    */
    LYErrorCodeSentFail   = 1000,   /**< 发送失败    */
    LYErrorCodeUserCancel = 2000,   /**< 用户点击取消并返回    */
    LYErrorCodeCommon     = 3000,   /**< 参数错误类型    */
    LYErrorCodeUnsupport  = 4000,   /**< 未知错误类型 */
    LYErrorCodeUnknown    = 5000,   /**< 支付结果未知，可能支付成功，需要刷新结果 */
    LYErrorCodeRepeat     = 6000,     /**< 重复下单 */
    LYErrorCodeProgress   = 7000,     /**< 支付中 */


};

//支付渠道
typedef NS_ENUM(NSInteger, LYPayChannel) {
    
    LYPayChannelDefault = 0,
    LYPayChannelWX      = 10, //微信
    LYPayChannelAli     = 20,//支付宝
    LYPayChannelUnionpay= 30,//银联
    LYPayChannelApplypay= 40, //苹果支付
    LYPayChannelBaidupay= 50,  //百度支付
    LYPayChannelJDpay   = 60,  //京东支付
    
};

#endif /* LYPayConstant_h */
