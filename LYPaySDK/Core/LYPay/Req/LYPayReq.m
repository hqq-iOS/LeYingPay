//
//  LYPayReq.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/9.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "LYPayReq.h"
#import "LYPayAdapter.h"
#import "NSString+Tool.h"
#import "PayEncryptionConfig.h"
#import "RSADataSigner.h"
#import "AlipayOrder.h"
#import "getIPhoneIP.h"
#import "XMLDictionary.h"
#import "LYPayResp.h"
#import "LYPayHandle.h"

//微信支付商户号
#define MCH_ID  @"1331975601"

//开户邮件中的（公众账号APPID或者应用APPID）

#define WX_AppID @"wxdefef2fa145564f2"
//安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。

#define WX_PartnerKey @"4ffa52a12ae2b790f1943dabd1716731"
//获取用户openid，可使用APPID对应的公众平台登录http://mp.weixin.qq.com 的开发者中心获取AppSecret。
#define WX_AppSecret @"app secret"

@implementation LYPayBaseReq

@end

@interface LYPayReq ()
{
    PayEncryptionConfig *config;
}
@end

@implementation LYPayReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.channel = LYPayChannelDefault;
        self.title = @"";
        self.totalFee = @"";
        self.billNo = @"";
        self.scheme = @"";
        self.viewController = nil;
        self.billTimeOut = 0;
    }
    return self;
}

/**
 *  发起支付(微信、支付宝、银联、百度钱包)
 */
- (void)sendPayReq {

    LYPayResp *resp = [[LYPayResp alloc] init];
    resp.reqest = self;
    [LYPayHandle sharedInstance].resp = resp;
    
    //检测参数是否正确
    if (![self checkParametersForReqPay]) {
        return;
    }
    
    if (self.channel == LYPayChannelWX) {
        if (![LYPayAdapter LYPayIsWeChatAppInstalled]) {
            return;
        }
        [self testWXPay];
    }else if (self.channel == LYPayChannelAli) {
        [self textAlipay];
    }else if (self.channel == LYPayChannelUnionpay) {
        [self textUnionPay];
    }else if (self.channel == LYPayChannelApplypay) {
        [self textUnionPay];
    }else if (self.channel == LYPayChannelBaidupay) {
        [self textBaiduPay];
    }else if (self.channel == LYPayChannelJDpay) {
        [self textJDPay];
    }
    
}

#pragma mark - Pay Action

- (BOOL)doPayAction:(NSDictionary *)response {
    BOOL bSendPay = NO;
    if (response) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                    (NSDictionary *)response];
        if (self.channel == LYPayChannelAli || self.channel == LYPayChannelUnionpay) {
            [dic setObject:self.scheme forKey:@"scheme"];
        }
        if (self.channel == LYPayChannelUnionpay || self.channel == LYPayChannelApplypay || self.channel == LYPayChannelBaidupay || self.channel == LYPayChannelJDpay) {
            [dic setObject:self.viewController forKey:@"viewController"];
        }
        if (self.channel == LYPayChannelApplypay) {
            [dic setObject:self.mechantID forKey:@"mechantID"];
        }
        switch (self.channel) {
            case LYPayChannelWX:
                bSendPay = [LYPayAdapter LYPayForSendWeChatPay:dic];
            break;
            case LYPayChannelAli:
                bSendPay = [LYPayAdapter LYPayForSendAliPay:dic];
            break;
            case LYPayChannelUnionpay:
                bSendPay = [LYPayAdapter LYPayForSendUnionPay:dic];
            break;
            case LYPayChannelApplypay:
                bSendPay = [LYPayAdapter LYPayForSendApplyPay:dic];
            break;
            case LYPayChannelBaidupay:
                bSendPay = [LYPayAdapter LYPayForSendBaiduPay:dic];
            break;
            case LYPayChannelJDpay:
                 bSendPay = [LYPayAdapter LYPayForSendJDPay:dic];
            break;
            default:
                break;
        }
    }
    return bSendPay;
}



