//
//  AlipayAdapter.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/11.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayUseAdapterProtocol.h"

@interface AlipayAdapter : NSObject<LYPayUseAdapterProtocol>


+ (instancetype)sharedInstance;

@end
