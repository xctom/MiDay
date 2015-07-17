//
//  AppDelegate.m
//  MiDay
//
//  Created by xuchen on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "AppDelegate.h"
#import "FileManager.h"
@interface AppDelegate ()
@property (strong, nonatomic) NSMutableArray* tags;
@end

@implementation AppDelegate
- (void) createFakeTags{
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    // Create Default Tag Names:
    NSString *tag1 = @"Love";
    NSString *tag2 = @"Photo Of the Day";
    NSString *tag3 = @"Me";
    NSString *tag4 = @"Cute";
    NSString *tag5 = @"Health";
    NSString *tag6 = @"Sports";
    NSString *tag7 = @"Sad";
    NSString *tag8 = @"Summer";
    NSString *tag9 = @"Beautiful";
    [tempArray addObject:tag1];
    [tempArray addObject:tag2];
    [tempArray addObject:tag3];
    [tempArray addObject:tag4];
    [tempArray addObject:tag5];
    [tempArray addObject:tag6];
    [tempArray addObject:tag7];
    [tempArray addObject:tag8];
    [tempArray addObject:tag9];
    self.tags = tempArray;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Georgia-BoldItalic
    // Cochin-BoldItalic
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSUnderlineStyleAttributeName: @1,
                                                           NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:15],
                                                           }];
    
    // Add date for the app first launch.
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstTimeLaunch"];
    if (!date) {
        // This is the 1st run of the app
        date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"firstTimeLaunch"];
    }
    NSLog(@"First run was %@", date);
    
    NSArray *tempTags = [[NSArray alloc] init];
    NSData *tagsData = [[FileManager getFileManager] ReadFromDocumentsByFilename:@"Tags.plist"];
    if (tagsData ==nil){
        NSLog(@"File has not been set up yet");
        [self createFakeTags];
        tempTags = self.tags;
        NSData * saveTagData = [NSKeyedArchiver archivedDataWithRootObject:tempTags];
        [[FileManager getFileManager] SaveToDocumentsByFilenameAndData:@"Tags.plist" data:saveTagData];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
