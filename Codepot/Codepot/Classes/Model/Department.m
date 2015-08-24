/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import "Department.h"


@implementation Department

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.identifier = [coder decodeObjectForKey:@"self.identifier"];
        self.name = [coder decodeObjectForKey:@"self.name"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.identifier forKey:@"self.identifier"];
    [coder encodeObject:self.name forKey:@"self.name"];
}

@end
