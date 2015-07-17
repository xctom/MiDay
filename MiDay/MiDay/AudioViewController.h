//
//  AudioViewController.h
//  MiDay
//
//  Created by xuchen on 3/14/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) NSString *audioPath;
- (IBAction)upButtonTapped:(id)sender;
- (IBAction)downButtonTapped:(id)sender;

@end
