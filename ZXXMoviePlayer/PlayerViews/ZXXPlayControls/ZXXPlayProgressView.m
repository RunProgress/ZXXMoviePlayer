//
//  ZXXPlayProgressView.m
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/6.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import "ZXXPlayProgressView.h"

@interface ZXXPlayProgressView ()

@property (nonatomic, assign, readwrite)CGFloat playProgress;
@property (nonatomic, assign)BOOL isSlider; // 是否正在拖动进度条

@end

@implementation ZXXPlayProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.maximumValue = 1.0;
    self.minimumValue = 0;
    
    self.maximumTrackTintColor = [UIColor clearColor];
    self.tintColor = [UIColor cyanColor];
    self.thumbTintColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.6];
    
    //
    [self addTarget:self action:@selector(playThisScaleTime) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(sliderProgress) forControlEvents:UIControlEventTouchDown];
}

- (void)changeProgress:(NSNumber *)progress
{
    if (self.isSlider) {
        return;
    }
    _playProgress = progress.floatValue > 1 ? 1.0 : progress.floatValue;
    _playProgress = progress.floatValue < 0 ? 0 : progress.floatValue;
    self.value = _playProgress;
}

// 播放该时间点
- (void)playThisScaleTime
{
    NSLog(@"收起");
    self.isSlider = NO;
    self.seekProgress = self.value;
}

// 按下滑块
- (void)sliderProgress
{
    NSLog(@"按下");
    self.isSlider = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
