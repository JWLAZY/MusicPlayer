//
//  MusicItemCell.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "MusicItemCell.h"
#import "UIImageView+WebCache.h"
#import "MusicItem.h"

@implementation MusicItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(MusicItem *)model{
    //更新UI
    [self.img4MusicPic sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.lab4Name.text = model.name;
    self.lab4singerName.text = model.singer;
}

@end
