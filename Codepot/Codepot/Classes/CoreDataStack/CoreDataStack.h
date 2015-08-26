//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property(nonatomic, strong, readonly) NSManagedObjectContext *mainContext;
@property(nonatomic, copy, readonly) void (^completionCallback)();

- (instancetype)initWithCompletionCallback:(void (^)())completionCallback;

- (void)setUpCoreData;

- (void)save;

@end
