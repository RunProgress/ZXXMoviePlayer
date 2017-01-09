//
//  ViewController.m
//  ZXXMoviePlayer
//
//  Created by 张潇 on 2017/1/4.
//  Copyright © 2017年 Zhangx. All rights reserved.
//

#import "ViewController.h"
#import "ZXXPlayerMachineView.h"
#import "ZXXPlayInterFaceView.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZXXPlayerMachineView *player = [[ZXXPlayerMachineView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    [self.view addSubview:player];
    ZXXPlayInterFaceView *interfaceView = [[ZXXPlayInterFaceView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    [self.view addSubview:interfaceView];
    [player connectInterFaceControlsListToPlayerWithControlList:@{kZXXPlayerControlPlayButton : interfaceView.playButton, kZXXPlayerControlPlayTimeProgress : interfaceView.playProgress, kZXXPlayerControlBufferProgress : interfaceView.bufferProgress}];
  
    player.sourceURL = [NSURL URLWithString:@"https://gslb.miaopai.com/stream/yIrm942ZmX89Zjx086q6PA__.mp4"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
