//
//  ShowMapViewController.h
//  MiDay
//
//  Created by xuchen on 3/5/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ShowMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) BOOL showBackButton;
- (IBAction)tapBackButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
