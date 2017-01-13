//
//  ViewController.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/10.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "ViewController.h"
#import "SYLJQRCodeNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 300, 100, 30);
    btn.backgroundColor = [UIColor purpleColor];
    [btn addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)scan
{
    SYLJQRCodeNavigationController *scanQRNaV = [SYLJQRCodeNavigationController scannerWithCompletion:nil];
    [self presentViewController:scanQRNaV animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
