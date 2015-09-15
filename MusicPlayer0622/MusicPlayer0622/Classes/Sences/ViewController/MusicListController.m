//
//  MusicListController.m
//  MusicPlayer0622
//
//  Created by 郑建文 on 15/9/14.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "MusicListController.h"
#import "MusicItemCell.h"
#import "MusicListHelper.h"
#import "MusicPlayingController.h"

@interface MusicListController ()
//因为播放页面一直存在,所以做成一个属性直接放在列表页面
@property (nonatomic,strong) MusicPlayingController * playingController;
@end

@implementation MusicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicItemCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[MusicListHelper sharedHelp] requestAllMusicWithFinish:^{
        NSLog(@"请求数据完成");
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MusicListHelper sharedHelp].allMusic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 119;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    MusicItem *item = [[MusicListHelper sharedHelp] itemWithIndex:indexPath.row];
    cell.model = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //这个就是将播放页面显示出来
    self.playingController.index = indexPath.row;
    
    [self showDetailViewController:self.playingController sender:nil];
}


#pragma mark - 点击事件
- (IBAction)showPlayingVC:(id)sender {
    [self showDetailViewController:self.playingController sender:nil];
}

#pragma mark - lazy load
- (MusicPlayingController *)playingController{
    if (_playingController == nil) {
        _playingController = [MusicPlayingController shareController];
    }
    return  _playingController;
}

@end
