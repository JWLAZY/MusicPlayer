//
//  MusicPlayingController.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/15.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "MusicPlayingController.h"

@interface MusicPlayingController ()
- (IBAction)disMissAction:(id)sender;

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
