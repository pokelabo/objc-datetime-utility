//
//  TimeGeneratorCronIterator.m
//  TimeGeneratorApp
//
//  Created by HANAI Tohru on 2013/07/03.
//  Copyright (c) 2013年 Pokelabo, INC. All rights reserved.
//

#import "TimeGeneratorCronIterator.h"

#import <NSDate+MTDates.h>

@implementation TimeGeneratorCronIterator {
    NSArray *_sourceMonths;
    NSArray *_sourceDays;
    NSArray *_sourceHours;
    NSArray *_sourceMinutes;
    NSArray *_validDayOfWeeks;
    int _indexMonths;
    int _indexDays;
    int _indexHours;
    int _indexMinutes;
    NSDateComponents *_dateComponents;
    NSDate *_date;
}

- (id)initWithSourceMonths:(NSArray *)sourceMonths
                sourceDays:(NSArray *)sourceDays
               sourceHours:(NSArray *)sourceHours
             sourceMinutes:(NSArray *)sourceMinutes {
    self = [super init];
    if (!self) return nil;

    _sourceMonths = sourceMonths;
    _sourceDays = sourceDays;
    _sourceHours = sourceHours;
    _sourceMinutes = sourceMinutes;

    return self;
}

- (NSDate *)date {
    return _date;
}

//
// forward indice for the value of `date`.
//
- (void)forwardFor:(NSDate *)date {
    _indexMonths = 0;
    _indexDays = 0;
    _indexHours = 0;
    _indexMinutes = 0;

    [self forwardForInternal:date];
    _dateComponents.month = [[_sourceMonths objectAtIndex:_indexMonths] integerValue];
    _dateComponents.day = [[_sourceDays objectAtIndex:_indexDays] integerValue];
    _dateComponents.hour = [[_sourceHours objectAtIndex:_indexHours] integerValue];
    _dateComponents.minute = [[_sourceMinutes objectAtIndex:_indexMinutes] integerValue];
    _dateComponents.second = 0;

    [self createAndAdjustDate];
}

- (void)forwardForInternal:(NSDate *)date {
    _dateComponents = [date mt_components];

    //
    // forward `_indexMonths` to month of the `date`.
    //
    while (_indexMonths < _sourceMonths.count &&
           [[_sourceMonths objectAtIndex:_indexMonths] intValue] < _dateComponents.month) {
        ++_indexMonths;
    }
    // if the `_indexMonths` exceeds, reset it, increment `_dateComponents.year` and return.
    if (_sourceMonths.count <= _indexMonths) {
        _indexMonths = 0;
        ++_dateComponents.year;
        return;
    }

    // if the `_indexMonths` does not refer the month of the `date`, no more adjustment is needed.
    if ([[_sourceMonths objectAtIndex:_indexMonths] intValue] != _dateComponents.month) {
        return;
    }

    //
    // forward indexDays to day of the `date`.
    //
    while (_indexDays < _sourceDays.count &&
           [[_sourceDays objectAtIndex:_indexDays] intValue] < _dateComponents.day) {
        ++_indexDays;
    }
    // if the `_indexDays` exceeds, reset it and forward `_indexMonths` and return.
    if (_sourceDays.count <= _indexDays) {
        _indexDays = 0;
        ++_indexMonths;
        // if the `_indexMonths` exceeds, reset it and increment `_dateComponents.year`.
        if (_sourceMonths.count <= _indexMonths) {
            _indexMonths = 0;
            ++_dateComponents.year;
        }
        return;
    }

    // if the `_indexDays` does not refer the day of the `date`, no more adjustment is needed.
    if ([[_sourceDays objectAtIndex:_indexDays] intValue] != _dateComponents.day) {
        return;
    }

    //
    // forward indexHours to startDate's hour
    //
    while (_indexHours < _sourceHours.count &&
           [[_sourceHours objectAtIndex:_indexHours] intValue] < _dateComponents.hour) {
        ++_indexHours;
    }
    // if the `_indexHours` exceeds, reset it and forward `_indexDays` and return.
    if (_sourceHours.count <= _indexHours) {
        _indexHours = 0;
        ++_indexDays;
        // if the `_indexDays` exceeds, reset it and forward `_indexMonths`.
        if (_sourceDays.count <= _indexDays) {
            _indexDays = 0;
            ++_indexMonths;
            // if the `_indexMonths` exceeds, reset it and increment `_dateComponents.year`.
            if (_sourceMonths.count <= _indexMonths) {
                _indexMonths = 0;
                ++_dateComponents.year;
            }
        }
        return;
    }

    // if the `_indexHours` does not refer the hour of the `date`, no more adjustment is needed.
    if ([[_sourceHours objectAtIndex:_indexHours] intValue] != _dateComponents.hour) {
        return;
    }

    //
    // forward indexHours to minute of `date`
    //
    while (_indexMinutes < _sourceMinutes.count &&
           [[_sourceMinutes objectAtIndex:_indexMinutes] intValue] < _dateComponents.minute) {
        ++_indexMinutes;
    }
    // if the `_indexMinutes` exceeds, reset it and forward `_indexHours` and return.
    if (_sourceMinutes.count <= _indexMinutes) {
        _indexMinutes = 0;
        ++_indexHours;
        // if the `_indexHours` exceeds, reset it and forward `_indexDays`.
        if (_sourceHours.count <= _indexHours) {
            _indexHours = 0;
            ++_indexDays;
            // if the `_indexDays` exceeds, reset it and forward `_indexMonths`.
            if (_sourceDays.count <= _indexDays) {
                _indexDays = 0;
                ++_indexMonths;
                // if the `_indexMonths` exceeds, reset it and increment `_dateComponents.year`.
                if (_sourceMonths.count <= _indexMonths) {
                    _indexMonths = 0;
                    ++_dateComponents.year;
                }
            }
            return;
        }
    }
}

