//
//  SYLJScanQRCodeViewController.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/10.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJScanQRCodeViewController.h"

@interface SYLJScanQRCodeViewController ()

@end

@implementation SYLJScanQRCodeViewController

#pragma mark -
#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationController];
}

- (void)setupNavigationController
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
}

- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
