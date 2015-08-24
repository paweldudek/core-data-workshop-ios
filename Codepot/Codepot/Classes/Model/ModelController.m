/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import "ModelController.h"
#import "CoreDataStack.h"
#import "NetworkLayer.h"
#import "Employee.h"
#import "Department.h"


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

    //TODO: ensure that we're not creating a new employee if there's one existing in our database already

    for (NSDictionary *employeeDictionary in employeesArray) {
        //TODO: don't fetch the employee every time we want to make the check - do a bigger prefetch before
        //TODO: you can collect all employee emails from received data to minimise memory usage
        Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class])
                                                           inManagedObjectContext:mainContext];

        employee.firstName = employeeDictionary[@"firstName"];
        employee.lastName = employeeDictionary[@"lastName"];
        employee.email = employeeDictionary[@"email"];
        employee.city = employeeDictionary[@"city"];
        employee.street = employeeDictionary[@"street"];

        Department *department = [[Department alloc] init];
        department.name = employeeDictionary[@"department"][@"name"];
        department.identifier = employeeDictionary[@"department"][@"id"];

        employee.department = department;
    }

    [self.coreDataStack save];

    completion(YES, nil);
}

@end
