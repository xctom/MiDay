//
//  Journal.h
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Weather.h"

@interface Journal : NSObject <NSCoding>

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) Weather *weather;
@property (strong,nonatomic) NSDate *create;
@property (strong,nonatomic) NSDate *lastModified;
@property (strong,nonatomic) NSArray *tags;
@property (strong,nonatomic) NSString *weekday;
@property (strong,nonatomic) NSString *imagePath;
@property (strong,nonatomic) NSString *audioPath;
@property (strong,nonatomic) NSString *videoPath;
@property (strong,nonatomic) CLLocation *location;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *tagsString;//for tags search

@end
