//
//  LYPayTools.h
//  LeYingPay
//
//  Created by heqinqin on 2017/8/8.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPayConstant.h"

@interface LYPayTools : NSObject

+ (LYPayChannel)getHandleUrlType:(NSURL *)url;

@end
