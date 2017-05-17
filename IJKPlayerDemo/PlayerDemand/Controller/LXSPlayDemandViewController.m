//
//  LXSPlayDemandViewController.m
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/8.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSPlayDemandViewController.h"
#import "LXSModel.h"
#import "ZFPlayerModel.h"
#import "LXSPlayerTableViewCell.h"
#import "ZFPlayer.h"
#import <ZFDownload/ZFDownloadManager.h>



static NSString *const cellIdentifier = @"cellIdentifier";

@interface LXSPlayDemandViewController ()<UITableViewDelegate, UITableViewDataSource,ZFPlayerDelegate>

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation LXSPlayDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"点播";

    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 从资源文件中获取数据
 */
- (void)requestData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *videoList = [rootDict objectForKey:@"videoList"];
    for (NSDictionary *dataDic in videoList) {
        LXSModel *model = [[LXSModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 379.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXSPlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LXSPlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    LXSModel *model = self.dataArray[indexPath.row];
    cell.model = model;

    __block NSIndexPath *weakIndexPath = indexPath;
    __block LXSPlayerTableViewCell *weakCell     = cell;
    __weak typeof(self)  weakSelf      = self;

    [cell setPlayBlaok:^(UIButton *sender){
        // 分辨率字典（key:分辨率名称，value：分辨率url)
        NSMutableDictionary *dict = @{}.mutableCopy;
        for (LXSVideoResolution *resolution in model.playInfo) {
            [dict setValue:resolution.url forKey:resolution.name];
        }
        // 取出字典中的第一视频URL
        NSURL *videoURL = [NSURL URLWithString:dict.allValues.firstObject];
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
        playerModel.title            = model.title;
        playerModel.videoURL         = videoURL;
        playerModel.placeholderImageURLString = model.coverForFeed;
        playerModel.scrollView       = weakSelf.tableView;
        playerModel.indexPath        = weakIndexPath;
        // 赋值分辨率字典
        playerModel.resolutionDic    = dict;
        // player的父视图tag
        playerModel.fatherViewTag    = weakCell.picView.tag;

        // 设置播放控制层和model
        [weakSelf.playerView playerControlView:nil playerModel:playerModel];
        // 下载功能
        weakSelf.playerView.hasDownload = YES;
        // 自动播放
        [weakSelf.playerView autoPlayTheVideo];
    }];

    return cell;
}

#pragma mark - InitProperty

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[LXSPlayerTableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;

        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}

@end
