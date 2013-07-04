//
//  TimeGeneratorTests.m
//  TimeGeneratorApp
//
//  Created by HANAI Tohru on 2013/07/03.
//  Copyright (c) 2013年 Pokelabo, INC. All rights reserved.
//

#import "TimeGeneratorTests.h"
#import "TimeGenerator.h"
#import <NSDate+MTDates.h>

@implementation TimeGeneratorTests

- (void)setUp {
    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testFullyWildcard {
    TimeGenerator *generator = [[TimeGenerator alloc] initWithCronFormat:@"* * * * *"];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:1 day:1 hour:0 minute:0];
    NSDate *endDate = [NSDate mt_dateFromYear:2013 month:1 day:1 hour:0 minute:2];

    __block int i = 0;
    [generator iterateDatesFrom:startDate to:endDate callback:^BOOL(NSDate *date) {
        NSUInteger expects[][6] = {
            { 2013U, 1U, 1U, 0U, 0U, 0U },
            { 2013U, 1U, 1U, 0U, 1U, 0U }
        };
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);

        STAssertTrue(i < 2, @"loop count");
        STAssertEquals(date.mt_year, expects[i][0], @"year");
        STAssertEquals(date.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(date.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(date.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(date.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(date.mt_secondOfMinute, expects[i][5], @"second");
        ++i;
        return TRUE;
    }];
}

- (void)testConditionNeverMatches {
    TimeGenerator *generator = [[TimeGenerator alloc] initWithCronFormat:@"0 00 1 6 *"];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:4 day:1 hour:0 minute:0];
    NSDate *endDate = [NSDate mt_dateFromYear:2013 month:5 day:1 hour:0 minute:0];
    [generator iterateDatesFrom:startDate to:endDate callback:^BOOL(NSDate *date) {
        STFail(@"should not be called here");
        return FALSE;
    }];

    generator = [[TimeGenerator alloc] initWithCronFormat:@"0 00 1 6 *"];
    startDate = [NSDate mt_dateFromYear:2013 month:7 day:1 hour:0 minute:0];
    endDate = [NSDate mt_dateFromYear:2013 month:8 day:1 hour:0 minute:0];
    [generator iterateDatesFrom:startDate to:endDate callback:^BOOL(NSDate *date) {
        STFail(@"should not be called here");
        return FALSE;
    }];
}

- (void)testRangesAndLoopTermination {
    TimeGenerator *generator = [[TimeGenerator alloc] initWithCronFormat:@"1-3 2-3 3-4 4-5 *"];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:1 day:1 hour:0 minute:0];
    NSDate *endDate = [NSDate mt_dateFromYear:2015 month:1 day:1 hour:0 minute:2];

    __block int i = 0;
    [generator iterateDatesFrom:startDate to:endDate callback:^BOOL(NSDate *date) {
        NSUInteger expects[25][6] = {
            { 2013U, 4U, 3U, 2U, 1U, 0U },
            { 2013U, 4U, 3U, 2U, 2U, 0U },
            { 2013U, 4U, 3U, 2U, 3U, 0U },
            { 2013U, 4U, 3U, 3U, 1U, 0U },
            { 2013U, 4U, 3U, 3U, 2U, 0U },
            { 2013U, 4U, 3U, 3U, 3U, 0U },
            { 2013U, 4U, 4U, 2U, 1U, 0U },
            { 2013U, 4U, 4U, 2U, 2U, 0U },
            { 2013U, 4U, 4U, 2U, 3U, 0U },
            { 2013U, 4U, 4U, 3U, 1U, 0U },
            { 2013U, 4U, 4U, 3U, 2U, 0U },
            { 2013U, 4U, 4U, 3U, 3U, 0U },
            { 2013U, 5U, 3U, 2U, 1U, 0U },
            { 2013U, 5U, 3U, 2U, 2U, 0U },
            { 2013U, 5U, 3U, 2U, 3U, 0U },
            { 2013U, 5U, 3U, 3U, 1U, 0U },
            { 2013U, 5U, 3U, 3U, 2U, 0U },
            { 2013U, 5U, 3U, 3U, 3U, 0U },
            { 2013U, 5U, 4U, 2U, 1U, 0U },
            { 2013U, 5U, 4U, 2U, 2U, 0U },
            { 2013U, 5U, 4U, 2U, 3U, 0U },
            { 2013U, 5U, 4U, 3U, 1U, 0U },
            { 2013U, 5U, 4U, 3U, 2U, 0U },
            { 2013U, 5U, 4U, 3U, 3U, 0U },
            { 2014U, 4U, 3U, 2U, 1U, 0U }
        };
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);

        STAssertTrue(i < 25, @"loop count");
        STAssertEquals(date.mt_year, expects[i][0], @"year");
        STAssertEquals(date.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(date.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(date.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(date.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(date.mt_secondOfMinute, expects[i][5], @"second");
        return (++i < 25);
    }];
}

- (void)testCommaRangesAndLoopTermination {
    TimeGenerator *generator = [[TimeGenerator alloc] initWithCronFormat:@"1,2,3 2,3 3,4 4,5 *"];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:1 day:1 hour:0 minute:0];
    NSDate *endDate = [NSDate mt_dateFromYear:2015 month:1 day:1 hour:0 minute:2];

    __block int i = 0;
    [generator iterateDatesFrom:startDate to:endDate callback:^BOOL(NSDate *date) {
        NSUInteger expects[25][6] = {
            { 2013U, 4U, 3U, 2U, 1U, 0U },
            { 2013U, 4U, 3U, 2U, 2U, 0U },
            { 2013U, 4U, 3U, 2U, 3U, 0U },
            { 2013U, 4U, 3U, 3U, 1U, 0U },
            { 2013U, 4U, 3U, 3U, 2U, 0U },
            { 2013U, 4U, 3U, 3U, 3U, 0U },
            { 2013U, 4U, 4U, 2U, 1U, 0U },
            { 2013U, 4U, 4U, 2U, 2U, 0U },
            { 2013U, 4U, 4U, 2U, 3U, 0U },
            { 2013U, 4U, 4U, 3U, 1U, 0U },
            { 2013U, 4U, 4U, 3U, 2U, 0U },
            { 2013U, 4U, 4U, 3U, 3U, 0U },
            { 2013U, 5U, 3U, 2U, 1U, 0U },
            { 2013U, 5U, 3U, 2U, 2U, 0U },
            { 2013U, 5U, 3U, 2U, 3U, 0U },
            { 2013U, 5U, 3U, 3U, 1U, 0U },
            { 2013U, 5U, 3U, 3U, 2U, 0U },
            { 2013U, 5U, 3U, 3U, 3U, 0U },
            { 2013U, 5U, 4U, 2U, 1U, 0U },
            { 2013U, 5U, 4U, 2U, 2U, 0U },
            { 2013U, 5U, 4U, 2U, 3U, 0U },
            { 2013U, 5U, 4U, 3U, 1U, 0U },
            { 2013U, 5U, 4U, 3U, 2U, 0U },
            { 2013U, 5U, 4U, 3U, 3U, 0U },
            { 2014U, 4U, 3U, 2U, 1U, 0U }
        };
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);

        STAssertTrue(i < 25, @"loop count");
        STAssertEquals(date.mt_year, expects[i][0], @"year");
        STAssertEquals(date.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(date.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(date.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(date.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(date.mt_secondOfMinute, expects[i][5], @"second");
        return (++i < 25);
    }];
}

- (void)testWeekdays {
    TimeGenerator *generator = [[TimeGenerator alloc] initWithCronFormat:@"0 00 * 6 1-5"];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:6 day:1 hour:0 minute:0];
    NSDate *endDate = [NSDate mt_dateFromYear:2013 month:8 day:1 hour:0 minute:0];

    __block int i = 0;
    [generator iterateDatesFrom:startDate to:endDate callback:^BOOL(NSDate *date) {
        NSUInteger expects[][6] = {
            { 2013U, 6U, 3U, 0U, 0U, 0U },
            { 2013U, 6U, 4U, 0U, 0U, 0U },
            { 2013U, 6U, 5U, 0U, 0U, 0U },
            { 2013U, 6U, 6U, 0U, 0U, 0U },
            { 2013U, 6U, 7U, 0U, 0U, 0U },
            { 2013U, 6U, 10U, 0U, 0U, 0U },
            { 2013U, 6U, 11U, 0U, 0U, 0U },
        };
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);

        STAssertTrue(i < 7, @"loop count");
        STAssertEquals(date.mt_year, expects[i][0], @"year");
        STAssertEquals(date.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(date.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(date.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(date.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(date.mt_secondOfMinute, expects[i][5], @"second");
        return ++i < 7;
    }];
}

@end
