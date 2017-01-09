//
//  ZXXPlayerMachineView.m
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/4.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import "ZXXPlayerMachineView.h"
#import "ZXXPlayControlButton.h"
#import "ZXXPlayProgressView.h"
#import <Masonry.h>

@interface ZXXPlayerMachineView ()
@property (nonatomic, assign, readwrite)CGFloat bufferProgress; // 缓冲的进度 (0 - 1)
@property (nonatomic, weak)AVPlayer *moviePlayer; // 播放器
@property (nonatomic, weak)AVPlayerLayer *moviePlayerLayer; // 播放器Layer
@property (nonatomic, strong)AVPlayerItem *currentPlayerItem; // 播放的Item
@property (nonatomic, strong)NSTimer *playeTime; // 播放监听的定时器
@property (nonatomic, strong)NSDictionary *playControlDict; // 控制播放器的 播放控件列表
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation ZXXPlayerMachineView

// --- initialize ---
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupPalyerViewAndLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupPalyerViewAndLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPalyerViewAndLayer];
    }
    return self;
}

// --- create subViews ---
- (void)setupPalyerViewAndLayer
{
    [self setupPLayer]; // 初始化播放器
    [self setupParams]; // 初始化参数
    
    // 注册 监听一个项目是否播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentPlayItemPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

/**
 * 初始化播放器
 */
- (void)setupPLayer
{
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:nil];
    self.moviePlayer = player;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_moviePlayer];
    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    playerLayer.frame = self.bounds;
    [self.layer addSublayer:playerLayer];
    self.moviePlayerLayer = playerLayer;
}

/**
 * 初始化参数
 */
- (void)setupParams
{
    // 默认循环播放
    self.isPlayCircularly = YES;
}

/**
 * 关联播放控件和播放器
 */
- (void)connectInterFaceControlsListToPlayerWithControlList:(NSDictionary *)playerControls
{
    self.playControlDict = playerControls;
    [self registerPlayControl];
}

/**
 * 注册播放控件
 */
