//
//  TimeGenerator.m
//  TimeGeneratorApp
//
//  Created by HANAI Tohru on 2013/07/03.
//  Copyright (c) 2013年 Pokelabo, INC. All rights reserved.
//

#import "TimeGenerator.h"
#import "TimeGeneratorCronIterator.h"
#import <NSDate+MTDates.h>

@implementation TimeGenerator {
    NSArray *_sourceMonths;
    NSArray *_sourceDays;
    NSArray *_sourceHours;
    NSArray *_sourceMinutes;
    NSArray *_validDayOfWeeks;
}

- initWithCronFormat:(NSString *)format {
    self = [super init];
    if (!self) return nil;

    [self parseCronFormat:format];
    return self;
}

- (BOOL)parseCronFormat:(NSString *)format {
    NSArray *parts = [format componentsSeparatedByString:@" "];
    if (parts.count != 5) {
        return FALSE;
    }

    _sourceMinutes = [self parseCronPart:[parts objectAtIndex:0] min:0 max:59];
    _sourceHours = [self parseCronPart:[parts objectAtIndex:1] min:0 max:23];
    _sourceDays = [self parseCronPart:[parts objectAtIndex:2] min:1 max:31];
    _sourceMonths = [self parseCronPart:[parts objectAtIndex:3] min:1 max:12];
    _validDayOfWeeks = [self parseCronPart:[parts objectAtIndex:4] min:0 max:6];

    if (_sourceMinutes.count < 1) return FALSE;
    if (_sourceHours.count < 1) return FALSE;
    if (_sourceDays.count < 1) return FALSE;
    if (_sourceMonths.count < 1) return FALSE;
    if (_validDayOfWeeks.count < 1) return FALSE;

    return TRUE;
}

- (void)iterateDatesFrom:(NSDate *)startDate
                      to:(NSDate *)endDate
                callback:(TimeGeneratorIterateCallback) callback {
    TimeGeneratorCronIterator *iterator = [[TimeGeneratorCronIterator alloc] initWithSourceMonths:_sourceMonths
                                                                                       sourceDays:_sourceDays
                                                                                      sourceHours:_sourceHours
                                                                                    sourceMinutes:_sourceMinutes];
    [iterator forwardFor:startDate];

    int sentinel = 60 * 24 * 365;   // prevent to loop infinite
    while (0 < sentinel--) {
        NSDate *run = iterator.date;
        if ([run compare:endDate] != NSOrderedAscending) {
            return;
        }

        // if the current day is not valid(not in `_validDayOfWeeks`), then skip the current day.
        if ([_validDayOfWeeks indexOfObject:[NSNumber numberWithInteger:run.mt_weekdayOfWeek - 1]] == NSNotFound) {
            [iterator forwardToNextDay];
            continue;
        }

        // dispatch `callback`.
        // NOTE: weekday range between cron and cocoa has differencial.
        //       cron: 0-6, cocoa: 1-7
        if (!callback(run)) {
            // `callback` would return FALSE to stop the iteration.
            break;
        }

        [iterator forward];
    }
}

- (NSArray *)parseCronPart:(NSString *)part min:(NSInteger)min max:(NSInteger)max {
    if ([part isEqualToString:@"*"]) {
        NSMutableArray *source = [NSMutableArray arrayWithCapacity:(max - min + 1)];
        for (NSInteger i = min; i <= max; ++i) {
            [source addObject:[NSNumber numberWithInteger:i]];
        }
        return source;

    }

    if ([part rangeOfString:@"-"].location != NSNotFound) {
        NSArray *range = [part componentsSeparatedByString:@"-"];
        NSInteger rangeMin = min;
        NSInteger rangeMax = max;
        if (![[range objectAtIndex:0] isEqualToString:@""]) {
            rangeMin = [[range objectAtIndex:0] intValue];
            if (rangeMin < min || max < rangeMin) return nil;
        }
        if (![[range objectAtIndex:1] isEqualToString:@""]) {
            rangeMax = [[range objectAtIndex:1] intValue];
            if (rangeMax < min || max < rangeMax) return nil;
        }

        NSMutableArray *source = [NSMutableArray arrayWithCapacity:(rangeMax - rangeMin + 1)];
        for (NSInteger i = rangeMin; i <= rangeMax; ++i) {
            [source addObject:[NSNumber numberWithInteger:i]];
        }
        return source;
    }

    NSArray *values = [part componentsSeparatedByString:@","];
    NSMutableArray *source = [NSMutableArray arrayWithCapacity:values.count];
    for (NSString *value in values) {
        [source addObject:[NSNumber numberWithInteger:[value intValue]]];
    }
    return source;
}

@end
