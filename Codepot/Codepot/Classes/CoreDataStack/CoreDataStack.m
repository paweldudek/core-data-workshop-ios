//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()
@property(nonatomic, strong, readwrite) NSManagedObjectContext *mainContext;
@property(nonatomic, strong, readwrite) NSManagedObjectContext *writingContext;
@property(nonatomic, copy, readwrite) void (^completionCallback)();
@end

@implementation CoreDataStack

- (instancetype)initWithCompletionCallback:(void (^)())completionCallback {
    self = [super init];
    if (self) {
        self.completionCallback = [completionCallback copy];
        [self setUpCoreData];
    }

    return self;
}


- (void)setUpCoreData {
    if (self.mainContext) {
        return;
    }

    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSManagedObjectContext *writingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    writingContext.persistentStoreCoordinator = coordinator;
    self.writingContext = writingContext;

    NSManagedObjectContext *mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    mainContext.parentContext = self.writingContext;
    self.mainContext = mainContext;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *storeURL = [[self documentsURL] URLByAppendingPathComponent:@"DataModel.sqlite"];
        NSDictionary *storeMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                                 URL:storeURL
                                                                                               error:nil];

        BOOL compatibleWithStoreMetadata = [model isConfiguration:nil compatibleWithStoreMetadata:storeMetadata];

        if (!compatibleWithStoreMetadata) {
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        }

        NSError *error;
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                       configuration:nil
                                                 URL:storeURL
                                             options:nil
                                               error:&error]) {
            NSLog(@"Error adding persistent store = %@", error.localizedDescription);
            abort();
        }
        if (self.completionCallback) {
            dispatch_async(dispatch_get_main_queue(), self.completionCallback);
        }
    });
}

- (void)save {
    if (![self.writingContext hasChanges] && ![self.mainContext hasChanges]) {
        return;
    }
    [self.mainContext performBlockAndWait:^{
        [self saveOnContext:self.mainContext];
        [self.writingContext performBlock:^{
            [self saveOnContext:self.writingContext];
        }];
    }];
}

#pragma mark - Helpers

- (void)saveOnContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Failed to save %@ context: %@\n%@", context.name, [error localizedDescription], [error userInfo]);
    }
}

- (NSURL *)documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
