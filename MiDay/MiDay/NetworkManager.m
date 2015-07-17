//
//  NetworkManager.m
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

/**
 *  check if there is already an instance, if not alloc one
 *  return the instance of the singleton
 */
+ (id)getNetworkManager
{
    //structure used to test whether the block has complete or not
    static dispatch_once_t p = 0;
    
    //initialize sharedObject as nil(first call only)
    static NetworkManager *shared= nil;
    
    //executes a block object once and only once for the application lifetime
    dispatch_once(&p, ^{
        shared = [[self alloc] init];
    });
    
    //returhs the same objec each time
    return shared;
}

- (id)init{
    if(self = [super init]){
        //initialization
    }
    return self;
}

#pragma mark - Requests
- (void)getFeedForURL:(NSString*)url
              success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
              failure:(void (^)(void)) failureCompletion
{
    /**
     *  use networkActivityIndicator to show network activity
     */
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //Google API url
    NSString *gURL = url;
    
    //Create NSUrlSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    //Create data download task
    [[session dataTaskWithURL:[NSURL URLWithString:gURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSHTTPURLResponse *httpPesp = (NSHTTPURLResponse*) response;
                
                if (httpPesp.statusCode == 200) {
                    NSError *jsonError;
                    
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    
                    //call the block
                    successCompletion(dictionary,jsonError);
                    
                } else {
                    
                    DLog(@"Fail Not 200:");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //call the failure if exist
                        if (failureCompletion) {
                            failureCompletion();
                        }
                        
                    });
                }
                
                /**
                 *  turn of networkActivityIndicator
                 */
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            }] resume];
}
@end
