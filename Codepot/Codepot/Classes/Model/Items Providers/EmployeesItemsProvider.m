/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "EmployeesItemsProvider.h"
#import "ModelController.h"
#import "CoreDataStack.h"

@interface EmployeesItemsProvider ()

@property(nonatomic, strong, readwrite) NSArray *items;

@end


@implementation EmployeesItemsProvider
@synthesize delegate = _delegate;

- (instancetype)initWithModelController:(ModelController *)modelController {
    self = [super init];
    if (self) {
        _modelController = modelController;
    }

    return self;
}

#pragma mark - Items Provider

- (void)updateItems {
    [self.modelController updateDataWithCompletion:^(BOOL successful, NSError *error) {
        if (!successful) {
            [[self delegate] itemsProvider:self didFailToUpdateItemsWithError:error];
            return;
        }

        //TODO: prepare a fetch request to grab all employees sorted by name
        [self loadItems:nil];

        //TODO: call the appropriate delegate method based on result
    }];
}

- (void)loadItems:(NSError **)error {
    NSFetchRequest *fetchRequest;

    NSError *fetchError;

    self.items = [self.mainManagedObjectContext executeFetchRequest:fetchRequest error:&fetchError];

    *error = fetchError;
}

#pragma mark - Helpers

- (NSManagedObjectContext *)mainManagedObjectContext {
    return self.modelController.coreDataStack.mainContext;
}

@end
