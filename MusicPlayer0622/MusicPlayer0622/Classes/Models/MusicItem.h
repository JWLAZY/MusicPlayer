//
//  MusicItem.h
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicItem : NSObject

//歌曲地址
@property (nonatomic,strong) NSString * mp3Url;
//歌曲ID
@property (nonatomic,strong) NSString * ID;
//歌曲名字
@property (nonatomic,strong) NSString * name;
//歌曲图片地址
@property (nonatomic,strong) NSString * picUrl;
//模糊图地址
@property (nonatomic,strong) NSString * blurPicUrl;
//专辑名字
@property (nonatomic,strong) NSString * album;
//歌手
@property (nonatomic,strong) NSString * singer;
//持续时间
@property (nonatomic,strong) NSString * duration;
//歌手名字
@property (nonatomic,strong) NSString * artists_name;

@property (nonatomic,strong) NSString * lyric;


@end
