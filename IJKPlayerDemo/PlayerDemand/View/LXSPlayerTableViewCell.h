//
//  LXSPlayerTableViewCell.h
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/16.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXSModel;

@interface LXSPlayerTableViewCell : UITableViewCell

@property (nonatomic, strong) LXSModel          *model;
@property (strong, nonatomic  ) UIImageView         *picView;

@property (nonatomic, copy) void (^playBlaok)  (UIButton *);

@end
