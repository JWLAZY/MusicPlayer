//
//  LyricHelper.h
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/16.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricHelper : NSObject


+ (LyricHelper *)sharedHelper;


- (void)initWithLyricString:(NSString *)lyricString;

//外部访问歌词数组
- (NSArray *)allLyric;

//根据时间返回当前播放歌词在数组中的位置
- (NSInteger)indexOfTime:(float)time;

@end
