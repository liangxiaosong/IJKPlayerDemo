//
//  LXSNavigationViewController.m
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/8.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSNavigationViewController.h"

@interface LXSNavigationViewController ()
<
UINavigationControllerDelegate,
UIGestureRecognizerDelegate
>

@end

@implementation LXSNavigationViewController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navBg"] forBarMetrics:UIBarMetricsDefault];
    [bar setBarStyle:UIBarStyleDefault];
//    [bar setShadowImage:[UIImage imageNamed:@"nav_bottom_split_line"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }

    self.interactivePopGestureRecognizer.delegate = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count > 1) {
        return NO;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.viewControllers indexOfObject:self] == 0) {
        return YES;
    }
    return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}

#pragma mark - Super methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    /*
     if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
     self.interactivePopGestureRecognizer.enabled = YES;
     }
     */
}


#pragma mark - Overwrite
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
