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
#import "LyricHelper.h"
#import "LyricItem.h"


@interface MusicPlayingController ()<AudioPlayerDelegate,UITableViewDataSource>
- (IBAction)disMissAction:(id)sender;
- (IBAction)startOrPuase:(id)sender;
- (IBAction)proviousAction:(id)sender;
- (IBAction)nextAction:(id)sender;


//当前播放音乐的模型
@property (nonatomic,strong) MusicItem * currentModel;

@property (weak, nonatomic) IBOutlet UIImageView *img4MusicPic;
@property (weak, nonatomic) IBOutlet UILabel *lab4playedTime;
@property (weak, nonatomic) IBOutlet UILabel *lab4LastTime;

@property (weak, nonatomic) IBOutlet UISlider *slider4Time;
//歌词的tableView
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;

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
    
    [self.slider4Time addTarget:self action:@selector(timeSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    //注册cell
    [self.lyricTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
 
    [[LyricHelper sharedHelper] initWithLyricString:self.currentModel.lyric];
    //在开始播放后要重新去加载数据
    [self.lyricTableView reloadData];
}

#pragma mark - 私有方法
- (void)updateUI{
    
    //如果换歌的话,就让图片重新归位
    self.img4MusicPic.transform = CGAffineTransformMakeRotation(0);
    
    //可以根据获取到当前播放的音乐model 更新UI
    [self.img4MusicPic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    
    //更新slider 的进度
    
    //改变进度条的最大值
    self.slider4Time.maximumValue = [self.currentModel.duration floatValue] / 1000;
    
}
//时间滑条拖动事件
- (void)timeSliderAction:(UISlider *)sender{
    NSLog(@"%f",sender.value);
    
    [[AudioPlayer sharedPlayer] seekToTime:sender.value];
    
}

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

- (IBAction)proviousAction:(id)sender {
    _currentIndex--;
    
    if (_currentIndex < 0) {
        _currentIndex = [MusicListHelper sharedHelp].allMusic.count - 1;
    }
    
    [self startPlay];
}

- (IBAction)nextAction:(id)sender {
    _currentIndex++;
    
    if (_currentIndex >= [MusicListHelper sharedHelp].allMusic.count) {
        _currentIndex = 0;
    }
    
    [self startPlay];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricHelper sharedHelper].allLyric.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    LyricItem *item = [LyricHelper sharedHelper].allLyric[indexPath.row];
    cell.textLabel.text = item.lyric;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - AudioPlayerDelegate
//回调时间 : progress 当前播放的秒数
-(void)audioplayerPlayWith:(AudioPlayer *)audioplayer Progress:(float)progress{
    NSLog(@"%f",progress);
    
    //旋转图片
    self.img4MusicPic.transform = CGAffineTransformRotate(self.img4MusicPic.transform, M_PI / 100);
    
    //更新时间
    
    //已经播放时间
    int minutes = (int)progress / 60;
    int seconds = (int)progress % 60;
    
    float lastTime = [_currentModel.duration floatValue] / 1000 - progress;
    //剩余时间
    int minutes2 = (int)lastTime / 60;
    int seconds2 = (int) lastTime % 60;
    
    self.lab4playedTime.text = [NSString stringWithFormat:@"%d:%d",minutes,seconds];
    
    self.lab4LastTime.text = [NSString stringWithFormat:@"%d:%d",minutes2,seconds2];
    
    //更新进度条
    self.slider4Time.value = progress;
    
    //滑动到哪一行不确定
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[LyricHelper sharedHelper] indexOfTime:progress] inSection:0];
    [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}
- (void)audioplayerDidFinishItem:(AudioPlayer *)audioplayer{
    [self nextAction:nil];
}

#pragma mark - lazy load
//重写get方法
- (MusicItem *)currentModel{
    
    ///TODO: 更新一个大大的bug!
    //这儿的index 不更改,下一首后(_currentIndex发生变化了.但是_index没有发生变化),下次进入这个页面时会先比较_index 和 _currentIndex ,会不一样,就回重新放歌
    _index = _currentIndex;
    _currentModel = [[MusicListHelper sharedHelp] itemWithIndex:_currentIndex];
    return _currentModel;
}

@end
