//
//  Weather.h
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject <NSCoding>

@property (strong, nonatomic) NSString* detail;
@property (nonatomic) NSInteger temp;
@property (nonatomic) NSInteger tempMax;
@property (nonatomic) NSInteger tempMin;
@property (strong, nonatomic) NSString* iconName;
@property (nonatomic) NSInteger humidity;
@property (nonatomic) NSInteger pressure;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSInteger)KelvinToFahrenheit:(NSInteger)kelvin;

@end
