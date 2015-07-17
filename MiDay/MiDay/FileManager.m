//
//  FileManager.m
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "FileManager.h"

@interface FileManager()

@property (strong,nonatomic) NSURL* documentsURL;

@end

@implementation FileManager

/**
 *  check if there is already an instance, if not alloc one
 *  return the instance of the singleton
 */
+ (id)getFileManager {
    //structure used to test whether the block has complete or not
    static dispatch_once_t p = 0;
    
    //initialize sharedObject as nil(first call only)
    static FileManager *shared= nil;
    
    //executes a block object once and only once for the application lifetime
    dispatch_once(&p, ^{
        shared = [[self alloc] init];
    });
    
    //returhs the same objec each time
    return shared;
}

//show a alertview to show error
- (void)showWithError:(NSError*) error {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[error localizedDescription]
                          message:[error localizedRecoverySuggestion]
                          delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                          otherButtonTitles:nil];
    
    [alert show];
}

- (id)init{
    if(self = [super init]){
        //initialization
        NSError *err = nil;
        self.documentsURL = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                                        inDomain:NSUserDomainMask
                                               appropriateForURL:nil
                                                          create:YES
                                                           error:&err];
        if (err) {
            [self showWithError:err];
        }
    }
    return self;
}

- (void)SaveToDocumentsByFilenameAndData:(NSString*)filename data:(NSData*)fileData{
    NSURL *fileURL = [self.documentsURL URLByAppendingPathComponent:filename];
    DLog(@"save file: %@",fileURL);
    [fileData writeToURL:fileURL atomically:NO]; //Write the file
}

- (NSData*)ReadFromDocumentsByFilename:(NSString*)filename{
    if (filename) {
        NSURL *file = [self.documentsURL URLByAppendingPathComponent:filename];
        return [[NSData alloc] initWithContentsOfURL:file];
    }else{
        return nil;
    }

}

- (void)RemoveFromDocumentsByFilename:(NSString *)filename{
    if (filename) {
        NSURL* fileURL = [self.documentsURL URLByAppendingPathComponent:filename];
        
        NSError *err;
        DLog(@"delete file: %@",[fileURL path]);
        [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&err];
        
        if (err) {
            DLog(@"delete file error!");
        }
    }

}

@end
