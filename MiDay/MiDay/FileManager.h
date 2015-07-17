//
//  FileManager.h
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileManager : NSObject

/**
 *  Singleton declaration
 *
 *  @return a instance of the class
 */
+ (id) getFileManager;

- (void)SaveToDocumentsByFilenameAndData:(NSString*)filename data:(NSData*)fileData;
- (NSData*)ReadFromDocumentsByFilename:(NSString*)filename;
- (void)RemoveFromDocumentsByFilename:(NSString*)filename;

@end
