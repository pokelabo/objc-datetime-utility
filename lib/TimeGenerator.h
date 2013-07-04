//
//  TimeGenerator.h
//  TimeGeneratorApp
//
//  Created by HANAI Tohru on 2013/07/03.
//  Copyright (c) 2013年 Pokelabo, INC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^TimeGeneratorIterateCallback)(NSDate *date);

@interface TimeGenerator : NSObject

- initWithCronFormat:(NSString *)format;

// iterates in range of `startDate` <= _date_ < `endDate`.
- (void)iterateDatesFrom:(NSDate *)startDate
                      to:(NSDate *)endDate
                callback:(TimeGeneratorIterateCallback) callback;

@end
