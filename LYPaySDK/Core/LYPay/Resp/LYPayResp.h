//
//  LYPayResp.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/9.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayReq.h"


#pragma mark - BaseResp
/*! @brief 该类为微信终端SDK所有响应类的基类
 *
 */
@interface LYPayBaseResp : NSObject
/** 错误码 */
@property (nonatomic, assign) int errCode;
/** 错误提示字符串 */
@property (nonatomic, retain) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) int type;

//当前请求体
@property (nonatomic, strong) LYPayBaseReq *reqest;

@end

@interface LYPayResp : LYPayBaseResp

//支付宝携带回调结果
@property (nonatomic, strong) NSDictionary *resultDic;



@end
