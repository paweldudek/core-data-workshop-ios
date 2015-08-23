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

    //TODO: setup a managed object context with persistent store coordinator and a managed object model

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *storeURL = [[self documentsURL] URLByAppendingPathComponent:@"DataModel.sqlite"];
        NSDictionary *storeMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                                 URL:storeURL
                                                                                               error:nil];

        //TODO: check model compatibility
        //TODO: remove old store if it's not compatible
//        BOOL compatibleWithStoreMetadata = [model isConfiguration:nil compatibleWithStoreMetadata:storeMetadata];

        // If stores are not compatible - remove current data
//        if (!compatibleWithStoreMetadata) {
//            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
//        }
    });
}

- (void)save {
    //TODO: save the context
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
