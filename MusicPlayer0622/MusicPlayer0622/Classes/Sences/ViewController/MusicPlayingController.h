//
//  MusicPlayingController.h
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/15.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayingController : UIViewController

#pragma mark - 声明属性
//上个页面传过来的,要播放的音乐的索引
@property (nonatomic,assign) NSInteger index;

+ (MusicPlayingController *)shareController;

@end
