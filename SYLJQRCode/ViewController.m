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

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) UIImageView *avatarImg;

@end

@implementation ViewController
- (IBAction)scan:(UIBarButtonItem *)sender
{
    SYLJQRCodeNavigationController *scanQRNaV = [SYLJQRCodeNavigationController scannerWithCardName:@"何亮" avatar:[UIImage imageNamed:@"psb"] completion:^(NSString *stringValue) {
        NSLog(@"扫描结果: %@", stringValue);
        self.tipLabel.text = stringValue;
    }];
    
    [self showDetailViewController:scanQRNaV sender:nil];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
