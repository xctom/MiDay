//
//  OptionTableViewController.h
//  MiDay
//
//  Created by Mingyang Yu on 3/4/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionTableViewController : UITableViewController
@property (strong,nonatomic) NSDictionary *names;
@property (strong,nonatomic) NSArray *keys;
@property (nonatomic) NSInteger tableSection;
@property (nonatomic) NSInteger tableRow;
@end
