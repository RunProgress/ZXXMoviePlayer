//
//  ZXXBufferProgressView.h
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/9.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXXBufferProgressView : UIProgressView
/**
 * 获取当前缓存的进度
 */
@property (nonatomic, assign, readonly)CGFloat bufferProgress;


/**
 * 在需要获取播放缓冲进度的控件里需要实现该方法  用于播放器更改控件的显示进度
 
 @param bufferProgress 缓冲的进度 (百分比) 播放器赋值,用于更改控件显示的缓冲进度
 */
- (void)changeBufferProgress:(NSNumber *)bufferProgress;

@end
