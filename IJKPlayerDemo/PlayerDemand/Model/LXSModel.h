//
//  LXSModel.h
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/16.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXSVideoResolution.h"

@interface LXSModel : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *title;
/** 描述 */
@property (nonatomic, copy  ) NSString *video_description;
/** 视频地址 */
@property (nonatomic, copy  ) NSString *playUrl;
/** 封面图 */
@property (nonatomic, copy  ) NSString *coverForFeed;
/** 视频分辨率的数组 */
@property (nonatomic, strong) NSMutableArray *playInfo;
@end
