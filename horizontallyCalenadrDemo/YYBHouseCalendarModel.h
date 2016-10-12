//
//  YYBHouseCalandarModel.h
//  YiYiBnb
//
//  Created by Onein on 15/12/7.
//  Copyright © 2015年 haxwn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYBHouseCalendarModel : NSObject<NSMutableCopying,NSCopying>

@property(nonatomic, assign) NSInteger date;
@property(nonatomic, assign) NSInteger year;
@property(nonatomic, assign) NSInteger month;
@property(nonatomic, assign) NSInteger day;


/**
 *  将字典转换为模型
 *
 *  @param dict 数据字典
 *
 *  @return 返回模型
 */
+ (instancetype)modelWithDict:(NSDictionary *)dict;

/**
 *  初始化模型
 *
 *  @param year  年
 *  @param month 月
 *  @param day   日
 *
 *  @return 返回模型
 */
+ (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end





