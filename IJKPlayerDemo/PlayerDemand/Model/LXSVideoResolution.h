//
//  LXSVideoResolution.h
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/16.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXSVideoResolution : NSObject

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, copy  ) NSString  *name;
@property (nonatomic, copy  ) NSString  *type;
@property (nonatomic, copy  ) NSString  *url;

@end
