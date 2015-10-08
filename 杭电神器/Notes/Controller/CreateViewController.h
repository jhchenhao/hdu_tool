//
//  CreateViewController.h
//  项目3
//
//  Created by mac on 15/10/3.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

typedef void(^loadTableBlock)(void);
typedef void(^loadNoteBlock)(NoteModel *model);
@interface CreateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *addImageB;


@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (nonatomic, strong) NoteModel *note;
@property (nonatomic, copy) loadTableBlock block;
@property (nonatomic, copy) loadNoteBlock noteBlock;

@end
