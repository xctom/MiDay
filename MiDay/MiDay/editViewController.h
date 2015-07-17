//
//  editViewController.h
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "Journal.h"

@interface editViewController : UIViewController <CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIScrollViewDelegate>

//public variables
@property (strong, nonatomic) Journal* journal;//The journal Item editing
@property BOOL needUpdateWeather;
@property BOOL needUpdateLocation;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyBoardConstraint;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

//toolbar item and actions
@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *weatherBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationBarItem;

- (IBAction)showWeatherActionSheet:(id)sender;
- (IBAction)showMapActionSheet:(id)sender;
- (IBAction)showCameraActionSheet:(id)sender;

//unwind
- (IBAction)unwindToEdit:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIScrollView *tagScrollView;

@end
