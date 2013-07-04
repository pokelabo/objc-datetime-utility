objc-datetime-utility
=====================

DateTime utility for Cocoa and Cocoa Touch frameworks.  

usage
-----

- Generate ranges of datetimes based on [crontab format specification][CrontabSpec].

  ```objective-c
  #import <NSDate+MTDates.h>
  #import <TimeGenerator.h>

  TimeGenerator *generator = [[TimeGenerator alloc] initWithCronFormat:@"00,30 9-16 * * 1-5"];
  NSDate *startDate = [NSDate mt_dateFromYear:2013 month:1 day:1 hour:0 minute:0];
  NSDate *endDate = [NSDate mt_dateFromYear:2014 month:1 day:1 hour:0 minute:0];
  [generator iterateDatesFrom:startDate to:endDate callback:^BOOL(NSDate *date) {
      NSLog(@"%@", [NSDateFormatter localizedStringFromDate:date 
                                                  dateStyle:NSDateFormatterShortStyle
												  timeStyle:NSDateFormatterShortStyle]);
      return TRUE;  // `true` to continue, `false` to terminate.
  }];
  ```

[CrontabSpec]: https://en.wikipedia.org/wiki/Cron
