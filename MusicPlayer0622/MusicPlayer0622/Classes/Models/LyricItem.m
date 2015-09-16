//
//  LyricItem.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/16.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "LyricItem.h"

@implementation LyricItem


- (instancetype)initWithTime:(float)time lyric:(NSString *)lyricString{
    if (self = [super init]) {
        self.time = time;
        self.lyric = lyricString;
    }
    return self;
}

+ (instancetype)lyricWithTime:(float)time lyric:(NSString *)lyric{
    return [[self alloc] initWithTime:time lyric:lyric];
}

@end
