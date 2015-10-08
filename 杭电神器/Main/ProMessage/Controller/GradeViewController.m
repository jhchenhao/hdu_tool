//
//  GradeViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "GradeViewController.h"

@interface GradeViewController (){
    iCarousel *_carousel;
    NSArray *_gradeData;
    UIPickerView *_pickView;

}

@end

@implementation GradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"忍住不看";
    [self _createView ];
    [self _loadMyGradeData];
}

- (void)_createView{
    //创送带
    _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_carousel];
    _carousel.type = iCarouselTypeWheel;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    //选择器
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30,kScreenWidth, 150)];
    _pickView.dataSource = self;
    _pickView.delegate = self;
    [self.view addSubview:_pickView];

    
}

#pragma mark-加载借阅数据
- (void)_loadMyGradeData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [MyNetWorkQuery AFrequestData:person_grade HTTPMethod:@"POST" params:params completionHandle:^(id result) {
        NSArray *listArray = result[@"list"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dataDic in listArray) {
            GradeModel *gradeModel = [[GradeModel alloc]initWithDataDic:dataDic];
            [tempArray addObject:gradeModel];
        }
        _gradeData = tempArray;
        [_carousel reloadData];
        [_pickView reloadAllComponents];
        
        
    } errorHandle:nil];
    
}

#pragma mark-传送带代理和数据源
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _gradeData.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    //设置tag复用
    GradeDetailView *gradeView = nil;
    if (view == nil){
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"grade_bg"];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GradeDetailView" owner:self options:nil];
        gradeView = [nib lastObject];
        gradeView.backgroundColor = [UIColor clearColor];
        gradeView.tag = 1;
        [view addSubview:gradeView];
    }else{
        gradeView = (GradeDetailView *)[view viewWithTag:1];
    }
    gradeView.gradeModel = _gradeData[index];
    return view;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(__unused UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{

    if (_gradeData.count > 0) {
        [_pickView selectRow:carousel.currentItemIndex inComponent:0 animated:YES];
    }
}



#pragma mark-选择器代理和数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _gradeData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    GradeModel *model = _gradeData[row];
    return model.KCMC;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [_carousel scrollToItemAtIndex:row animated:YES];
}

@end
