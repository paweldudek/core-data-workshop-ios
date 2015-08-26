/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "EmployeesItemsProvider.h"
#import "ModelController.h"
#import "CoreDataStack.h"
#import "Employee.h"

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

        NSError *loadError;
        [self loadItems:&loadError];

        if (loadError) {
            [[self delegate] itemsProvider:self didFailToUpdateItemsWithError:loadError];
            return;
        }

        [[self delegate] itemsProviderDidUpdateItems:self];
    }];
}

#pragma mark - Loading

- (void)loadItems:(NSError **)error {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Employee class])];
    // TODO 1: Play with fetch request properties to improve scrolling performance
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]];

    NSError *fetchError;

    self.items = [self.mainManagedObjectContext executeFetchRequest:fetchRequest error:&fetchError];

    if (error) {
        *error = fetchError;
    }
}

#pragma mark - Helpers

- (NSManagedObjectContext *)mainManagedObjectContext {
    return self.modelController.coreDataStack.mainContext;
}

@end
