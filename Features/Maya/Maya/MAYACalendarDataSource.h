//
//  MAYACalendarDataSource.h
//  Maya
//
//  Created by pyretttt pyretttt on 16.01.2022.
//

#import <Foundation/Foundation.h>

@class MAYACalendarEntry;

NS_ASSUME_NONNULL_BEGIN

@interface MAYACalendarDataSource : NSObject
@property(nonatomic, copy, readonly)NSString *currentMonth;
@property(nonatomic, copy, readonly)NSString *currentYear;

- (void)goToPreviousCalendarUnit;

- (void)goToNextCalendarUnit;

- (NSArray<MAYACalendarEntry*> *)getEntriesToDisplay;

@end

NS_ASSUME_NONNULL_END