- (void)testWXPay {
    NSString *nonceStr = [NSString generateTradeNO];
    config = [[PayEncryptionConfig alloc] initWithAppid:WX_AppID mch_id:MCH_ID nonce_str:nonceStr partner_id:WX_PartnerKey body:self.title out_trade_no:self.billNo total_fee:self.totalFee spbill_create_ip:[getIPhoneIP getIPAddress:YES] notify_url:self.notify_url trade_type:@"APP"];
    NSString *sign = [config getSignForMD5];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:WX_AppID forKey:@"appid"];
    [params setObject:MCH_ID forKey:@"mch_id"];
    [params setObject:self.title forKey:@"body"];
    [params setObject:nonceStr forKey:@"nonce_str"];
    [params setObject:sign forKey:@"sign"];
    [params setObject:self.billNo forKey:@"out_trade_no"];
    [params setObject:self.totalFee forKey:@"total_fee"];
    [params setObject:[getIPhoneIP getIPAddress:YES] forKey:@"spbill_create_ip"];
    [params setObject:self.notify_url forKey:@"notify_url"];
    [params setObject:@"APP" forKey:@"trade_type"];
    
    NSString *xmlString = [params XMLString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xmlString;
    }];
    //发起请求
    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder"
       parameters:xmlString
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
              // LXLog(@"responseString is %@",responseString);
              //将微信返回的xml数据解析转义成字典
              NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
              NSLog(@"++++++++++%@,%@",dic,[dic objectForKey:@"return_msg"]);
              
              
              NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithCapacity:0];
              [mdic setObject:[dic objectForKey:@"mch_id"] forKey:@"partnerId"];
              [mdic setObject:[dic objectForKey:@"appid"] forKey:@"appid"];
              [mdic setObject:[dic objectForKey:@"prepay_id"] forKey:@"prepayId"];
              [mdic setObject:[dic objectForKey:@"trade_type"] forKey:@"trade_type"];
              [mdic setObject:@"Sign=WXPay" forKey:@"package"];
              [mdic setObject:nonceStr forKey:@"nonce_str"];
              NSDate *datenow = [NSDate date];
              NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
              [mdic setObject:timeSp forKey:@"timeStamp"];
              
              NSString *sign = [config createMD5SingForPay:WX_AppID partnerid:[dic objectForKey:@"mch_id"] prepayid:[dic objectForKey:@"prepay_id"] package:@"Sign=WXPay" noncestr:nonceStr timestamp:[timeSp intValue]];
              [mdic setObject:sign forKey:@"sign"];
              [self doPayAction:mdic];
              NSLog(@"%@",mdic);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
}


- (void)textAlipay {
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2016040701272928";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCUKtgozTt9NpQfeKFn/Bj7LIxuJiIcY47Xz4PagCbC6p+SsabqEoCEwDMTnImWivenV0/kKI2XELu3hC/v4fQ0tybWxsoVlyGoDElekiZuVh6BVTSxrvoxHp2Uo+wQGBPFte4F8fHPvByz2piRcScvWI57fjnd7dQfFeMEGTMu1fxWtEcKuFkMq7hMimD/wPRjtFEjmsOa3kDtYJwARx/b4eGKlOab779Iq/nfP78aPGvtjRX+kJ0/GAJ7e4YYfem4fZ8dhCr5HjXS3LprRHNceEMGNT2g8jwGhgghWqcJzj0NuHoluPCv0gd3rT3furR/+IXbT72CApmCTt1lN7wDAgMBAAECggEATqGeLakdFQpN+ZWvMtwa9dFihWI/YAmF2QoL032HFJInNVaKWlaPVeQaNyIv8nC1lV1EzLSoz67VsEK6nfev/fnk5r6AqIyYE/LRTRsKwit57PEnEdTmegLhZezIbpIYjChMtWL9DV2rbddoeGcwgHPiya7nTtvUYtreq2IkQ4oFs5FMvF+3hG0d7+mryXjOlZVGtZ0fDAMTFrYxBylouYqmakSLGmeL42MOg22/O/EYYongeL3+tRQM9ABDQ7FmJtARoG3QxfJLPJuIpNpL6BJQz4EukeIA//S9qdVpljsFW4OESxjRDIhU7Zfi4LDyr3DHdHoxCOucuswfRAtdgQKBgQDEN0As993jKTd7lqykwWsMbNWpr7AO0rGiIuA74o/PFi2ad+LppIZMhgOonoY3wgbk7Pih7q1RgHYNa1cJS+EVy42DX1dpykTMgsktRoakpy67C2cwZl+bKoGo2v1J8UTXvA61In7GiqRhzIzuER4wj1GsdHiWPBIJ0jvGzLmtEwKBgQDBT9WcudEZQyL1kgmx21EqXk0efu3woS1c6mhLLDaQyZDUXAOXhC9fEkbomNBbMsGU30smSTGWNfiXOvjUggfWMOdU0+C52oic/fEQt8ibboz6DguhJ0Ej+wlOeU54XKlX9oh4zAPQMHlVEir+7NIEN4XpWaNiBFZy2Jw3AqRDUQKBgEr+MvD86zlfD22U8PcnVZqyHhd0pn2D2ZB2c+1vcjdb6qIXIArcbtfggJV5wSKebbQhPgXmCygTSQtn8yQCdEy4N6X2UpqETDc95VYAloVnwFyMxyugdPoBDP1UdWpFZGJv5c8lF/8aDimy3EpBEKDOphCbk1sYKmzGhUI+DNkxAoGAX9lk0iv0OLFoMRjzA6P6D6boWBmZgvl3051KjxNiDtJSpGjnQwZAssQOMqAqlz2IbHd2/InIM3GZS+rqm/vJRPPEj/Pqdlyb5jOnhqGJrz/WWNoD/CjJjLyZNbbCKL3RHZNYwYRu05hlYL/8X6Au1fZtyHEwqJX8Az/R3RjLN7ECgYEAormcccmzhZVc/jR/VrvQ0GrEJZ7Aqn3m/Q8vhIpbGsIfeBjvXheSVTh99f9t7J+HFRQHadK56TIhnQfAs/kNbR23VBymG8WcFoJ7YBPEpo8f3/sBYgjCuM/hkFCOIXLBj+KOHgGPVUw6p1pEGRvTPmDh/E+g/6yyXotlsUSy0uM=";
    NSString *rsaPrivateKey = @"";
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AlipayOrder *order = [AlipayOrder new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.subject = self.title;
    order.biz_content.body = @"dddddddd";
    order.biz_content.out_trade_no = self.billNo; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = [NSString stringWithFormat:@"%zdm",self.billTimeOut/60]; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [self.totalFee integerValue]/100.0]; //商品价格
    order.biz_content.product_code = @"QUICK_MSECURITY_PAY";
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = self.scheme;
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        NSLog(@"%@ %@",orderString,appScheme);
        [LYPayAdapter LYPayForSendAliPayWithOrderString:orderString FromScheme:appScheme];
    }

}

