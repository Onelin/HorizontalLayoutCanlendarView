//
//  YYBCalendarCell.m
//  YiYiBnb
//
//  Created by Onein on 15/10/24.
//  Copyright © 2015年 haxwn. All rights reserved.
//

#import "YYBCalendarCell.h"

@implementation YYBCalendarCell

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];

        [self addSubview:_dateLabel];
       
    }
    return _dateLabel;
}
@end
