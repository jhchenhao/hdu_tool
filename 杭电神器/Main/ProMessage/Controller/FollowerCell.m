//
//  FollowerCell.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/4.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "FollowerCell.h"

@implementation FollowerCell

- (void)setFollower:(FollowerModel *)follower{
    if (_follower != follower) {
        _follower = follower;
        self.nickNameLabel.text = self.follower.followerName;
        self.contentLabel.text = self.follower.followerContent;
        self.contentLabel.numberOfLines = 0;
        
        self.supportLabel.text = [NSString stringWithFormat:@"%@",self.follower.followerSupport];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.follower.followerThumbnail]];
        self.iconView.layer.cornerRadius = 15;
        self.iconView.layer.masksToBounds = YES;
//        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kGardenSupport];
//        for (NSInteger i = 0; i < dic.count; i ++) {
//            NSNumber *num = dic[self.follower.objectid];
//            if ([num boolValue]) {
//                [self.supportButton setImage:[UIImage imageNamed:@"support_s"] forState:UIControlStateNormal];
//                self.supportButton.enabled = NO;
//            }
//        }
//       
    }
    
}

- (IBAction)supportButtonAction:(UIButton *)sender {
    NSString *objId = self.follower.objectid;
    NSNumber *num = self.follower.followerSupport;
    NSInteger supportCount = [num integerValue];
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"HduGarden"  objectId:objId];
    NSNumber *newNum = [[NSNumber alloc]initWithInteger:(supportCount + 1)];
    [bmobObject setObject:newNum forKey:@"followerSupport"];
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //修改成功后的动作
            NSLog(@"点赞成功");
            self.supportLabel.text = [NSString stringWithFormat:@"%ld",supportCount + 1];
            [self.supportButton setImage:[UIImage imageNamed:@"support_s"] forState:UIControlStateNormal];
            self.supportButton.enabled = NO;
//            //同步到用户中心
//            //先拿出来
//            NSMutableDictionary *supportDic = [NSMutableDictionary dictionary];
//            supportDic = [[NSUserDefaults standardUserDefaults]objectForKey:kGardenSupport];
//            BOOL isSupported = YES;
//            [supportDic setObject:[NSNumber numberWithBool:isSupported] forKey:objId];
//            [[NSUserDefaults standardUserDefaults]setObject:supportDic forKey:kGardenSupport];
//            [[NSUserDefaults standardUserDefaults]synchronize];
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];

    
}



@end
