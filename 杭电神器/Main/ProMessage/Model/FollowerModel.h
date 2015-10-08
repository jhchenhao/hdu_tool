//
//  FollowerModel.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/5.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseModel.h"

@interface FollowerModel : BaseModel

@property (nonatomic,copy) NSString *followerThumbnail;
@property (nonatomic,copy) NSString *followerName;
@property (nonatomic,copy) NSString *followerContent;
@property (nonatomic,strong) NSNumber *followerSupport;
@property (nonatomic,copy) NSString *objectid;

@end
