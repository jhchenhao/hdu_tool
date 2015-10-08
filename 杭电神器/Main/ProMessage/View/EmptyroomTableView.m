//
//  EnptyroomTableView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/2.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "EmptyroomTableView.h"

@implementation EmptyroomTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emptyroom_bg"]];
        bgView.frame = self.bounds;
        self.backgroundView = bgView;
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.emptyRooms.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roomCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"roomCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"第%@教学楼 %@",self.bulidingIndex,self.emptyRooms[indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = self.textColor;
    return cell;
}

@end
