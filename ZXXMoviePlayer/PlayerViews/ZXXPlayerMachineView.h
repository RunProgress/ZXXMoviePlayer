//
//  ZXXPlayerMachineView.h
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/4.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZXXControlKey.h"

typedef NS_ENUM(NSUInteger, ZXXPlayeItemStatus) {
    ZXXPlayItemReadyToPlay = 0, // 播放器播放准备就绪
    ZXXPlayItemPlaying = 1, // 播放器正在播放
    ZXXPlayItemLoadingBuffer = 2, // 播放器正在加载缓冲 处于暂停时间
    ZXXPlayItemEndPlay = 3, // 播放器播放结束
    ZXXPlayItemPlayPause = 4, // 播放器暂停播放
    ZXXPlayItemLoadUnKnown = 5, // 播放器处于未知的状态
    ZXXPlayItemLoadFail = 6, // 播放器资源加载失败
    ZXXPlayItemUnLoad = 7, // 未开始加载资源URL 准备状态
    ZXXPlayItemStartToload = 8, // 开始根据URL去寻找资源文件,但是还没有得到返回的结果
};


@interface ZXXPlayerMachineView : UIView

/**
 播放地址的URL
 */
@property (nonatomic, strong)NSURL *sourceURL;
// 当前的播放状态
@property (nonatomic, assign)ZXXPlayeItemStatus currentItemStatus;

@property (nonatomic, assign, readonly)CGFloat bufferProgress; // 缓冲的进度 (0 - 1)
@property (nonatomic, assign, readonly)CGFloat playProgress; // 播放进度 (0 - 1)
@property (nonatomic, assign, readonly)NSTimeInterval currentPlayTime; // 当前播放的时间
@property (nonatomic, assign, readonly)NSTimeInterval currentItemTotalDuration; // 当前播放项的时长


/**
 讲播放界面的控制播放的控件同播放器关联起来

 @param playerControls 控制播放的播放器的列表,每个control的Item采用kv (Key:播放控件类型, Value:播放控件实例)
 */
- (void)connectInterFaceControlsListToPlayerWithControlList:(NSDictionary *)playerControls;
/**
 开始播放
 */
- (void)videoPlay;

@end
