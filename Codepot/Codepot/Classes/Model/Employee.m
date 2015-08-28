/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import "Employee.h"
#import "Department.h"
#import "NSString+SearchNormalization.h"


@implementation Employee
@dynamic firstName;
@dynamic lastName;
@dynamic email;
@dynamic street;
@dynamic city;
@dynamic department;
@dynamic normalizedLastName;
@dynamic normalizedFirstName;

- (void)willSave {
    [super willSave];

    NSString *normalizedFirstName = [self.firstName stringByNormalizingForSearch];
    NSString *normalizedLastName = [self.lastName stringByNormalizingForSearch];

    if (![self.normalizedFirstName isEqualToString:normalizedFirstName]) {
        self.normalizedFirstName = normalizedFirstName;
    }

    if (![self.normalizedLastName isEqualToString:normalizedLastName]) {
        self.normalizedLastName = normalizedLastName;
    }
}

@end
