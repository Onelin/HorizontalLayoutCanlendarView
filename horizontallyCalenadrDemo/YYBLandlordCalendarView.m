//
//  YYBLandlordCalendarView.m
//  YiYiBnb
//
//  Created by Onein on 16/2/24.
//  Copyright © 2016年 haxwn. All rights reserved.
//

#import "YYBLandlordCalendarView.h"
#import "YYBCalendarCell.h"
#import "YYBHouseCalendarModel.h"
#import "YYBCollectionViewHorizontalLayout.h"
#import "UIView+Add.h"

#define kheaderIdentifier @"kheaderIdentifier"
#define kcalendarCollectionCell @"kdalendarCollectionCell"
#define kFiveRowDateModelCount 35
#define kSixRowDateModelCount 42
#define kMaxDate   100000000
#define kCurrentDate [YYBLandlordCalendarView convertDateToYearOrMonthOrDay:[NSDate date] unitType:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay]

@interface YYBLandlordCalendarView() <UICollectionViewDelegate,UICollectionViewDataSource>
@end
@implementation YYBLandlordCalendarView

@synthesize dateArray = _dateArray;

- (instancetype)init
{
    if(self = [super init])
    {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return self.dateArray.count;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* tempArr = self.dateArray[section];
    return tempArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    //根据可重用标识符去缓存池找cell
    YYBCalendarCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcalendarCollectionCell forIndexPath:indexPath];
    
    //取模型数据
    NSArray* sectionArray = self.dateArray[indexPath.section];
    YYBHouseCalendarModel* model = sectionArray[indexPath.item];
    
    //判断 如果 是占位模型,显示 空
    if (model.day == 0) {
        [cell.dateLabel setText:@""];
    }
    else
    {
        //给item赋值
        cell.dateLabel.text = model.date == kCurrentDate ? @"今天" : [NSString stringWithFormat:@"%ld", model.day];
    }
    
    return cell;
}

#pragma mark delegate
//header 行高
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat height = 40;
    CGSize size = { 0, height };
    return size;
}

#pragma - mark 设置日期
/**
 *  设置今天日期加载日历控件
 */
- (void)setCalendarDate:(NSDate *)date
{
    //初始化日历组件
    NSDateComponents* components;
    //indentifier 设置为阳历
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone systemTimeZone]; //根据系统时区转换
    //根据日期,转换成日历格式
    components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    //从当前月开始遍历一年日期
    for (NSInteger m = components.month, y = components.year, i = 0; i <= 12; m++, i++) {
        
        components.year = y;
        components.month = m;
        components.day = 1;
        
        //根据当前年月日得到一个月的天数
        NSInteger totalDays = [YYBLandlordCalendarView totaldaysInMonth:[calendar dateFromComponents:components]];
        
        //存每个月多少天的数组
        NSMutableArray* monthArray = [NSMutableArray arrayWithCapacity:totalDays];
        
        //得到在 本月是周几
        NSInteger firstWeekDay = [YYBLandlordCalendarView firstWeekdayInThisMonth:[calendar dateFromComponents:components]];
        //添加每月第一周不属于本周的day
        [self addDateModel:monthArray withYear:y withMonth:m withDays:firstWeekDay];
        
        //遍历每个月 创建对应模型
        for (NSInteger d = components.day; d <= totalDays; d++) {
            //创建模型
            YYBHouseCalendarModel* calendarModel = [YYBHouseCalendarModel initWithYear:y month:m day:d];
            
            
            //添加到每个月对应的数组
            [monthArray addObject:calendarModel];
        }
        
        if(monthArray.count <= kFiveRowDateModelCount)
        {
            [self addDateModel:monthArray withYear:y withMonth:m withDays:kFiveRowDateModelCount];
        }
        else if(monthArray.count <= kSixRowDateModelCount)
        {
            [self addDateModel:monthArray withYear:y withMonth:m withDays:kSixRowDateModelCount];
        }
        
        //将每月数据添加到日历数据数组中
        [self.dateArray addObject:monthArray];
        
    }
    if(self.dateArray.count > 0)
    {
        [self.collectionView reloadData];
    }
}

//增加模型
- (void)addDateModel:(NSMutableArray *)monthArray withYear:(NSInteger)y withMonth:(NSInteger)m withDays:(NSInteger)days
{
    for (NSInteger u = monthArray.count; u < days; u++) {
        //创建模型
        
        YYBHouseCalendarModel* calendarModel = [YYBHouseCalendarModel initWithYear:y month:m day:0];
        //添加到每个月对应的数组
        [monthArray addObject:calendarModel];
    }
}



#pragma mark - config data
- (UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        //横向滚动
        YYBCollectionViewHorizontalLayout *horizontalLayout = [[YYBCollectionViewHorizontalLayout alloc] init];
        [_collectionView setCollectionViewLayout: horizontalLayout];
        CGFloat itemWidth = self.width / 7.0f;
        CGFloat itemHeight = self.height / 6.0f;
        horizontalLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        horizontalLayout.minimumInteritemSpacing = 0;
        horizontalLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:horizontalLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[YYBCalendarCell class] forCellWithReuseIdentifier:kcalendarCollectionCell];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma - mark 懒加载

- (NSMutableArray*)dateArray
{
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray new];
    }
    return _dateArray;
}

+ (NSInteger)convertDateToYearOrMonthOrDay:(NSDate *)date unitType:(NSCalendarUnit)calendarUnit
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSInteger result = 0;
    switch (calendarUnit) {
        case NSCalendarUnitYear:
            result = [components year];
            break;
        case NSCalendarUnitMonth:
            result = [components month];
            break;
        case NSCalendarUnitDay:
            result = [components day];
            break;
        default:
            result = [[NSString stringWithFormat:@"%ld%.2ld%.2ld", [components year], [components month], [components day]] integerValue];
            break;
    }
    
    return result;
}

+ (NSDate*)addMonth:(NSDate *)date month:(NSInteger)month
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:0];
    [components setMonth:month];
    [components setDay:0];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    return newDate;
}

/**
 *  根据当前日期月份得到本月有多少天
 *
 *  @param date 当前日期
 *
 *  @return 返回当前日期月有多少天
 */
+ (NSInteger)totaldaysInMonth:(NSDate*)date
{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

/**
 *  根据当前日期算出当前月第一周有多少天
 *
 *  @param date 当前日期
 *
 *  @return 当前月的第一周有多少天
 */
+ (NSInteger)firstWeekdayInThisMonth:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];
    NSDateComponents* comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate* firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

@end
