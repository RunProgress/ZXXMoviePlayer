//
//  ZXXPlayProgressView.h
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/6.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXXPlayProgressView : UISlider

/**
 * 当前的播放进度
 */
@property (nonatomic, assign, readonly)CGFloat playProgress;
/*
 * 要跳转到的播放进度
 */
@property (nonatomic, assign)CGFloat seekProgress;


/**
 * 实现此方法,用于播放器改变进度条的当前播放比

 @param progress 进度
 */
- (void)changeProgress:(NSNumber *)progress;

@end
