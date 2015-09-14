//
//  MusicItem.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "MusicItem.h"

@implementation MusicItem

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }else{
        NSLog(@"kvc错误,key:%@",key);
    }
    
}

@end
