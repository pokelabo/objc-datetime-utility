//
//  TimeGeneratorCronIteratorTests.m
//  TimeGeneratorApp
//
//  Created by HANAI Tohru on 2013/07/03.
//  Copyright (c) 2013年 Pokelabo, INC. All rights reserved.
//

#import "TimeGeneratorCronIteratorTests.h"
#import "TimeGeneratorCronIterator.h"
#import <NSDate+MTDates.h>

@implementation TimeGeneratorCronIteratorTests

- (void)setUp {
    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testIterate {
    TimeGeneratorCronIterator* iterator = [[TimeGeneratorCronIterator alloc] initWithSourceMonths:@[@1, @2]
                                                                                       sourceDays:@[@1, @3]
                                                                                      sourceHours:@[@0, @4]
                                                                                    sourceMinutes:@[@0, @5]];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:1 day:1 hour:0 minute:0];
    [iterator forwardFor:startDate];

    NSUInteger expects[17][6] = {
        { 2013U, 1U, 1U, 0U, 0U, 0U },
        { 2013U, 1U, 1U, 0U, 5U, 0U },
        { 2013U, 1U, 1U, 4U, 0U, 0U },
        { 2013U, 1U, 1U, 4U, 5U, 0U },
        { 2013U, 1U, 3U, 0U, 0U, 0U },
        { 2013U, 1U, 3U, 0U, 5U, 0U },
        { 2013U, 1U, 3U, 4U, 0U, 0U },
        { 2013U, 1U, 3U, 4U, 5U, 0U },
        { 2013U, 2U, 1U, 0U, 0U, 0U },
        { 2013U, 2U, 1U, 0U, 5U, 0U },
        { 2013U, 2U, 1U, 4U, 0U, 0U },
        { 2013U, 2U, 1U, 4U, 5U, 0U },
        { 2013U, 2U, 3U, 0U, 0U, 0U },
        { 2013U, 2U, 3U, 0U, 5U, 0U },
        { 2013U, 2U, 3U, 4U, 0U, 0U },
        { 2013U, 2U, 3U, 4U, 5U, 0U },
        { 2014U, 1U, 1U, 0U, 0U, 0U }
    };

    for (int i = 0; i < 17; ++i) {
        NSDate *runDate = iterator.date;
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        STAssertEquals(runDate.mt_year, expects[i][0], @"year");
        STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");
        [iterator forward];
    }
}

- (void)testInitForward {
    TimeGeneratorCronIterator* iterator = [[TimeGeneratorCronIterator alloc] initWithSourceMonths:@[@1, @2, @3, @4]
                                                                                       sourceDays:@[@4, @5, @6]
                                                                                      sourceHours:@[@5, @6, @7]
                                                                                    sourceMinutes:@[@6, @7, @8]];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:3 day:5 hour:0 minute:0];
    [iterator forwardFor:startDate];

    NSUInteger expects[2][6] = {
        { 2013U, 3U, 5U, 5U, 6U, 0U },
        { 2013U, 3U, 5U, 5U, 7U, 0U },
    };

    for (int i = 0; i < 2; ++i) {
        NSDate *runDate = iterator.date;
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        STAssertEquals(runDate.mt_year, expects[i][0], @"year");
        STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");
        [iterator forward];
    }
}

- (void)testInitNoForward {
    TimeGeneratorCronIterator* iterator = [[TimeGeneratorCronIterator alloc] initWithSourceMonths:@[@3]
                                                                                       sourceDays:@[@4]
                                                                                      sourceHours:@[@5]
                                                                                    sourceMinutes:@[@6]];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:3 day:4 hour:5 minute:6];
    [iterator forwardFor:startDate];

    NSUInteger expects[2][6] = {
        { 2013U, 3U, 4U, 5U, 6U, 0U },
        { 2014U, 3U, 4U, 5U, 6U, 0U },
    };

    for (int i = 0; i < 2; ++i) {
        NSDate *runDate = iterator.date;
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        STAssertEquals(runDate.mt_year, expects[i][0], @"year");
        STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");
        [iterator forward];
    }
}

