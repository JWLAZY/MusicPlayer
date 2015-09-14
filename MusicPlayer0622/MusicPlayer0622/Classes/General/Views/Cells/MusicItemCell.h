//
//  MusicItemCell.h
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicItem;
@interface MusicItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img4MusicPic;

@property (weak, nonatomic) IBOutlet UILabel *lab4Name;
@property (weak, nonatomic) IBOutlet UILabel *lab4singerName;

@property (nonatomic,strong) MusicItem * model;

@end
