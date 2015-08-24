/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ItemsProvider.h"

@class CoreDataStack;


@interface SearchEmployeesItemsProvider : NSObject <ItemsProvider, UISearchResultsUpdating>

@property(nonatomic, readonly) CoreDataStack *stack;

- (instancetype)initWithStack:(CoreDataStack *)stack;

@end
