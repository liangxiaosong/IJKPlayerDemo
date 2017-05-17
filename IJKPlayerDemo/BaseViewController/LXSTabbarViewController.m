//
//  LXSTabbarViewController.m
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/8.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSTabbarViewController.h"
#import "LXSPlayDemandViewController.h"
#import "LXSLiveViewController.h"
#import "LXSDownloadViewController.h"
#import "LXSNavigationViewController.h"

@interface LXSTabbarViewController ()
<
UITabBarControllerDelegate,
UIViewControllerPreviewingDelegate
>

@property (nonatomic, strong)  NSMutableArray               *tabbarControllers;

@end

@implementation LXSTabbarViewController

+ (void)initialize {
    UITabBarItem *item = [UITabBarItem appearance];

    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.00]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.07 green:0.72 blue:0.96 alpha:1.00]} forState:UIControlStateSelected];
    [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];

    UITabBar *tabBar = [UITabBar appearance];
    tabBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUp];

    self.delegate = self;
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shortCut:) name:@"ShortCut" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUp{
    LXSLiveViewController *live = [[LXSLiveViewController alloc] init];
    [self setUpChildVC:live imageName:@"直播 (3)" selImageName:@"直播 (4)" title:@"直播"];
    LXSPlayDemandViewController *play = [[LXSPlayDemandViewController alloc] init];
    [self setUpChildVC:play imageName:@"" selImageName:@"" title:@"点播"];
    LXSDownloadViewController *download = [[LXSDownloadViewController alloc] init];
    [self setUpChildVC:download imageName:@"" selImageName:@"" title:@"下载"];
}

- (void)setUpChildVC:(UIViewController *)vc imageName:(NSString *)imageName selImageName:(NSString *)selImageName title:(NSString *)title
{
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selImageName];
    LXSNavigationViewController *rootVC = [[LXSNavigationViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:rootVC];
}

#pragma mark --InitProerty
- (NSMutableArray *)tabbarControllers{
    if (!_tabbarControllers) {
        _tabbarControllers = [NSMutableArray array];
    }
    return _tabbarControllers;
}

@end
