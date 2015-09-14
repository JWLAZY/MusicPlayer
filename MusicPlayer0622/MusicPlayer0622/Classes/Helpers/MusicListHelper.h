//
//  MusicListHelper.h
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicItem.h"

@interface MusicListHelper : NSObject

#pragma mark - 声明属性

@property (nonatomic,strong) NSArray * allMusic;

#pragma mark - 声明方法
+ (MusicListHelper *)sharedHelp;


/**
 *  请求数据
 *
 *  @param result 请求数据成功后执行的block
 */
- (void)requestAllMusicWithFinish:(void (^)())result;
/**
 *  根据一个index 返回一个model
 *
 *  @param index <#index description#>
 *
 *  @return <#return value description#>
 */
- (MusicItem *)itemWithIndex:(NSInteger)index;
@end
