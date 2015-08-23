/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import <Foundation/Foundation.h>

@class CoreDataStack;
@class NetworkLayer;

typedef void (^ModelUpdateCompletion)(BOOL successful, NSError *error);

@interface ModelController : NSObject

@property(nonatomic, readonly) CoreDataStack *coreDataStack;

@property(nonatomic, strong) NetworkLayer *networkLayer;

- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack;

- (void)updateDataWithCompletion:(ModelUpdateCompletion)completion;

@end
