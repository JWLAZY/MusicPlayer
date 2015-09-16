//
//  LyricHelper.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/16.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "LyricHelper.h"
#import "LyricItem.h"

@interface LyricHelper()

//可变数组,内部访问
@property (nonatomic,strong) NSMutableArray * allLyricMutable;

@end


@implementation LyricHelper

+ (LyricHelper *)sharedHelper{
    static LyricHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [LyricHelper new];
    });
    return helper;
}

//将lyricstring 转化为一个数组
- (void)initWithLyricString:(NSString *)lyricString{
    //先将字符串 根据换行符来划分
    NSArray *itemArray = [lyricString componentsSeparatedByString:@"\n"];
    
    for (NSString *itemString in itemArray) {
        
        
        
        //根据括号将时间和歌词分开
        NSArray *lyricArray = [itemString componentsSeparatedByString:@"]"];
        
        if ([lyricArray.firstObject length] < 1) {
            return;
        }
        
        //取正确的歌词时间
        NSString *timestr = [lyricArray.firstObject substringFromIndex:1];
        //将时间的分和秒分开
        NSArray *timeArray = [timestr componentsSeparatedByString:@":"];
        //计算秒数
        float time = [timeArray.firstObject integerValue] * 60 + [timeArray.lastObject integerValue];
        //创建歌词对象
        LyricItem *lyric = [LyricItem lyricWithTime:time lyric:lyricArray.lastObject];
        
        [self.allLyricMutable addObject:lyric];
    }
    
}

//外部访问歌词数组
- (NSArray *)allLyric{
    return [self.allLyricMutable mutableCopy];
}

-(NSMutableArray *)allLyricMutable{
    if (!_allLyricMutable) {
        _allLyricMutable = [NSMutableArray array];
    }
    return _allLyricMutable;
}

@end
