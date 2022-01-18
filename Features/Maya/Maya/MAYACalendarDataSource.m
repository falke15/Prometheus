//
//  MAYACalendarDataSource.m
//  Maya
//
//  Created by pyretttt pyretttt on 16.01.2022.
//

#import <Foundation/Foundation.h>
#import "MAYACalendarDataSource.h"
#import "MAYACalendarEntry.h"

typedef NSDate* (^DateFactory)(NSInteger day, NSInteger month, NSInteger year);

typedef NS_ENUM(NSInteger, MAYAWeekDay)
{
    MAYAWeekDayMonday = 2,
    MAYAWeekDayTuesday = 3,
    MAYAWeekDayWednesday = 4,
    MAYAWeekDayThursday = 5,
    MAYAWeekDayFriday = 6,
    MAYAWeekDaySaturday = 7,
    MAYAWeekDaySunday = 1
};

@interface MAYACalendarDataSource()

@property(nonatomic, copy, readonly)DateFactory createDate;
@property(nonatomic, copy, readonly)NSTimeZone *currentTimeZone;
@property(nonatomic, copy, readonly)NSCalendar *calendarService;
@property(nonatomic, copy)NSDateComponents *currentComponents;

@end

@implementation MAYACalendarDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        __weak typeof(self) weakSelf = self;
        _createDate = ^NSDate *(NSInteger day, NSInteger month, NSInteger year) {
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.calendar = [weakSelf calendarService];
            dateComponents.year = year;
            dateComponents.month = month;
            dateComponents.day = day;
            dateComponents.hour = 12;
            dateComponents.timeZone = [weakSelf currentTimeZone];
            
            return [dateComponents date];
        };
        _calendarService = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
        _currentTimeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
        // Using setter to change day and update current info
        self.currentComponents = [self componentsFromDate:[NSDate new]];
        [self updateCurrentInfo];
        
        NSArray<NSDate*>* dates = [self getDatesInMonth:@1 year:@2022];
        NSLog(@"array : %@",  dates);
        
        NSArray<MAYACalendarEntry*> *entriesToDisplay = [self getEntriesToDisplay];
        NSLog(@"etries to display : %@",  entriesToDisplay);
    }
    
    return self;
}

- (void)setCurrentMonthComponents:(NSDateComponents *)currentDate
{
    NSDateComponents * copy = [currentDate copy];
    copy.day = 1;
    _currentComponents = copy;
}

- (void)goToNextCalendarUnit
{
    NSDateComponents * nextUnitComponents;
    NSDate *currentDate = [self dateFromComponents:_currentComponents];
    nextUnitComponents = [self componentsFromDate:[_calendarService dateByAddingUnit:NSCalendarUnitMonth
                                                                               value:1
                                                                              toDate:currentDate
                                                                             options:NSCalendarMatchStrictly]];
    
    _currentComponents = nextUnitComponents;
    [self updateCurrentInfo];
}

- (void)goToPreviousCalendarUnit
{
    NSDateComponents * prevUnitComponents;
    NSDate *currentDate = [self dateFromComponents:_currentComponents];
    prevUnitComponents = [self componentsFromDate:[_calendarService dateByAddingUnit:NSCalendarUnitMonth
                                                                               value:-1
                                                                              toDate:currentDate
                                                                             options:NSCalendarMatchStrictly]];
    _currentComponents = prevUnitComponents;
    [self updateCurrentInfo];
}



- (NSArray<MAYACalendarEntry*> *)getEntriesToDisplay
{
    NSMutableArray<MAYACalendarEntry*> *result = [[self weekdaysEntries] mutableCopy];
    NSArray<NSDateComponents*> *itemsToDisplay = [self getDatesToDisplay];
    for (NSDateComponents *item in itemsToDisplay)
    {
        MAYACalendarEntry *entry = [[MAYACalendarEntry alloc] initWithDay:[@(item.day) stringValue]
                                                                    month:[@(item.month) stringValue]
                                                                     year:[@(item.year) stringValue]];
        [result addObject:entry];
    }
    
    return [result copy];
}

