//
//  LYPayHandle.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/10.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayResp.h"

@interface LYPayHandle : NSObject

@property (nonatomic, strong) LYPayResp *resp;

+ (instancetype)sharedInstance;

- (BOOL)handleResponse;

- (BOOL)handleErrorResponse:(NSString *)errStr;

@end
