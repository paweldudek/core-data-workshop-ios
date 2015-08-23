//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkLayerCompletion)(NSArray *JSON, NSError *error);

@interface NetworkLayer : NSObject

- (void)runRequest:(NSURLRequest *)request withCompletion:(NetworkLayerCompletion)completion;

@end
