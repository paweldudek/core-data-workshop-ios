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

    NSManagedObjectContext *workerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    workerContext.parentContext = self.coreDataStack.mainContext;

    [workerContext performBlock:^{
        StartMeasuringTime()

        for (NSDictionary *employeeDictionary in employeesArray) {
            NSString *employeeEmail = employeeDictionary[@"email"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", employeeEmail];

            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Employee class])];
            fetchRequest.predicate = predicate;

            Employee *employee = [[workerContext executeFetchRequest:fetchRequest error:nil] firstObject];

            if (employee == nil) {
                employee = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class])
                                                         inManagedObjectContext:workerContext];
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

        NSError *saveError = nil;
        if ([workerContext save:&saveError]) {
            [self.coreDataStack save];
        } else {
            NSLog(@"Error while saving = %@", saveError);
        }

        EndMeasuringTime()

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES, nil);
        });
    }];
}

@end
