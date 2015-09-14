//
//  MusicListHelper.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "MusicListHelper.h"
#import "MusicItem.h"

@interface MusicListHelper ()

//存放model的可变数组
@property (nonatomic,strong) NSMutableArray * allMusicMutable;

@end


@implementation MusicListHelper

+ (MusicListHelper *)sharedHelp{
    static MusicListHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [MusicListHelper new];
    });
    return helper;
}

- (void)requestAllMusicWithFinish:(void (^)())result{
    
    //进入子线程进行数据请求,数据解析
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:kMusicList]];
        
        //解析数据
        for (NSDictionary *dic in array) {
            MusicItem *item = [MusicItem new];
            //利用kvc 创建model
            [item setValuesForKeysWithDictionary:dic];
            [self.allMusicMutable addObject:item];
            
        }
        
        NSLog(@"%@",array);
        
        
        //数据请求解析完成后回到主线程去执行block
        dispatch_async(dispatch_get_main_queue(), ^{
            result();
        });
    });
}
- (MusicItem *)itemWithIndex:(NSInteger)index{
    return self.allMusicMutable[index];
}

#pragma mark - lazy load
- (NSMutableArray *)allMusicMutable{
    if (_allMusicMutable == nil) {
        _allMusicMutable = [NSMutableArray array];
    }
    return _allMusicMutable;
}
//返回不可变数组
- (NSArray *)allMusic{
    return [_allMusicMutable mutableCopy];
}

@end
