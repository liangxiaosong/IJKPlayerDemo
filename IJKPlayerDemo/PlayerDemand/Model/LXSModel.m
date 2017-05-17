//
//  LXSModel.m
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/16.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSModel.h"

@implementation LXSModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 转换系统关键字description
    if ([key isEqualToString:@"description"]) {
        self.video_description = [NSString stringWithFormat:@"%@",value];
    }

}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"playInfo"]) {
        self.playInfo = @[].mutableCopy;
        NSMutableArray *array = @[].mutableCopy;
        for (NSDictionary *dataDic in value) {
            LXSVideoResolution *resolution = [[LXSVideoResolution alloc] init];
            [resolution setValuesForKeysWithDictionary:dataDic];
            [array addObject:resolution];
        }
        [self.playInfo removeAllObjects];
        [self.playInfo addObjectsFromArray:array];
    } else if ([key isEqualToString:@"title"]) {
        self.title = value;
    } else if ([key isEqualToString:@"playUrl"]) {
        self.playUrl = value;
    } else if ([key isEqualToString:@"coverForFeed"]) {
        self.coverForFeed = value;
    }

}

@end
