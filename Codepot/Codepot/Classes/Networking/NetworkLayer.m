//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import "NetworkLayer.h"

@implementation NetworkLayer

- (void)runRequest:(__unused NSURLRequest *)request withCompletion:(NetworkLayerCompletion)completion {
    NSParameterAssert(completion);
    [self dispatchAfterDelay:[self generateDelay] onMainQueue:YES block:^{

        NSString *cannedResponsePath = [[NSBundle mainBundle] pathForResource:@"small" ofType:@"json"];

        id response = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:cannedResponsePath]
                                                      options:0
                                                        error:nil];
        completion(response, nil);
    }];
}

- (void)dispatchAfterDelay:(NSTimeInterval)delay onMainQueue:(BOOL)mainQueue block:(void (^)())block {
    dispatch_queue_t queue = mainQueue ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC)), queue, block);
}

- (double)generateDelay {
    return (arc4random() % 20) * 0.1;
}

@end
