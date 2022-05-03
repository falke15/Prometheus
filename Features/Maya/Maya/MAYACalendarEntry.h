//
//  MAYACalendarEntry.h
//  Maya
//
//  Created by pyretttt pyretttt on 16.01.2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAYACalendarEntry : NSObject
@property(copy, nonatomic)NSString *day;
@property(copy, nonatomic)NSString *month;
@property(copy, nonatomic)NSString *year;
@property(nonatomic, assign)BOOL isWeekday;

- (instancetype)initWithDay:(NSString *)day month:(NSString *)month year:(NSString*) year;

@end

NS_ASSUME_NONNULL_END
