//
//  TimeLineTableViewController.h
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineTableViewCell.h"
#import "Journal.h"

@interface TimeLineTableViewController : UITableViewController 

@property (strong, nonatomic) NSString *tagFromCategory;//for segue from category

- (IBAction)unwindEditToTimeLine:(UIStoryboardSegue *)segue;

- (IBAction)toggleEditMode:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