- (void)forward {
    [self forwardInternal];
    [self createAndAdjustDate];
}

- (void)forwardInternal {
    if (++_indexMinutes < _sourceMinutes.count) {
        _dateComponents.minute = [[_sourceMinutes objectAtIndex:_indexMinutes] intValue];
        return;
    }

    _indexMinutes = 0;
    _dateComponents.minute = [[_sourceMinutes objectAtIndex:_indexMinutes] intValue];

    if (++_indexHours < _sourceHours.count) {
        _dateComponents.hour = [[_sourceHours objectAtIndex:_indexHours] intValue];
        return;

    }

    _indexHours = 0;
    _dateComponents.hour = [[_sourceHours objectAtIndex:_indexHours] intValue];

    if (++_indexDays < _sourceDays.count) {
        _dateComponents.day = [[_sourceDays objectAtIndex:_indexDays] intValue];
        return;
    }

    _indexDays = 0;
    _dateComponents.day = [[_sourceDays objectAtIndex:_indexDays] intValue];

    if (++_indexMonths < _sourceMonths.count) {
        _dateComponents.month = [[_sourceMonths objectAtIndex:_indexMonths] intValue];
        return;
    }

    _indexMonths = 0;
    _dateComponents.month = [[_sourceMonths objectAtIndex:_indexMonths] intValue];
    
    ++_dateComponents.year;
}

- (void)createAndAdjustDate {
    _date = [NSDate mt_dateFromComponents:_dateComponents];
    if (_date.mt_dayOfMonth == _dateComponents.day) {
        return;
    }

    // possibly the date in _dateComponents is invalid. (e.g. 2012-02-31)
    // To resolve this issue, forward beyond the current month
    _indexMinutes = _sourceMinutes.count;
    _indexHours = _sourceHours.count;
    _indexDays = _sourceDays.count;
    [self forwardInternal];
    _date = [NSDate mt_dateFromComponents:_dateComponents];
}

- (void)forwardToNextDay {
    _indexMinutes = _sourceMinutes.count;
    _indexHours = _sourceHours.count;
    [self forwardInternal];
    [self createAndAdjustDate];
}


@end
