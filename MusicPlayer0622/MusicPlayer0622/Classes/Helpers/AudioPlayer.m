//
//  AudioPlayer.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/15.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "AudioPlayer.h"
@import AVFoundation;
@interface AudioPlayer ()

//播放器
@property (nonatomic,strong) AVPlayer * player;

@end


@implementation AudioPlayer


+ (AudioPlayer *)sharedPlayer{
    static AudioPlayer * player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [AudioPlayer new];
    });
    return player;
}

- (void)setPrepareMusicWithURL:(NSString *)urlStr{
    
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    //创建了一个item资源
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    
    //观察一下这个item 的状态
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}
- (void)play{
    [self.player play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItemStatus staute = [change[@"new"] integerValue];
    switch (staute) {
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"加载成功,可以播放了");
            [self play];
            break;
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"资源找不到");
            break;
        default:
            break;
    }
    NSLog(@"change:%@",change);
}


-(AVPlayer *)player{
    if (_player == nil) {
        _player = [AVPlayer new];
    }
    return _player;
}


@end
