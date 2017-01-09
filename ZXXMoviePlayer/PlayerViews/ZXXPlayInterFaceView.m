//
//  ZXXPlayInterFaceView.m
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/4.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import "ZXXPlayInterFaceView.h"
#import <Masonry.h>

@interface ZXXPlayInterFaceView ()


@end

@implementation ZXXPlayInterFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 播放按钮
    _playButton = [[ZXXPlayerPlayControlButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_playButton setupButton];
    _playButton.playIcon = [UIImage imageNamed:@"player_play.jpg"];
    _playButton.pauseIcon = [UIImage imageNamed:@"player_pause.jpg"];
    [self addSubview:_playButton];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
    }];
    
    // 进度条
    _playProgress = [[ZXXPlayProgressView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 40, 20)];
    [bottomView addSubview:_playProgress];
    [_playProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.equalTo(bottomView).with.offset(20);
        make.right.equalTo(bottomView).with.offset(-20);
        make.top.equalTo(bottomView);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
