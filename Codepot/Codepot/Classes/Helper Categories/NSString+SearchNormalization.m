/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import "NSString+SearchNormalization.h"


@implementation NSString (SearchNormalization)

- (NSString *)stringByNormalizingForSearch {
    NSMutableString *mutableSelf = [[self lowercaseString] mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef) mutableSelf, nil, kCFStringTransformStripDiacritics, NO);
    // It's a bit fascinating but apparently 'ł' somehow manages to slip.
    [mutableSelf replaceOccurrencesOfString:@"ł" withString:@"l" options:0 range:NSMakeRange(0, mutableSelf.length)];
    return [mutableSelf copy];
}

@end
