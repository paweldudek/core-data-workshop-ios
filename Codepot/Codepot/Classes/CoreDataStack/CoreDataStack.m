//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()
@property(nonatomic, strong, readwrite) NSManagedObjectContext *mainContext;
@end

@implementation CoreDataStack

- (void)setUpCoreData {
    if (self.mainContext) {
        return;
    }

    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSManagedObjectContext *mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    mainContext.persistentStoreCoordinator = coordinator;
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
            NSLog(@"Error adding persisten store = %@", error);
            abort();
        }
    });
}

- (void)save {
    if ([self.mainContext hasChanges]) {
        [self saveOnContext:self.mainContext];
    }
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
