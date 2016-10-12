//
//  YYBLandlordCalendarView.h
//  YiYiBnb
//
//  Created by Onein on 16/2/24.
//  Copyright © 2016年 haxwn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBCalendarCell.h"
#import "YYBHouseCalendarModel.h"

@interface YYBLandlordCalendarView : UIView

//数据源数组
@property (nonatomic, strong) NSMutableArray* dateArray;
//日历视图
@property (nonatomic, strong) UICollectionView* collectionView;

/**
 *  设置今天日期加载日历控件
 */
- (void)setCalendarDate:(NSDate *)date;
@end
