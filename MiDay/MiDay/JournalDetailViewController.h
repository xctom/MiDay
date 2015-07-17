//
//  JournalDetailViewController.h
//  MiDay
//
//  Created by xuchen on 3/2/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Journal.h"

@interface JournalDetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) Journal* journal;//The journal to show

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

//outlets for bottom section
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDetailLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *tagsScrollView;

//- (IBAction)unwindEditToDetail:(UIStoryboardSegue *)segue;
@property (nonatomic) BOOL fromCategoryView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButton;

@property (nonatomic) BOOL fromMapView;//BOOL for show back button
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)DismissView:(id)sender;


@end
