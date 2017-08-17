//
//  ViewController.m
//  LeYingPay
//
//  Created by heqinqin on 2017/8/7.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "ViewController.h"
#import "LYPay.h"
#import "NSString+Tool.h"

@interface ViewController ()<LYPayDelegate,UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic) NSArray *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[@"微信支付",@"支付宝",@"银联支付",@"苹果支付",@"百度钱包",@"京东支付"];
    
    [LYPay setLYPayDelegate:self];
    
   
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [UIView new];

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LYPayReq *req = [[LYPayReq alloc] init];
    req.billNo = [NSString generateTradeNO];
    req.totalFee = @"1";
    req.title = @"iphone6 plus购买活动";
    req.notify_url = @"http://db-testing-eb07.db01.baidu.com:8666/success.html";
    req.billTimeOut = 300;
    if (indexPath.row == 0) {
        req.channel = LYPayChannelWX;
    }else if (indexPath.row == 1) {
        req.channel = LYPayChannelAli;
        req.scheme = @"LeYingPayment";
    }else if (indexPath.row == 2) {
        req.channel = LYPayChannelUnionpay;
        req.scheme = @"LeYingPayment";
        req.viewController = self;
    }else if (indexPath.row == 3) {
        req.channel = LYPayChannelApplypay;
        req.viewController = self;
        req.cardType = 0;
        req.mechantID = @"merchant.LeYingPay";
    }else if (indexPath.row == 4) {
        req.channel = LYPayChannelBaidupay;
        req.scheme = @"LeYingPayment";
        req.viewController = self;

    }else if (indexPath.row == 5) {
        req.channel = LYPayChannelJDpay;
        req.viewController = self;
    }
    [req sendPayReq];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onPaydResponse:(LYPayBaseResp *)resp {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:resp.errStr preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDescs {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