- (void)textUnionPay {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    //发起请求
    [manager GET:@"http://101.231.204.84:8091/sim/getacptn"
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSString* tn = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

              NSDictionary *dic = [NSDictionary dictionaryWithObject:tn forKey:@"tn"];
              [self doPayAction:dic];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];

}

- (void)textBaiduPay {
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    // 支付金额
    [order setValue:self.totalFee forKey:@"total_amount"];
    [order setValue:self.title forKey:@"goods_name"];
    
    [order setValue:self.notify_url forKey:@"return_url"];
    [order setValue:@"2" forKey:@"pay_type"];
    [order setValue:@"" forKey:@"unit_amount"];
    [order setValue:@"" forKey:@"unit_count"];
    [order setValue:@"" forKey:@"transport_amount"];
    
    [order setValue:@"" forKey:@"page_url"];
    [order setValue:@"" forKey:@"buyer_sp_username"];
    [order setValue:@"" forKey:@"extra"];
    [order setValue:@"" forKey:@"goods_desc"];
    [order setValue:@"" forKey:@"goods_url"];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    //发起请求
    [manager POST:@"http://bdwallet.duapp.com/createorder/pay_wap.php"
      parameters:order
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString  *orderInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             
             NSDictionary *dic = [NSDictionary dictionaryWithObject:orderInfo forKey:@"orderInfo"];
             [self doPayAction:dic];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];

}

- (void)textJDPay {
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    [order setObject:@"1000148966268255555059" forKey:@"orderId"];
    [order setObject:@"bb05ce87d5f4c9063eb007e2301c7a83" forKey:@"signData"];
    [self doPayAction:order];
}

- (BOOL)checkParametersForReqPay {
    if (![self.title isNotBlank] || [self.title getBytes] > 32) {
        [[LYPayHandle sharedInstance] handleErrorResponse:@"title 必须是长度不大于32个字节,最长16个汉字的字符串的合法字符串"];
        return NO;
    } else if (![self.totalFee isNotBlank] || ![self.totalFee isPureInt]) {
        [[LYPayHandle sharedInstance] handleErrorResponse:@"totalFee 以分为单位，必须是只包含数值的字符串"];
        return NO;
    } else if (![self.billNo isNotBlank]) {
        [[LYPayHandle sharedInstance] handleErrorResponse:@"billNo 订单号不合法"];
        return NO;
    } else if ((self.channel == LYPayChannelUnionpay || self.channel == LYPayChannelAli) && ![self.scheme isNotBlank]) {
        [[LYPayHandle sharedInstance] handleErrorResponse:@"scheme 不是合法的字符串，将导致无法返回应用"];
        return NO;
    } else if ((self.channel == LYPayChannelUnionpay || self.channel == LYPayChannelApplypay) && (self.viewController == nil)) {
        [[LYPayHandle sharedInstance] handleErrorResponse:@"viewController 不合法，将导致无法正常支付"];
        return NO;
    } else if (((self.channel == LYPayChannelWX) && ![LYPayAdapter LYPayIsWeChatAppInstalled])) {
        [[LYPayHandle sharedInstance] handleErrorResponse:@"未找到微信客户端，请先下载安装"];
        return NO;
    } else if (self.channel == LYPayChannelApplypay && ![LYPayAdapter LYPayForApplyPayCanMakePaymentsUsingNetworksWithMerchantCapabilities:self.cardType]) {
        switch (self.cardType) {
            case 0:
                [[LYPayHandle sharedInstance] handleErrorResponse:@"此设备不支持Apple Pay"];
                break;
            case 1:
                [[LYPayHandle sharedInstance] handleErrorResponse:@"不支持借记卡"];
                break;
            case 2:
                [[LYPayHandle sharedInstance] handleErrorResponse:@"不支持信用卡"];
                break;
        }
        return NO;
    }
    return YES;
}


@end