- (void)testInitForwardPastCurrentYear {
    TimeGeneratorCronIterator* iterator = [[TimeGeneratorCronIterator alloc] initWithSourceMonths:@[@3]
                                                                                       sourceDays:@[@4]
                                                                                      sourceHours:@[@5]
                                                                                    sourceMinutes:@[@6]];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:3 day:4 hour:5 minute:7];
    [iterator forwardFor:startDate];

    NSUInteger expects[2][6] = {
        { 2014U, 3U, 4U, 5U, 6U, 0U },
        { 2015U, 3U, 4U, 5U, 6U, 0U },
    };

    for (int i = 0; i < 2; ++i) {
        NSDate *runDate = iterator.date;
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        STAssertEquals(runDate.mt_year, expects[i][0], @"year");
        STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");
        [iterator forward];
    }
}

- (void)testIncludesInvalidDate {
    TimeGeneratorCronIterator* iterator = [[TimeGeneratorCronIterator alloc] initWithSourceMonths:@[@1, @2, @3]
                                                                                       sourceDays:@[@27, @31]
                                                                                      sourceHours:@[@1]
                                                                                    sourceMinutes:@[@2]];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:1 day:1 hour:0 minute:0];
    [iterator forwardFor:startDate];

    NSUInteger expects[5][6] = {
        { 2013U, 1U, 27U, 1U, 2U, 0U },
        { 2013U, 1U, 31U, 1U, 2U, 0U },
        { 2013U, 2U, 27U, 1U, 2U, 0U },
        { 2013U, 3U, 27U, 1U, 2U, 0U },
        { 2013U, 3U, 31U, 1U, 2U, 0U },
    };

    for (int i = 0; i < 5; ++i) {
        NSDate *runDate = iterator.date;
        NSLog(@"date loop %d, %@", i,
              [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
        STAssertEquals(runDate.mt_year, expects[i][0], @"year");
        STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
        STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
        STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
        STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
        STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");
        [iterator forward];
    }
}

- (void)testForwardToNextDay {
    TimeGeneratorCronIterator* iterator = [[TimeGeneratorCronIterator alloc] initWithSourceMonths:@[@1]
                                                                                       sourceDays:@[@1, @3, @5]
                                                                                      sourceHours:@[@1, @2, @3]
                                                                                    sourceMinutes:@[@1, @2, @3]];
    NSDate *startDate = [NSDate mt_dateFromYear:2013 month:1 day:1 hour:0 minute:0];
    [iterator forwardFor:startDate];

    NSUInteger expects[4][6] = {
        { 2013U, 1U, 1U, 1U, 1U, 0U },
        { 2013U, 1U, 3U, 1U, 1U, 0U },
        { 2013U, 1U, 3U, 1U, 2U, 0U },
        { 2013U, 1U, 5U, 1U, 1U, 0U },
    };

    int i = 0;

    NSDate *runDate = iterator.date;
    NSLog(@"date #%d, %@", i,
          [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    STAssertEquals(runDate.mt_year, expects[i][0], @"year");
    STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
    STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
    STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
    STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
    STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");

    [iterator forwardToNextDay];
    ++i;
    runDate = iterator.date;
    NSLog(@"date #%d, %@", i,
          [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    STAssertEquals(runDate.mt_year, expects[i][0], @"year");
    STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
    STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
    STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
    STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
    STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");

    [iterator forward];
    ++i;
    runDate = iterator.date;
    NSLog(@"date #%d, %@", i,
          [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    STAssertEquals(runDate.mt_year, expects[i][0], @"year");
    STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
    STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
    STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
    STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
    STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");

    [iterator forwardToNextDay];
    ++i;
    runDate = iterator.date;
    NSLog(@"date #%d, %@", i,
          [NSDateFormatter localizedStringFromDate:runDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
    STAssertEquals(runDate.mt_year, expects[i][0], @"year");
    STAssertEquals(runDate.mt_monthOfYear, expects[i][1], @"month");
    STAssertEquals(runDate.mt_dayOfMonth, expects[i][2], @"day");
    STAssertEquals(runDate.mt_hourOfDay, expects[i][3], @"hour");
    STAssertEquals(runDate.mt_minuteOfHour, expects[i][4], @"minute");
    STAssertEquals(runDate.mt_secondOfMinute, expects[i][5], @"second");
}

@end
