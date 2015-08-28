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

    NSString *searchText = [searchController.searchBar.text stringByNormalizingForSearch];

    if (searchText.length) {
        NSString *substring = [searchText substringToIndex:searchText.length - 1];
        NSString *lastCharacter = [searchText substringFromIndex:searchText.length - 1];
        char const *cChars = [lastCharacter cStringUsingEncoding:NSUTF8StringEncoding];
        char lastChar = (char) (cChars[0] + 1);

        NSString *nextLastLetterString = [NSString stringWithFormat:@"%@%c", substring, lastChar];

        NSPredicate *firstNamePredicate = [NSPredicate predicateWithFormat:@"normalizedFirstName >= %@ && normalizedFirstName < %@", searchText, nextLastLetterString];
        NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"normalizedLastName  >= %@ && normalizedLastName < %@", searchText, nextLastLetterString];

        NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[firstNamePredicate, lastNamePredicate]];

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
        fetchRequest.predicate = compoundPredicate;
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]];

        self.items = [self.stack.mainContext executeFetchRequest:fetchRequest error:nil];
    }
    else {
        self.items = nil;
    }

    [[self delegate] itemsProviderDidUpdateItems:self];

    CFAbsoluteTime searchEnd = CFAbsoluteTimeGetCurrent();

    NSLog(@"Searching took: %f", searchEnd - start);
}

@end
