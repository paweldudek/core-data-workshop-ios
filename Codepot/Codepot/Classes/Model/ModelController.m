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

        // Temporary hack to make sure OS can handle that many objects in memory ;)
        NSUInteger halfCount = JSON.count / 2;
        NSArray *firstBatch = [JSON subarrayWithRange:NSMakeRange(0, halfCount)];
        NSArray *secondBatch = [JSON subarrayWithRange:NSMakeRange(halfCount, halfCount)];

        [self parseResponseData:firstBatch completion:completion];
        [self parseResponseData:secondBatch completion:completion];
    }];
}

#pragma mark - Parsing Data

- (void)parseResponseData:(NSArray *)employeesArray completion:(ModelUpdateCompletion)completion {
    NSParameterAssert(completion);

    NSManagedObjectContext *workerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    workerContext.parentContext = self.coreDataStack.mainContext;

    [workerContext performBlock:^{
        StartMeasuringTime()

        NSArray *allEmails = [employeesArray valueForKeyPath:@"email"];

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Employee class])];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"email IN %@", allEmails];
        NSArray *employees = [workerContext executeFetchRequest:fetchRequest error:nil];

        NSMutableDictionary *employeesMap = [NSMutableDictionary dictionary];
        for (Employee *employee in employees) {
            employeesMap[employee.email] = employee;
        }

        for (NSDictionary *employeeDictionary in employeesArray) {
            NSString *employeeEmail = employeeDictionary[@"email"];
            Employee *employee = employeesMap[employeeEmail];
            if (employee == nil) {
                employee = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Employee class])
                                                         inManagedObjectContext:workerContext];
            }
            [self updateEmployee:employee withJSON:employeeDictionary];
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

- (void)updateEmployee:(Employee *)employee withJSON:(NSDictionary *)employeeDictionary {
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

@end
