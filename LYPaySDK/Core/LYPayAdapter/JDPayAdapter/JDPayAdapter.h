//
//  JDPayAdapter.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/15.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayUseAdapterProtocol.h"

@interface JDPayAdapter : NSObject<LYPayUseAdapterProtocol>

+ (instancetype)sharedInstance;

@end
