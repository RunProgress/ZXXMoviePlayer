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
 * 在需要获取播放进度的控件里需要实现该方法 用于播放器更改控件的显示进度

 @param progress 进度 播放器赋值,用于更改控件显示的播放进度
 */
- (void)changeProgress:(NSNumber *)progress;

@end
