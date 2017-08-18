//
//  LYPay.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayReq.h"
#import "LYPayDelegate.h"

@interface LYPay : NSObject

/*! @brief WXApi的成员函数，向微信终端程序注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现，默认开启MTA数据上报。
 * iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。
 * @attention 请保证在主线程中调用此函数
 * @param appId 微信开发者ID
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)initWithWeChatAppId:(NSString *)appId;


/**
 *  京东支付注册 服务
 *
 *  @param appID       注册的appID
 *  @param merchantID   注册的商户号
 *
 */

+ (BOOL)initWithJDServiceWithAppID:(NSString *)appID  andMerchantID:(NSString *)merchantID;


/*! @brief 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
+ (BOOL)isWeChatClientInstalled;

/**
 * 处理通过URL启动App时传递的数据。需要在application:openURL:sourceApplication:annotation:中调用。
 *
 * @param url 启动第三方应用时传递过来的URL
 *
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenUrl:(NSURL *)url;

/**
 * 设置代理，接收回调消息
 *
 */
+ (void)setLYPayDelegate:(id<LYPayDelegate>)delegate;


//获取代理
+ (id<LYPayDelegate>)getDelegate;

/**
 *  获取API版本号
 *
 *  @return 版本号
 */
+ (NSString *)getApiVersion;

/**
 *  设置是否打印log
 *
 *  @param flag YES打印
 */
+ (void)setPrintLog:(BOOL)flag;

#pragma mark - Send BeeCloud Request

/**
 *发起支付
 *
 *  @param req 请求体
 *
 *  @return 发送请求是否成功
 */
+ (BOOL)sendPayReq:(LYPayBaseReq *)req;

@end
