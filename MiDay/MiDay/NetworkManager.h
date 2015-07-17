//
//  NetworkManager.h
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetworkManager : NSObject

/**
 *  Singleton declaration
 *
 *  @return a instance of the class
 */
+ (id) getNetworkManager;

- (void) getFeedForURL:(NSString*)url
               success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
               failure:(void (^)(void)) failureCompletion;
@end
