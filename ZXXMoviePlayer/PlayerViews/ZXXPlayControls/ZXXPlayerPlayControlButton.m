//
//  ZXXPlayerPlayControlButton.m
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/5.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import "ZXXPlayerPlayControlButton.h"

@implementation ZXXPlayerPlayControlButton

// --- initalize ---
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (void)setupButton
{
    [self addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchPlayButton:(ZXXPlayerPlayControlButton *)button
{
    button.selected = !button.isSelected;
    self.isPlay = button.isSelected;
    if ([self.delegate respondsToSelector:@selector(touchPlayButton:)]) {
        [self.delegate buttonTouchWithButton:button];
    }
}

- (void)changeButtonStatusWithIsPlayIcon:(NSString *)isPlayIcon
{
    BOOL isShowPlay = ![isPlayIcon isEqualToString:@"0"];
    self.selected = !isShowPlay;
}

#pragma mark --- override ---

// 设置播放按钮
- (void)setPlayIcon:(UIImage *)playIcon
{
    _playIcon = playIcon;
    [self setImage:_playIcon forState:UIControlStateNormal];
}

// 设置暂停按钮
- (void)setPauseIcon:(UIImage *)pauseIcon
{
    _pauseIcon = pauseIcon;
    [self setImage:_pauseIcon forState:UIControlStateSelected];
}

- (BOOL)isPlay
{
    return self.isSelected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
