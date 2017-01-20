//
//  SYLJGenerateQRCodeViewController.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/20.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJGenerateQRCodeViewController.h"
#import "SYLJGenerateQRCode.h"

@interface SYLJGenerateQRCodeViewController ()

@property (nonatomic, copy) NSString *cardName;
@property (nonatomic, strong) UIImage *avatar;

@end

@implementation SYLJGenerateQRCodeViewController

- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar
{
    self = [super init];
    if (self != nil) {
        self.cardName = cardName;
        self.avatar = avatar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self prepareUI];
}

- (void)prepareUI
{
    [self prepareNavigationBar];
    [self prepareSubViews];
}

- (void)prepareNavigationBar
{
    self.navigationController.navigationBar.tintColor = [UIColor greenColor];
    self.title = @"我的名片";
}

- (void)prepareSubViews
{
    UIImageView *cardImageView = [[UIImageView alloc] init];
    [self.view addSubview:cardImageView];
    
    [SYLJGenerateQRCode qrImageWithString:self.cardName avatar:self.avatar completion:^(UIImage *img) {
        cardImageView.image = img;
        [cardImageView sizeToFit];
        cardImageView.center = self.view.center;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
