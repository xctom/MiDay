//
//  WeatherManager.h
//  MiDay
//
//  Created by xuchen on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "NetworkManager.h"

@interface WeatherManager : NSObject
/**
 *  Singleton declaration
 *
 *  @return a instance of the class
 */
+ (id) getWeatherManager;

- (void) getWeatherForCoord:(CLLocationCoordinate2D)coord
               success:(void (^)(NSDictionary *weatherData, NSError *error))successCompletion
               failure:(void (^)(void)) failureCompletion;

- (NSString*)getIconImageName:(NSString*)iconName;
@end
