//
//  ViewController.m
//  horizontallyCalenadrDemo
//
//  Created by Onein on 10/10/16.
//  Copyright © 2016 haxwn. All rights reserved.
//

#import "ViewController.h"
#import "YYBLandlordCalendarView.h"
#import "UIView+Add.h"
#import "YYBCollectionViewHorizontalLayout.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabBarHeight           49.0f

@interface ViewController ()
@property (nonatomic, strong) YYBLandlordCalendarView *calendarView;
//头部周视图
@property (nonatomic, strong) UIView* weekView;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //日历
    [self.view addSubview:self.weekView];
    [self.view addSubview:self.calendarView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.calendarView setCalendarDate:[NSDate date]];
    
    YYBCollectionViewHorizontalLayout *horizontalLayout =(YYBCollectionViewHorizontalLayout *)self.calendarView.collectionView.collectionViewLayout;
    horizontalLayout.dateArray = self.calendarView.dateArray;
}

- (YYBLandlordCalendarView *)calendarView
{
    if(_calendarView == nil)
    {
        CGFloat collectionOriginX = 12;
        CGFloat collectionOriginY = self.weekView.bottom;
        CGFloat collectionWidth = kScreenWidth - 24;
        CGFloat collectionHeight = collectionWidth + 20;
        _calendarView = [[YYBLandlordCalendarView alloc] initWithFrame:CGRectMake(collectionOriginX, collectionOriginY, collectionWidth, collectionHeight)];
        _calendarView.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _calendarView;
}

- (UIView*)weekView
{
    if (_weekView == nil) {
        CGFloat weekOriginX = 12;
        CGFloat weekOriginY = kScreenHeight * 0.5 - kScreenHeight * 0.35;
        CGFloat weekWidth = kScreenWidth - weekOriginX * 2;
        CGFloat weekHeight = 28;
        CGFloat minusOriginX = 12;
        CGFloat addWidth = 50;
        
        _weekView = [[UIView alloc] initWithFrame:CGRectMake(weekOriginX - minusOriginX, weekOriginY, weekWidth + addWidth, weekHeight)];
        
        NSArray* weekDay = @[ @"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
        for (int i = 0; i < weekDay.count; i++) {
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(weekWidth * i / 7 + weekOriginX, 0, weekWidth / 7, weekHeight)];
            label.text = (NSString*)weekDay[i];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [_weekView addSubview:label];
        }
    }
    return _weekView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
