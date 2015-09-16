//
//  LyricItem.h
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/16.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricItem : NSObject

//歌词时间
@property (nonatomic,assign) float time;
//歌词内容
@property (nonatomic,strong) NSString * lyric;


- (instancetype)initWithTime:(float)time lyric:(NSString *)lyricString;

+ (instancetype)lyricWithTime:(float)time lyric:(NSString *)lyric;



@end
