//
//  NotesTableView.m
//  项目3
//
//  Created by mac on 15/10/2.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NotesTableView.h"
#import "NoteTableViewCell.h"
#import "NSString+CalculateHeight.h"
#import "UIView+NavigationController.h"
#import "DetailViewController.h"
#import "NoteDB.h"

@implementation NotesTableView

//重写自定义方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[NoteTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.note = _datasAry[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //设置单元格高度
    NoteModel *note = _datasAry[indexPath.row];
    if (note.image) {
        //有图片则为100
        return 100;
    }
    else
    {
        //没有图片计算
        CGFloat width = kScreenWidth -10;
        CGFloat titleHeight = [note.title getHeightofFont:[UIFont boldSystemFontOfSize:20] width:width];

        //时间
        CGFloat timeHeight = [note.time getHeightofFont:[UIFont systemFontOfSize:10] width:width];
        //内容
        CGFloat contextHeight = [note.context getHeightofFont:[UIFont systemFontOfSize:15] width:width];
        
        CGFloat totalHeight = titleHeight + timeHeight + contextHeight + 20;
        if (totalHeight > 100) {
            return 100;
        }
        else
        {
            return totalHeight;
        }
    }
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.note = _datasAry[indexPath.row];
    //点击push到详情界面
    [self.NavigationController pushViewController:detailVC animated:YES];
    
}


//单元格左滑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除那一行数据
        //移除数据库数据
        NoteModel *note = _datasAry[indexPath.row];
        [NoteDB removeNote:note];
        //移除数组数据
        [_datasAry removeObjectAtIndex:indexPath.row];
        //刷新ui
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



@end
