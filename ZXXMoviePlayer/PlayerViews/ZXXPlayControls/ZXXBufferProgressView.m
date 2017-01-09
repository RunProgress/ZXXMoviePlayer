//
//  ZXXBufferProgressView.m
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/9.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import "ZXXBufferProgressView.h"

@implementation ZXXBufferProgressView

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
    self.progressTintColor = [UIColor lightGrayColor];
    self.trackTintColor = [UIColor grayColor];
}

- (void)changeBufferProgress:(NSNumber *)bufferProgress
{
    bufferProgress = bufferProgress.floatValue > 1.0 ? @1.0 : bufferProgress;
    bufferProgress = bufferProgress.floatValue < 0 ? @0 : bufferProgress;
    
    self.progress = bufferProgress.floatValue;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
