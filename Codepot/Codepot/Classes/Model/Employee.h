/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Department;


@interface Employee : NSManagedObject

@property(nonatomic, strong) NSString *firstName;

@property(nonatomic, strong) NSString *lastName;

@property(nonatomic, strong) NSString *email;

@property(nonatomic, strong) NSString *street;

@property(nonatomic, strong) NSString *city;

@property(nonatomic, strong) Department *department;

#pragma mark - Searching Helpers

@property(nonatomic, strong) NSString *normalizedFirstName;

@property(nonatomic, strong) NSString *normalizedLastName;

//TODO: Add properties for normalized first and last name
//TODO: Remember to mark them dynamic and add them to model schema as well!

@end
