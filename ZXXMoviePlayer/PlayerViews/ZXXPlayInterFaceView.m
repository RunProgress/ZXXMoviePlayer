//
//  ZXXPlayInterFaceView.m
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/4.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import "ZXXPlayInterFaceView.h"

@interface ZXXPlayInterFaceView ()


@end

@implementation ZXXPlayInterFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _playButton = [[ZXXPlayerPlayControlButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_playButton setupButton];
        _playButton.playIcon = [UIImage imageNamed:@"player_play.jpg"];
        _playButton.pauseIcon = [UIImage imageNamed:@"player_pause.jpg"];
        [self addSubview:_playButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _playButton.center = CGPointMake(self.bounds.size.width / 2.0,
                                     self.bounds.size.height / 2.0);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
