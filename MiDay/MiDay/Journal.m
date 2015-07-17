//
//  Journal.m
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "Journal.h"

@implementation Journal

- (id)init{
    self = [super init];
    if (self) {
        self.create = [NSDate date];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.weather forKey:@"weather"];
    [encoder encodeObject:self.create forKey:@"date"];
    [encoder encodeObject:self.lastModified forKey:@"lastModified"];
    [encoder encodeObject:self.tags forKey:@"tags"];
    [encoder encodeObject:self.weekday forKey:@"weekday"];
    [encoder encodeObject:self.imagePath forKey:@"imagePath"];
    [encoder encodeObject:self.audioPath forKey:@"audioPath"];
    [encoder encodeObject:self.videoPath forKey:@"videoPath"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.tagsString forKey:@"tagsString"];
    
}
- (id) initWithCoder:(NSCoder *)decoder{
    self = [super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.content = [decoder decodeObjectForKey:@"content"];
    self.weather = [decoder decodeObjectForKey:@"weather"];
    self.create = [decoder decodeObjectForKey:@"date"];
    self.lastModified = [decoder decodeObjectForKey:@"lastModified"];
    self.tags = [decoder decodeObjectForKey:@"tags"];
    self.weekday = [decoder decodeObjectForKey:@"weekday"];
    self.imagePath = [decoder decodeObjectForKey:@"imagePath"];
    self.audioPath = [decoder decodeObjectForKey:@"audioPath"];
    self.videoPath = [decoder decodeObjectForKey:@"videoPath"];
    self.address = [decoder decodeObjectForKey:@"address"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.tagsString = [decoder decodeObjectForKey:@"tagsString"];
    return self;
}
@end
