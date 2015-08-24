/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import "SearchEmployeesItemsProvider.h"
#import "NSString+SearchNormalization.h"
#import "CoreDataStack.h"


@interface SearchEmployeesItemsProvider ()

@property(nonatomic, strong, readwrite) NSArray *items;

@end


@implementation SearchEmployeesItemsProvider
@synthesize delegate = _delegate;

- (instancetype)initWithStack:(CoreDataStack *)stack {
    self = [super init];
    if (self) {
        _stack = stack;
    }

    return self;
}

#pragma mark - Items Provider

- (void)updateItems {
    // noop
}

- (void)loadItems:(NSError **)error {
    // noop
}

#pragma mark - Search Items Updater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

    NSString *searchText = searchController.searchBar.text;

    //TODO: change these to leverage normalized first and last name
    NSPredicate *firstNamePredicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS[cd] %@", searchText];
    NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"lastName CONTAINS[cd] %@", searchText];

    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[firstNamePredicate, lastNamePredicate]];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    fetchRequest.predicate = compoundPredicate;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]];

    self.items = [self.stack.mainContext executeFetchRequest:fetchRequest error:nil];

    [[self delegate] itemsProviderDidUpdateItems:self];

    CFAbsoluteTime searchEnd = CFAbsoluteTimeGetCurrent();

    NSLog(@"Searching took: %f", searchEnd - start);
}

@end
