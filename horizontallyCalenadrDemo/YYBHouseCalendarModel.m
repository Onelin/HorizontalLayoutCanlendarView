//
//  YYBHouseCalandarModel.m
//  YiYiBnb
//
//  Created by Onein on 15/12/7.
//  Copyright © 2015年 haxwn. All rights reserved.
//

#import "YYBHouseCalendarModel.h"
#import <objc/runtime.h>

@implementation YYBHouseCalendarModel

/**
 *  将字典转换为模型
 *
 *  @param dict 数据字典
 *
 *  @return 返回模型
 */
+ (instancetype)modelWithDict:(NSDictionary*)dict
{
    id obj = [[self alloc] init];

    //    [obj setValuesForKeysWithDictionary:dict];
    NSArray* properties = [self propertyList];

    // 遍历属性数组
    for (NSString* key in properties) {
        // 判断字典中是否包含这个key
        if (dict[key] != nil) {
            // 使用 KVC 设置数值
            [obj setValue:dict[key] forKeyPath:key];
        }
    }
    return obj;
}

/**
 *  初始化模型
 *
 *  @param year  年
 *  @param month 月
 *  @param day   日
 *
 *  @return 返回模型
 */
+ (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    YYBHouseCalendarModel* model = [self new];
    model.year = year;
    model.month = month;
    model.day = day;
    model.date = [[NSString stringWithFormat:@"%ld%.2ld%.2ld", (long)year, month, day] integerValue];

    return model;
}

/**
 *  动态获取类的成员变量
 *
 *  @return 返回变量数组
 */
+ (NSArray*)propertyList
{

    // 1. 获取`类`的属性
    /**
    17      参数
    18      1> 类
    19      2> 属性的计数指针
    20      */
    unsigned int count = 0;
    // 返回值是所有属性的数组 objc_property_t
    objc_property_t* list = class_copyPropertyList([self class], &count);

    NSMutableArray* arrayM = [NSMutableArray arrayWithCapacity:count];

    // 遍历数组
    for (unsigned int i = 0; i < count; ++i) {
        // 获取到属性
        objc_property_t pty = list[i];

        // 获取属性的名称
        const char* cname = property_getName(pty);

        [arrayM addObject:[NSString stringWithUTF8String:cname]];
    }

    // 释放属性数组
    free(list);

    return arrayM.copy;
}

- (id)copyWithZone:(NSZone *)zone {
    YYBHouseCalendarModel *model = [[YYBHouseCalendarModel allocWithZone:zone] init];
    model.year = self.year;
    model.month = self.month;
    model.day = self.day;
    model.date = self.date;
    return model;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self copyWithZone:zone];
}

@end