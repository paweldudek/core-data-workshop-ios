/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import "ModelController.h"
#import "CoreDataStack.h"
#import "NetworkLayer.h"
#import "Employee.h"


@implementation ModelController

- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack {
    self = [super init];
    if (self) {
        _coreDataStack = coreDataStack;

        self.networkLayer = [[NetworkLayer alloc] init];
    }

    return self;
}

#pragma mark - Updating Data

- (void)updateDataWithCompletion:(ModelUpdateCompletion)completion {
    NSParameterAssert(completion);

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://myawesomeapi.com/employees"]];

    [self.networkLayer runRequest:request withCompletion:^(NSArray *JSON, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }

        [self parseResponseData:JSON completion:completion];
    }];
}

#pragma mark - Parsing Data

- (void)parseResponseData:(NSArray *)employeesArray completion:(ModelUpdateCompletion)completion {

    NSManagedObjectContext *mainContext = self.coreDataStack.mainContext;

    for (NSDictionary *employeeDictionary in employeesArray) {

        //TODO: use appropriate entity name
        Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:nil
                                                           inManagedObjectContext:mainContext];
        //TODO: parse the actual data
        //Tip: use transformable property to store department information
    }

    //TODO: save the context

    completion(YES, nil);
}

@end
