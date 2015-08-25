/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import <Foundation/Foundation.h>


//TODO: replace this with a managed object
//TODO: you'll need to add a new model object in Codepot.xcdatamodel
//TODO: and create a relationship between Department and Employee
@interface Department : NSObject <NSCoding>

@property(nonatomic, strong) NSString *identifier;

@property(nonatomic, strong) NSString *name;

@end
