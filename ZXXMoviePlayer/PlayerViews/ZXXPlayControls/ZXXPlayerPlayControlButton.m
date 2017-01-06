//
//  ZXXPlayerPlayControlButton.m
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/5.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import "ZXXPlayerPlayControlButton.h"
#import <Masonry.h>

@interface ZXXPlayerPlayControlButton ()

@property (nonatomic, assign, readwrite)BOOL isPlay;

/**
 * button的背景图
 */
@property (nonatomic, weak)UIImageView *bgImageView;

@end

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPlayButton:)];
    [self addGestureRecognizer:tap];
    
    // 添加背景图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).width.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.bgImageView = bgImageView;
}

- (void)touchPlayButton:(UITapGestureRecognizer *)tap
{
    self.selected = !self.isSelected;
    self.isPlay = self.isSelected;
    if ([self.delegate respondsToSelector:@selector(touchPlayButton:)]) {
        [self.delegate buttonTouchWithButton:self];
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
    [self setImage:playIcon withControl:UIControlStateNormal];
}
// 设置暂停按钮
- (void)setPauseIcon:(UIImage *)pauseIcon
{
    [self setImage:pauseIcon withControl:UIControlStateSelected];
}


/**
 * 设置不同状态下的图片

 @param image 图片
 @param state 状态
 */
- (void)setImage:(UIImage *)image withControl:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        _playIcon = image;
    }
    if (state == UIControlStateSelected) {
        _pauseIcon = image;
    }
    // 更换图片
    if (self.isSelected) {
        self.bgImageView.image = self.pauseIcon;
    }
    else{
        self.bgImageView.image = self.playIcon;
    }

}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        self.bgImageView.image = self.pauseIcon;
    }
    else{
        self.bgImageView.image = self.playIcon;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
