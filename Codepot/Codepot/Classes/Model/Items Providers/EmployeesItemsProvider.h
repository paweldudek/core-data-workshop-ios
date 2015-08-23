/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import "ItemsProvider.h"

@class ModelController;


@interface EmployeesItemsProvider : NSObject <ItemsProvider>

@property(nonatomic, readonly) ModelController *modelController;

- (instancetype)initWithModelController:(ModelController *)modelController;

@end
