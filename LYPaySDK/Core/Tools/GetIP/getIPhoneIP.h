//
//  getIPhoneIP.h
//  Ceremonies
//
//  Created by 尹俊雄 on 15/7/1.
//  Copyright (c) 2015年 张启冲. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface getIPhoneIP : NSObject
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
