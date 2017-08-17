//
//  LYPayDelegate.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/10.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayResp.h"

@protocol LYPayDelegate <NSObject>

/**
 *  不同类型的请求，对应不同的响应
 *
 *  @param resp 响应体
 */
- (void)onPaydResponse:(LYPayBaseResp *)resp;

@end
