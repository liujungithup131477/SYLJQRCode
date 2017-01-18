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

@property (nonatomic, weak) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"扫一扫" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.frame = CGRectMake(0, 0, 300, 300);
//    btn.center = self.view.center;
//    btn.backgroundColor = [UIColor purpleColor];
//    [btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    label.text = @"扫一扫";
    label.backgroundColor = [UIColor purpleColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scan:)];
    [label addGestureRecognizer:tap];
    label.center = self.view.center;
    [self.view addSubview:label];
    self.label = label;
}

- (void)scan:(UITapGestureRecognizer *)sender
{
    SYLJQRCodeNavigationController *scanQRNaV = [SYLJQRCodeNavigationController scannerWithCompletion:^(NSString * _Nonnull stringValue) {
        NSLog(@"扫描结果: %@", stringValue);
        self.label.text = stringValue;
    }];
    
    [self showDetailViewController:scanQRNaV sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
