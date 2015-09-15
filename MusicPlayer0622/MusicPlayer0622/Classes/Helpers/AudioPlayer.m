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
{
    BOOL _isPrepare;//播放器是否准备成功
    BOOL _isPlaying;//播放器是否正在播放
}

//播放器
@property (nonatomic,strong) AVPlayer * player;

//定时器
@property (nonatomic,strong) NSTimer * timer;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        //通知中心
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
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
    
    //判断资源是否准备成功
    if (!_isPrepare) {
        return;
    }
    
    [self.player play];
    _isPlaying = YES;
    
    //播放的时候图片转动效果
    
    //timer 初始化
    if (_timer) {
        return;
    }
    //创建一个timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingAction:) userInfo:nil repeats:YES];
}

- (void)pause{
    if (!_isPlaying) {
        return;
    }
    [self.player pause];
    _isPlaying = NO;
    
    //销毁计时器
    [_timer invalidate];
    _timer = nil;
}


- (void)seekToTime:(float)time{
    
    //当音乐播放器时间改变时,先暂停,后播放
    [self pause];
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        
        if (finished) {
            [self play];
        }

    }];
}

//每隔0.1秒执行一下这个事件
- (void)playingAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioplayerPlayWith:Progress:)]) {
        
        //获取当前播放歌曲的播放时间
        float progress = 1.0 * self.player.currentTime.value / self.player.currentTime.timescale;
        
        [self.delegate audioplayerPlayWith:self Progress:progress];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItemStatus staute = [change[@"new"] integerValue];
    switch (staute) {
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"加载成功,可以播放了");
            _isPrepare = YES;
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
//当一首歌播放结束时会执行下面方法
- (void)endAction:(NSNotification *)not{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioplayerDidFinishItem:)]) {
        [self.delegate audioplayerDidFinishItem:self];
    }
}


-(AVPlayer *)player{
    if (_player == nil) {
        _player = [AVPlayer new];
    }
    return _player;
}

- (BOOL)isPlaying{
    return _isPlaying;
}

@end