- (void)registerPlayControl
{
    if ([self.playControlDict valueForKey:kZXXPlayerControlPlayButton]) {
        id playButton = [self.playControlDict valueForKey:kZXXPlayerControlPlayButton];
        [playButton addObserver:self forKeyPath:@"isPlay" options:NSKeyValueObservingOptionNew context:nil];
    }
    if ([self.playControlDict valueForKey:kZXXPlayerControlPlayTimeProgress]) {
        id playProgress = [self.playControlDict valueForKey:kZXXPlayerControlPlayTimeProgress];
        [playProgress addObserver:self forKeyPath:@"seekProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/**
 * 准备开始播放
 */
- (void)readyToPlay
{
    _currentItemStatus = ZXXPlayItemStartToload;
    // 移除旧的观察者
    @try {
        [self.currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];
        [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    } @catch (NSException *exception) {
        NSLog(@"移除失败");
    }
    
    [self.currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil]; // 监听 播放状态
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil]; // 监听 当前的播放的缓冲为空
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil]; // 监听 当前的播放缓冲 可以再次播放
    
    [_moviePlayer replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    [_moviePlayer play];
    
    // 设置定时器
    if (_timer) {
        [_timer invalidate];
    }
    [self.timer setFireDate:[NSDate distantPast]];
}

#pragma mark --- 控制播放的方法 ---
/**
 * 设置播放的URL
 
 @param sourceURL 播放的URL
 */
- (void)setSourceURL:(NSURL *)sourceURL
{
    if (sourceURL) {
        _sourceURL = sourceURL;
        self.currentPlayerItem = [AVPlayerItem playerItemWithURL:_sourceURL];
        self.currentItemStatus = ZXXPlayItemUnLoad;
    }
}

/**
 * 播放
 */
- (void)videoPlay
{
    [self buttonControlToPlay];
    if ([[self.playControlDict valueForKey:kZXXPlayerControlPlayButton] respondsToSelector:@selector(changeButtonStatusWithIsPlayIcon:)]) {
        [[self.playControlDict valueForKey:kZXXPlayerControlPlayButton] performSelector:@selector(changeButtonStatusWithIsPlayIcon:) withObject:@"0"];
    }
}

/**
 * 按钮控制播放
 */
- (void)buttonControlToPlay
{
    if (_currentItemStatus == ZXXPlayItemUnLoad) {
        [self readyToPlay];
    }
    else{
        if (self.isPlayCircularly && _currentItemStatus == ZXXPlayItemEndPlay) {
            [self playSpecificTime:0];
        }
        [_moviePlayer play];
    }
}

/**
 * 暂停
 */
- (void)videoPause
{
    [_moviePlayer pause];
    if ([[self.playControlDict valueForKey:kZXXPlayerControlPlayButton] respondsToSelector:@selector(changeButtonStatusWithIsPlayIcon:)]) {
        [[self.playControlDict valueForKey:kZXXPlayerControlPlayButton] performSelector:@selector(changeButtonStatusWithIsPlayIcon:) withObject:@"1"];
    }
}

/**
 * 播放到指定的时间

 @param time 指定的播放时间
 */
- (void)playSpecificTime:(NSTimeInterval)time
{
    CMTime toPlayTime = CMTimeMake((int64_t)(time), 1);
    [_moviePlayer seekToTime:toPlayTime completionHandler:^(BOOL finished) {
        
    }];
}

/**
 * 播放指定时间比例的视频

 @param playScale 比例 (0 ~ 1)
 */
- (void)playSpecificScale:(CGFloat)playScale
{
    playScale = playScale > 1.0 ? 1.0 : playScale;
    playScale = playScale < 0 ? 0 : playScale;
    NSTimeInterval totalTime = self.currentItemTotalDuration;
    NSTimeInterval playTime = totalTime * playScale;
    [self playSpecificTime:playTime];
}

// ----------------------------------------

/*
 监听
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqual:_currentPlayerItem]) {
        if ([keyPath isEqualToString:@"status"]) {
            switch (self.currentPlayerItem.status) {
                case AVPlayerItemStatusUnknown:
                    _currentItemStatus = ZXXPlayItemLoadUnKnown;
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    _currentItemStatus = ZXXPlayItemReadyToPlay;
                    break;
                case AVPlayerItemStatusFailed:
                    _currentItemStatus = ZXXPlayItemLoadFail;
                default:
                    break;
            }
        }
        if ([keyPath isEqualToString:@"loadTimeRanges"]) {
//            NSTimeInterval bufferTime = [self availableDuration];
//            CGFloat totalPlayDuration = CMTimeGetSeconds(self.currentPlayerItem.duration);
//            _bufferProgress = bufferTime / totalPlayDuration;
        }
        if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            [self bufferWaitTimeWhenBufferEmpty];
        }
        if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            NSLog(@"有播放缓存了------");
        }
        
    }
    
    // 播放控制按钮
    if ([object isEqual:[self.playControlDict valueForKey:kZXXPlayerControlPlayButton]]) {
        if (self) {
            ZXXPlayControlButton *button = [self.playControlDict valueForKey:kZXXPlayerControlPlayButton];
            if (button.isPlay) {
                [self buttonControlToPlay];
            }
            else{
                [_moviePlayer pause];
            }
        }
    }
    // 播放显示进度条
    if ([object isEqual:[self.playControlDict valueForKey:kZXXPlayerControlPlayTimeProgress] ]) {
        if (self) {
            ZXXPlayProgressView *playProgress = [self.playControlDict valueForKey:kZXXPlayerControlPlayTimeProgress];
            [self playSpecificScale:playProgress.seekProgress];
        }
    }
}

#pragma mark --- overrride getter ---
- (NSTimeInterval)currentPlayTime
{
    if (_moviePlayer) {
        NSTimeInterval currentPlayTime = CMTimeGetSeconds(_moviePlayer.currentTime);
        return currentPlayTime;
    }
    return 0;
}

- (NSTimeInterval)currentItemTotalDuration
{
    if (_moviePlayer && _currentPlayerItem) {
        NSTimeInterval currentDuration = CMTimeGetSeconds(_currentPlayerItem.duration);
        if (currentDuration == NAN) {
            currentDuration = 0;
        }
        return currentDuration;
    }
    return 0;
}

- (CGFloat)bufferProgress
{
    NSTimeInterval bufferTime = [self availableDuration];
    CGFloat totalPlayDuration = CMTimeGetSeconds(self.currentPlayerItem.duration);
    _bufferProgress = bufferTime / totalPlayDuration;
    return _bufferProgress;
}

- (CGFloat)playProgress
{
    if (self.currentItemTotalDuration > 0 && self.currentItemTotalDuration != NAN) {
        return self.currentPlayTime / self.currentItemTotalDuration;
    }
    return 0;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(setCurrentPlayTimeScaleToProgress) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

#pragma mark --- 获取 播放参数 ---
/**
 获取缓存到达的时间

 @return 缓存到达的时间点
 */
- (NSTimeInterval)availableDuration
{
    // 获取当前播放项的 缓存信息
    NSArray *timeArr = [[_moviePlayer currentItem] loadedTimeRanges];
    // 从数组中拿到缓存的时间的范围
    CMTimeRange bufferTimeRange = [[timeArr firstObject]  CMTimeRangeValue];
    // 缓存开始的时间
    NSTimeInterval bufferStartTime = CMTimeGetSeconds(bufferTimeRange.start);
    // 获取缓存的时长
    NSTimeInterval bufferDuration = CMTimeGetSeconds(bufferTimeRange.duration);
    // 缓存到达的时间点 = 起始时间 + 时长
    NSTimeInterval bufferTime = bufferStartTime + bufferDuration;
    
    return bufferTime;
}


/**
 当缓冲区域问空时 暂停播放的操作
 */
- (void)bufferWaitTimeWhenBufferEmpty
{
    static BOOL isBuffer = NO;
    // 如果在缓存等待时  这时候进来之后不做处理 知道等待结束
    if (isBuffer) {
        return;
    }
    
    isBuffer = YES;
    [_moviePlayer pause];
    _currentItemStatus = ZXXPlayItemLoadingBuffer;

    // 1s后重新检查 buffer的情况
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isBuffer = YES;
        
        if (self.bufferProgress - self.playProgress > 0.01) {
            if (_currentItemStatus != ZXXPlayItemPlayPause) {
                [self videoPlay];
                _currentItemStatus = ZXXPlayItemPlaying;
            }
        }
        else{
            [self bufferWaitTimeWhenBufferEmpty];
        }
        
    });
}

- (void)setCurrentPlayTimeScaleToProgress
{
    id playTimeProgress = [self.playControlDict valueForKey:kZXXPlayerControlPlayTimeProgress];
    id bufferProgress = [self.playControlDict valueForKey:kZXXPlayerControlBufferProgress];
    if (playTimeProgress) {
        CGFloat scale = self.currentPlayTime / self.currentItemTotalDuration;
        if ([playTimeProgress respondsToSelector:@selector(changeProgress:)]) {
            [playTimeProgress performSelector:@selector(changeProgress:) withObject:[NSNumber numberWithFloat:scale]];
        }
    }
    
    if (bufferProgress) {
        if ([bufferProgress respondsToSelector:@selector(changeBufferProgress:)]) {
            NSTimeInterval bufferTime = [self availableDuration];
            CGFloat totalPlayDuration = CMTimeGetSeconds(self.currentPlayerItem.duration);
            CGFloat bufferProgressScale = bufferTime / totalPlayDuration;
            [bufferProgress performSelector:@selector(changeBufferProgress:) withObject:[NSNumber numberWithFloat:bufferProgressScale]];
        }

    }
}

/**
 当前的播放项目 播放完毕
 */
- (void)currentPlayItemPlayToEndTime
{
    NSLog(@"播放完毕");
    _currentItemStatus = ZXXPlayItemEndPlay;
    [self videoPause];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
