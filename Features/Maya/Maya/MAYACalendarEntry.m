//
//  MAYACalendarEntry.m
//  Maya
//
//  Created by pyretttt pyretttt on 16.01.2022.
//

#import "MAYACalendarEntry.h"

@implementation MAYACalendarEntry

- (instancetype)initWithDay:(NSString *)day month:(NSString *)month year:(NSString *)year
{
    self = [super init];
    
    if (self)
    {
        _day = [day copy];
        _month = [month copy];
        _year = [year copy];
        _isWeekday = NO;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"day - %@, month - %@, year - %@", _day, _month, _year];
}

@end