- (NSArray<NSDateComponents*> *)getDatesToDisplay
{
    NSDateComponents *currentDateComponents = [_currentComponents copy];
    NSArray<NSDate *> *currentMonthDates = [self getDatesInMonth:[[NSNumber alloc] initWithInteger:currentDateComponents.month]
                                                              year:[[NSNumber alloc] initWithInteger:currentDateComponents.year]];
    
    // Считаем сколько нужно добавить компонентов из других месяцов
    NSDateComponents *firstDayOfMonth = [self componentsFromDate:currentMonthDates.firstObject];
    int daysToPrepend = (int)([self normalizedWeekDay:firstDayOfMonth.weekday] - 1);
    NSDateComponents *lastDayInCurrentMonthDateComponents = [self componentsFromDate:[currentMonthDates lastObject]];
    int daysToAppend = (int)(7 - [self normalizedWeekDay:lastDayInCurrentMonthDateComponents.weekday]);
    
    // Получаем даты из следующего месяца
    NSDate *nextMonthDate = [self dateFromComponents:currentDateComponents];
    nextMonthDate = [_calendarService dateByAddingUnit:NSCalendarUnitMonth
                                             value:1
                                            toDate:nextMonthDate
                                           options:NSCalendarMatchStrictly];
    NSDateComponents *nextMonthComponents = [self componentsFromDate:nextMonthDate];
    NSArray<NSDate *> *nextMonthDates = [self getDatesInMonth:[[NSNumber alloc] initWithInteger:nextMonthComponents.month]
                                                              year:[[NSNumber alloc] initWithInteger:nextMonthComponents.year]];
    
    // Получаем даты из предыдущего месяца
    NSDate *prevMonthDate = [self dateFromComponents:currentDateComponents];
    prevMonthDate = [_calendarService dateByAddingUnit:NSCalendarUnitMonth
                                             value:-1
                                            toDate:prevMonthDate
                                           options:NSCalendarMatchStrictly];
    NSDateComponents *prevMonthComponents = [self componentsFromDate:prevMonthDate];
    NSArray<NSDate *> *prevMonthDates = [self getDatesInMonth:[[NSNumber alloc] initWithInteger:prevMonthComponents.month]
                                                              year:[[NSNumber alloc] initWithInteger:prevMonthComponents.year]];
    
    // Промежуточный список всех дат с предыдущим и последующим месяцев
    NSMutableArray<NSDate *> *extendedDatesToDisplay = [currentMonthDates mutableCopy];
    
    // Добавляем даты из предыдущего месяцеса
    for(int daysToAdd = 0; daysToAdd != daysToPrepend; daysToAdd++)
    {
        NSUInteger prevMonthItemsCount = [prevMonthDates count];
        [extendedDatesToDisplay insertObject:prevMonthDates[prevMonthItemsCount - 1 - daysToAdd] atIndex:0];
    }
    // Добавляем даты из следующего месяцеса
    for(int dayToAdd = 0; dayToAdd != daysToAppend; dayToAdd++)
    {
        [extendedDatesToDisplay addObject:nextMonthDates[dayToAdd]];
    }
    
    // Формируем результат из компонентов
    NSMutableArray<NSDateComponents *> *result = [NSMutableArray new];
    for (NSDate *date in extendedDatesToDisplay)
    {
        [result addObject:[self componentsFromDate:date]];
    }
    
    return result;
}

- (NSArray<NSDate*> *)getDatesInMonth:(NSNumber *)month year:(NSNumber *)year
{
    NSDate *date = self.createDate(1, [month integerValue], [year integerValue]);
    NSRange daysRange = [_calendarService rangeOfUnit:NSCalendarUnitDay
                                               inUnit:NSCalendarUnitMonth
                                              forDate:date];
    
    NSMutableArray<NSDate*> *datesInMonth = [NSMutableArray new];
    for (int day = 1; day <= daysRange.length; day++)
    {
        [datesInMonth addObject: self.createDate(day, [month integerValue], [year integerValue])];
    }
    
    return [datesInMonth copy];
}

- (void)updateCurrentInfo
{
    _currentMonth = [@(_currentComponents.month) stringValue];
    _currentYear = [@(_currentComponents.year) stringValue];
}


#pragma mark - Helpers

- (NSArray<MAYACalendarEntry *> *)weekdaysEntries
{
    NSMutableArray<MAYACalendarEntry *> *result = [NSMutableArray new];
    NSArray* weekdays = @[@"Пн", @"Вт", @"Ср", @"Чт", @"Пт", @"Сб", @"Вс"];
    for (NSString *weekday in weekdays)
    {
        MAYACalendarEntry *entry = [[MAYACalendarEntry alloc] initWithDay:weekday
                                                                    month:@""
                                                                     year:@""];
        entry.isWeekday = YES;
        [result addObject:entry];
    }
    
    return result;
}

- (NSInteger)normalizedWeekDay:(NSInteger)weekDay
{
    switch (weekDay) {
        case MAYAWeekDayMonday:
            return MAYAWeekDaySunday;
        case MAYAWeekDayTuesday:
            return MAYAWeekDayMonday;
        case MAYAWeekDayWednesday:
            return MAYAWeekDayTuesday;
        case MAYAWeekDayThursday:
            return MAYAWeekDayWednesday;
        case MAYAWeekDayFriday:
            return MAYAWeekDayThursday;
        case MAYAWeekDaySaturday:
            return MAYAWeekDayFriday;
        case MAYAWeekDaySunday:
            return MAYAWeekDaySaturday;
        default:
            return 0;
    }
}

- (NSDateComponents*)componentsFromDate:(NSDate *)date
{
    NSDateComponents *components = [_calendarService components:NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    components.timeZone = _currentTimeZone;
    components.calendar = _calendarService;
    
    return components;
}

- (NSDate*)dateFromComponents:(NSDateComponents *)components
{
    components.timeZone = _currentTimeZone;
    return [_calendarService dateFromComponents:components];
}


@end
