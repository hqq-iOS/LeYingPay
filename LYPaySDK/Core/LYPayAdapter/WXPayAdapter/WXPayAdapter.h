//
//  WXPayAdapter.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/7.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayUseAdapterProtocol.h"

@interface WXPayAdapter : NSObject<LYPayUseAdapterProtocol>

+ (instancetype)sharedInstance;

@end
