//
//  BalanceViewController.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/4.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceCell.h"
#import "TGEasyAttributeText.h"

@interface BalanceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSDictionary *balanceDic;
@property (nonatomic,copy) NSString *balanceNow;

@end
