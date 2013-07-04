//
//  TimeGeneratorCronIterator.h
//  TimeGeneratorApp
//
//  Created by HANAI Tohru on 2013/07/03.
//  Copyright (c) 2013年 Pokelabo, INC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeGeneratorCronIterator : NSObject

- (id)initWithSourceMonths:(NSArray *)sourceMonths
                sourceDays:(NSArray *)sourceDays
               sourceHours:(NSArray *)sourceHours
             sourceMinutes:(NSArray *)sourceMinutes;

- (void)forwardFor:(NSDate *)date;
- (void)forward;
- (void)forwardToNextDay;

@property (nonatomic, readonly) NSDate *date;

@end

