//
//  MusicPlayingController.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/15.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "MusicPlayingController.h"
#import "MusicItem.h"
#import "MusicListHelper.h"
#import "UIImageView+WebCache.h"
#import "AudioPlayer.h"

@interface MusicPlayingController ()<AudioPlayerDelegate>
- (IBAction)disMissAction:(id)sender;
- (IBAction)startOrPuase:(id)sender;

//当前播放音乐的模型
@property (nonatomic,strong) MusicItem * currentModel;

@property (weak, nonatomic) IBOutlet UIImageView *img4MusicPic;


//当前正在播放的索引
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation MusicPlayingController

//因为这个页面要一直存在,所以要使用单例
+ (MusicPlayingController *)shareController{
    static MusicPlayingController *playingcontroller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playingcontroller = [MusicPlayingController new];
    });
    return playingcontroller;
}

//因为这个控制器实际上存在sb中,所以要重写这个方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //去sb 中找到这个控制器
        MusicPlayingController * playing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayingVC"];
        self = playing;
        _currentIndex = -1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //如果要播放的音乐和当前播放的音乐是一样的,就直接返回,下面的代码不执行了
    if (_index == _currentIndex) {
        return;
    }
    _currentIndex = _index;
    
    [self startPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.img4MusicPic.layer.masksToBounds = YES;
    self.img4MusicPic.layer.cornerRadius = 100;
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 公开方法
- (void)startPlay{
    [self updateUI];
    
    [[AudioPlayer sharedPlayer] setPrepareMusicWithURL:self.currentModel.mp3Url];
    [AudioPlayer sharedPlayer].delegate = self;
    
}

#pragma mark - 私有方法
- (void)updateUI{
    
    //如果换歌的话,就让图片重新归位
    self.img4MusicPic.transform = CGAffineTransformMakeRotation(0);
    
    //可以根据获取到当前播放的音乐model 更新UI
    [self.img4MusicPic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//返回按钮
- (IBAction)disMissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//暂停或者播放按钮事件
- (IBAction)startOrPuase:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if([AudioPlayer sharedPlayer].isPlaying){
        [[AudioPlayer sharedPlayer] pause];
        [btn setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        [[AudioPlayer sharedPlayer] play];
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
    }
    
}
#pragma mark - AudioPlayerDelegate
-(void)audioplayerPlayWith:(AudioPlayer *)audioplayer Progress:(float)progress{
    NSLog(@"%f",progress);
    self.img4MusicPic.transform = CGAffineTransformRotate(self.img4MusicPic.transform, M_PI / 100);
}

#pragma mark - lazy load
//重写get方法
- (MusicItem *)currentModel{
    
    
    _currentModel = [[MusicListHelper sharedHelp] itemWithIndex:_index];
    return _currentModel;
}

@end
