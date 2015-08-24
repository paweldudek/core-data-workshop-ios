/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import "Employee+Printable.h"
#import "Department.h"


@implementation Employee (Printable)

- (NSString *)title {
    return [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName];
}

- (NSString *)subtitle {
    return self.department.name;
}

@end
