//
//  ZXXPlayInterFaceView.h
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/4.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXXPlayControlButton.h"
#import "ZXXPlayProgressView.h"
#import "ZXXBufferProgressView.h"

@interface ZXXPlayInterFaceView : UIView

@property (nonatomic, strong)ZXXPlayControlButton *playButton;
@property (nonatomic, strong)ZXXPlayProgressView *playProgress;
@property (nonatomic, strong)ZXXBufferProgressView *bufferProgress;

@end
