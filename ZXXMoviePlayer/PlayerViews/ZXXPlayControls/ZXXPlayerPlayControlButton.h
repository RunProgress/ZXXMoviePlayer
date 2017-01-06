//
//  ZXXPlayerPlayControlButton.h
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/5.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXXPlayerPlayControlButton;

@protocol ZXXPlayerPlayControlButtonDelegate <NSObject>

- (void)buttonTouchWithButton:(ZXXPlayerPlayControlButton *)playButton;

@end


/**
 * 控制播放器 开始暂停的按钮
 */
@interface ZXXPlayerPlayControlButton : UIView

/**
 * 播放按钮
 */
@property (nonatomic, strong)UIImage *playIcon;
/**
 * 暂停按钮
 */
@property (nonatomic, strong)UIImage *pauseIcon;
/**
 * 按钮的选中状态
 */
@property (nonatomic, assign, getter=isSelected)BOOL selected;

/**
 * 是否是 播放状态(此时的按钮是暂停按钮), YES 播放中, NO 暂停
 */
@property (nonatomic, assign, readonly)BOOL isPlay;
@property (nonatomic, weak)id<ZXXPlayerPlayControlButtonDelegate> delegate;


- (void)setupButton;
/**
 * 改变按钮状态的方法, 实现该方法 可以让player 改变当前按钮的状态

 @param isPlayIcon 按钮当前显示的是否是播放按钮这个状态
 */
- (void)changeButtonStatusWithIsPlayIcon:(NSString *)isPlayIcon;
@end
