//
//  TimelineTableViewCell.h
//  MiDay
//
//  Created by Mingyang Yu on 2/26/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *tagsView;

@end
