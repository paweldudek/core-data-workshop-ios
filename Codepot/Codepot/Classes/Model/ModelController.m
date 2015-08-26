/*
 * Copyright (c) 2015 Mobile Academy. All rights reserved.
 */
#import "ModelController.h"
#import "CoreDataStack.h"
#import "NetworkLayer.h"
#import "Employee.h"
#import "Department.h"

#define StartMeasuringTime() CFAbsoluteTime __currentTime = CFAbsoluteTimeGetCurrent();
#define EndMeasuringTime() CFAbsoluteTime __duration = CFAbsoluteTimeGetCurrent() - __currentTime; NSLog(@"Execution time = %lf", __duration);

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

    [self.networkLayer runRequest:request withCompletionInBackground:^(NSArray *JSON, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }

        [self parseResponseData:JSON completion:completion];
    }];
}

#pragma mark - Parsing Data

- (void)parseResponseData:(NSArray *)employeesArray completion:(ModelUpdateCompletion)completion {
    NSParameterAssert(completion);

    // TODO 1: Create worker context
    NSManagedObjectContext *mainContext = self.coreDataStack.mainContext;

    StartMeasuringTime()

    // TODO 2: Use block API

    for (NSDictionary *employeeDictionary in employeesArray) {
        NSString *employeeEmail = employeeDictionary[@"email"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", employeeEmail];

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Employee class])];
        fetchRequest.predicate = predicate;

        Employee *employee = [[mainContext executeFetchRequest:fetchRequest error:nil] firstObject];

        if (employee == nil) {
            employee = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class])
                                                     inManagedObjectContext:mainContext];
        }

        employee.firstName = employeeDictionary[@"firstName"];
        employee.lastName = employeeDictionary[@"lastName"];
        employee.email = employeeEmail;
        employee.city = employeeDictionary[@"city"];
        employee.street = employeeDictionary[@"street"];

        Department *department = [[Department alloc] init];
        department.name = employeeDictionary[@"department"][@"name"];
        department.identifier = employeeDictionary[@"department"][@"id"];

        employee.department = department;
    }

    // Hint: remember to save worker thread
    [self.coreDataStack save];

    EndMeasuringTime()

    // Hint: completion must be called in main queue
    completion(YES, nil);
}

@end
