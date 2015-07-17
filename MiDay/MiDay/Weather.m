//
//  Weather.m
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "Weather.h"
#import "WeatherManager.h"

@implementation Weather

- (id)initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    
    if (self && dictionary) {
        self.temp = [self KelvinToFahrenheit:[(NSString*)dictionary[@"main"][@"temp"] integerValue]];
        self.tempMax = [self KelvinToFahrenheit:[(NSString*)dictionary[@"main"][@"temp_max"] integerValue]];
        self.tempMin = [self KelvinToFahrenheit:[(NSString*)dictionary[@"main"][@"temp_min"] integerValue]];
        self.humidity = [(NSString*)dictionary[@"main"][@"humidity"] integerValue];
        self.pressure = [(NSString*)dictionary[@"main"][@"pressure"] integerValue];
        self.detail = (NSString*)dictionary[@"weather"][0][@"description"];
        self.iconName = [[WeatherManager getWeatherManager] getIconImageName:(NSString*)dictionary[@"weather"][0][@"icon"]];
        //should set icon here
    }

    return self;
}

- (NSInteger)KelvinToFahrenheit:(NSInteger)kelvin{
    return (NSInteger)(1.8 * kelvin - 459.67);
}
                     
- (NSString*)description{
    return [[NSString alloc] initWithFormat:@"Detail: %@\nTemprature: %ld℉ H: %ld℉ L: %ld℉ \nHumidity: %ld\nPressure: %ldPa\nPowered By: OpenWeatherMap",self.detail,(long)self.temp,(long)self.tempMax,(long)self.tempMin,(long)self.humidity,(long)self.pressure];
}

- (void) encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.detail forKey:@"detail"];
    [encoder encodeInt:(int)self.temp forKey:@"temp"];
    [encoder encodeInt:(int)self.tempMax forKey:@"tempMax"];
    [encoder encodeInt:(int)self.tempMin forKey:@"tempMin"];
    [encoder encodeObject:self.iconName forKey:@"iconName"];
    [encoder encodeInt:(int)self.humidity forKey:@"humidity"];
    [encoder encodeInt:(int)self.pressure forKey:@"pressure"];
}

- (id) initWithCoder:(NSCoder *)decoder{
    self = [super init];
    self.detail = [decoder decodeObjectForKey:@"detail"];
    self.temp = [decoder decodeIntForKey:@"temp"];
    self.tempMax = [decoder decodeIntForKey:@"tempMax"];
    self.tempMin = [decoder decodeIntForKey:@"tempMin"];
    self.iconName = [decoder decodeObjectForKey:@"iconName"];
    self.humidity = [decoder decodeIntForKey:@"humidity"];
    self.pressure = [decoder decodeIntForKey:@"pressure"];
    return self;
}

@end
