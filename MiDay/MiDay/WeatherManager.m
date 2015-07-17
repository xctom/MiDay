//
//  WeatherManager.m
//  MiDay
//
//  Created by xuchen on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "WeatherManager.h"

@interface WeatherManager()

@property (strong,nonatomic) NSDate* lastRequestTime;
@property (strong,nonatomic) NSDictionary* lastWeatherData;
@property (strong,nonatomic) NSDictionary* iconDict;

@end

@implementation WeatherManager

/**
 *  check if there is already an instance, if not alloc one
 *  return the instance of the singleton
 */
+ (id)getWeatherManager{
    //structure used to test whether the block has complete or not
    static dispatch_once_t p = 0;
    
    //initialize sharedObject as nil(first call only)
    static WeatherManager *shared= nil;
    
    //executes a block object once and only once for the application lifetime
    dispatch_once(&p, ^{
        shared = [[self alloc] init];
    });
    
    //returhs the same objec each time
    return shared;
}

- (id)init{
    if(self = [super init]){
        self.iconDict = @{@"01d":@"Sun-100",
                          @"01n":@"Moon-100",
                          @"02d":@"Partly Cloudy Day-100",
                          @"02n":@"Partly Cloudy Night-100",
                          @"03d":@"Clouds-100",
                          @"03n":@"Clouds-100",
                          @"04d":@"Clouds-100",
                          @"04n":@"Clouds-100",
                          @"09d":@"Rain-100",
                          @"09n":@"Rain-100",
                          @"10d":@"Little Rain-100",
                          @"10n":@"Little Rain-100",
                          @"11d":@"Storm-100",
                          @"11n":@"Storm-100",
                          @"13d":@"Snow-100",
                          @"13n":@"Snow-100",
                          @"50d":@"Fog Day-100",
                          @"50n":@"Fog Night-100"
                          };
    }
    return self;
}

#pragma mark - Requests
- (void)getWeatherForCoord:(CLLocationCoordinate2D)coord
                   success:(void (^)(NSDictionary *, NSError *))successCompletion
                   failure:(void (^)(void))failureCompletion{
    
    BOOL needRequest = YES;
    NSDate* now = [NSDate date];
    
    //check if the last query is in 10 minute
    if (self.lastRequestTime) {
        if([now timeIntervalSinceDate:self.lastRequestTime] < 600){
            needRequest = NO;
        }
    }
    
    //if the first request, set current time
    self.lastRequestTime = [NSDate date];
    
    if (needRequest) {
        
        float longitude = coord.longitude;
        float latitude = coord.latitude;
        
        DLog(@"dLongitude : %f,dLatitude : %f",longitude,latitude);
        
        //get weather data from openweathermap appid = a812f5be248c228b1699c421f61f7243
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=a812f5be248c228b1699c421f61f7243",latitude,longitude];
        
        [[NetworkManager getNetworkManager] getFeedForURL:urlString
                                                  success:^(NSDictionary *weatherData, NSError *err){
                                                      self.lastWeatherData = weatherData;
                                                      //call the block
                                                      successCompletion(weatherData,err);
                                                  }
                                                  failure:failureCompletion];
    }else{

        if (self.lastWeatherData) {
            DLog(@"lastWeatherData");
            //call successCompletion directly
            successCompletion(self.lastWeatherData,nil);
        }else{
            DLog(@"faliure");
            //call failure directly
            failureCompletion();
        }
    }

}

- (NSString*)getIconImageName:(NSString*)iconName{
    return [self.iconDict objectForKey:iconName];
}

@end
