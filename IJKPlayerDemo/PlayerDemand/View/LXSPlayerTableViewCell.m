//
//  LXSPlayerTableViewCell.m
//  IJKPlayerDemo
//
//  Created by LPPZ-User01 on 2017/5/16.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSPlayerTableViewCell.h"
#import "LXSModel.h"
#import "UIImageView+WebCache.h"

@interface LXSPlayerTableViewCell ()

@property (strong, nonatomic)  UIImageView          *avatarImageView;
@property (strong, nonatomic  ) UILabel             *titleLabel;
@property (nonatomic, strong) UIButton              *playBtn;
@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UILabel               *timeLabel;

@end

@implementation LXSPlayerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubControls];
        self.picView.tag = 101;
    }
    return self;
}

- (void)addSubControls {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.picView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.picView addSubview:self.playBtn];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(35/2);
        make.top.equalTo(self.avatarImageView.mas_top);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.avatarImageView.mas_left);
    }];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(LXS_WIDTH, 213));
        make.left.equalTo(self.contentView.mas_left);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.picView);
    }];
}

- (void)setModel:(LXSModel *)model {
    _model = model;
    self.nameLabel.text = @"LXS点播测试";

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.coverForFeed]];
    self.picView.image = [UIImage imageWithData:data];

//    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.timeLabel.text = [self currenttime];
}

- (NSString *)currenttime {
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];

    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * na = [df stringFromDate:currentDate];
    return na;
}

#pragma mark - InitProperty
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultUserIcon@2x"]];
        _avatarImageView.layer.cornerRadius = 40 /2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1.00];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _nameLabel;
}

- (UIImageView *)picView {
    if (!_picView ) {
        _picView = [[UIImageView alloc] init];
        _picView.userInteractionEnabled = YES;
    }
    return _picView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1.00];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:1.00];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon@2x"] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}


#pragma mark - BtnActivity

- (void)play:(UIButton *)sender {
    if (self.playBlaok) {
        self.playBlaok(sender);
    }
}

@end
