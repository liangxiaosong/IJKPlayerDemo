//
//  LXSLiveViewController.m
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/8.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSLiveViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <BarrageRenderer/BarrageRenderer.h>
#import "BarrageWalkImageTextSprite.h"
#import "UIImage+Barrage.h"

@interface LXSLiveViewController ()<BarrageRendererDelegate>
{
     NSDate * _startTime;
}
@property (atomic, strong) NSURL                    *url;
@property (atomic, retain) id <IJKMediaPlayback>    player;
@property (weak, nonatomic) UIView                  *PlayerView;
@property (nonatomic, strong) UIButton                   *play_btn;
@property (nonatomic, strong) BarrageRenderer                   *renderer;

@end

@implementation LXSLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"直播";

    //直播视频
    self.url = [NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"];
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];

    UIView *playerView = [self.player view];


    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, LXS_WIDTH, LXS_WIDTH / 16 * 9)];
    self.PlayerView = displayView;
    self.PlayerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.PlayerView];

    playerView.frame = self.PlayerView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.PlayerView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    [self installMovieNotificationObservers];
    //创建弹幕
    [self initBarrageRenderer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if (![self.player isPlaying]) {
        [self.player play];
        [self.player prepareToPlay];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
}

#pragma mark - 创建弹幕
- (void)initBarrageRenderer {
    self.renderer = [[BarrageRenderer alloc] init];
    self.renderer.delegate = self;
    self.renderer.redisplay = YES;
    [self.PlayerView addSubview:self.renderer.view];
    [self.PlayerView bringSubviewToFront:self.renderer.view];
    //加载弹幕
    [self loadRenderer];

    _startTime = [NSDate date];
     [self.renderer start];
}
#pragma mark --加载弹幕

- (void)loadRenderer {
    NSInteger const number = 100;
    NSMutableArray * descriptors = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < number; i++) {
//        if (i % 2 == 0) {
//            [descriptors addObject:[self walkImageTextSpriteDescriptorAWithDirection:3]];
//
//        }else if (i % 7 == 0) {
//              [descriptors addObject:[self walkImageTextSpriteDescriptorBWithDirection:3]];
//        }
//        else {
            [descriptors addObject:[self walkTextSpriteDescriptorWithDelay:i*2+1]];
//        }
    }
    [_renderer load:descriptors];

}

#pragma mark - 弹幕描述符生产方法

/// 生成精灵描述 - 延时文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDelay:(NSTimeInterval)delay
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);

    NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
    attachment.image = [[UIImage imageNamed:@"avatar"] barrageImageScaleToSize:CGSizeMake(25.0f, 25.0f)];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:
                                              [NSString stringWithFormat:@"BB-图文混排过场弹幕"]];
    [attributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:7];

    descriptor.params[@"attributedText"] = attributed;

//    descriptor.params[@"text"] = [NSString stringWithFormat:@"延时弹幕(延时%.0f秒)",delay];
    descriptor.params[@"textColor"] = [UIColor blueColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(1);
    descriptor.params[@"delay"] = @(delay);
    return descriptor;
}

/// 图文混排精灵弹幕 - 过场图文弹幕A
- (BarrageDescriptor *)walkImageTextSpriteDescriptorAWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkImageTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"AA-图文混排/::B过场弹幕"];
    descriptor.params[@"textColor"] = [UIColor greenColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}


/// 图文混排精灵弹幕 - 过场图文弹幕B
- (BarrageDescriptor *)walkImageTextSpriteDescriptorBWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"AA-图文混排/::B过场弹幕"];
    descriptor.params[@"textColor"] = [UIColor greenColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);

    NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
    attachment.image = [[UIImage imageNamed:@"avatar"] barrageImageScaleToSize:CGSizeMake(25.0f, 25.0f)];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:
                                              [NSString stringWithFormat:@"BB-图文混排过场弹幕"]];
    [attributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:7];

    descriptor.params[@"attributedText"] = attributed;
    descriptor.params[@"textColor"] = [UIColor magentaColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}

#pragma mark - BarrageRendererDelegate

- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer
{
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:_startTime];
//    interval += _predictedTime;
    return interval;
}

#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;

    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;

        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;

        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;

        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;

        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;

        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;

        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;

        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }

        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma Install Notifiacation

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];

}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
}

@end
