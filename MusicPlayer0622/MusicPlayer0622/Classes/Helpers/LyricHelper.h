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

@end
