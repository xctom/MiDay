//
//  editViewController.m
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "editViewController.h"
#import "WeatherManager.h"
#import "FileManager.h"
#import "ShowMapViewController.h"
#import "ChooseTagTableViewController.h"
#import "AudioViewController.h"

@interface editViewController()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic) float scrollWidth;
@property BOOL saveToLibrary;

@end

@implementation editViewController

-(void)viewDidLoad{

    //if journal is nil, it means this is a new journal
    if (self.journal == nil) {
        self.journal = [[Journal alloc] init];
    }
    //Set the initial default save to library to True
    [self settingDidChange];
    // Setting Bundle Notification Center Control
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDidChange) name:NSUserDefaultsDidChangeNotification object:nil];
    [self setUpUI];

    [self addGesturRecognizer];
    
    //update weather and location
    [self updateWeatherAndLocation];
    
    //set delegate
    self.titleTextField.delegate = self;
    [self addDoneToolBarToKeyboard:self.contentTextView];
    
    //set keyboard observer
    [self observeKeyboard];
    
}
- (void) settingDidChange{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    self.saveToLibrary = [defaults boolForKey:@"saveToLibrary"];
    DLog(@"%i",(int)self.saveToLibrary);
}

-(void)setUpUI{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd EEE YYYY HH:mm a"];
    self.createDateLabel.text = [df stringFromDate:self.journal.create];
    
    self.titleTextField.text = self.journal.title;
    self.contentTextView.text = self.journal.content;
    
    //chekc if there is weather info
    if (self.journal.weather) {
        self.weatherBarItem.image = [UIImage imageNamed:self.journal.weather.iconName];
    }
    
    //check if there is location info
    if (self.locationBarItem) {
        self.locationBarItem.image = [UIImage imageNamed:@"Location-100"];
    }
    
    //check if there is a image
    if (self.journal.imagePath) {
        NSData *pngData = [[FileManager getFileManager] ReadFromDocumentsByFilename:self.journal.imagePath];
        self.cameraImageView.image = [UIImage imageWithData:pngData];
        
    }
    
    //set tags in scrollview
    [self setTags];
}


#pragma mark keyboard

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)addDoneToolBarToKeyboard:(UITextView *)textView{

    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

-(void)doneButtonClickedDismissKeyboard{
    [self.contentTextView resignFirstResponder];
}

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// The callback for frame-changing of keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    DLog(@"Updating constraints.");
    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // we need to set a negative constant value here.
    self.keyBoardConstraint.constant = -height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyBoardConstraint.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark gesture
-(void) addGesturRecognizer{
    //add panGestureRecognizer for X
    UITapGestureRecognizer* cameraTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCameraActionSheet:)];
    [cameraTapRecognizer setDelegate:self];
    cameraTapRecognizer.numberOfTapsRequired = 1;
    [self.cameraImageView addGestureRecognizer:cameraTapRecognizer];
}

#pragma mark segue
- (void)unwindToEdit:(UIStoryboardSegue *)segue{
    DLog(@"unwind from choose tags!");
    //code for display tags
    
    //clear all labels in the scroll view
    for (UIView* view in self.tagScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [self setTags];
}

- (void)setTags{
    float labelX = 0, labelY = 0;
    for (NSString* str in self.journal.tags) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labelX,labelY,100,20)];
        
        label.backgroundColor = [[UIColor alloc] initWithRed:0.204 green:0.286 blue:0.369 alpha:0.9];
        label.textColor = [UIColor whiteColor];
        label.text = str;
        
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label sizeToFit];
        //create padding manually
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        //set round corner
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        
        labelX += label.frame.size.width + 5;
        [self.tagScrollView addSubview:label];
    }
    
    self.scrollWidth = labelX;
}

- (void)viewDidLayoutSubviews{
    self.tagScrollView.contentSize = CGSizeMake(self.scrollWidth, 30);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.saveButton){
        [self saveData];
    }else if([segue.identifier isEqualToString:@"chooseTagsSegue"]){
        ChooseTagTableViewController *cttc = (ChooseTagTableViewController*)segue.destinationViewController;
        //assign chosen tags
        cttc.chosenTags = self.journal.tags;
    }else if([segue.identifier isEqualToString:@"audioSegue"]){
        AudioViewController *avc = (AudioViewController*)segue.destinationViewController;
        avc.audioPath = self.journal.audioPath;
    }
}

- (void)saveData{
    
    self.journal.title = self.titleTextField.text;
    self.journal.content = self.contentTextView.text;
    
    //if has tags, join them into string for searching
    if (self.journal.tags) {
        self.journal.tagsString = [[NSString alloc] initWithFormat:@",%@,",[self.journal.tags componentsJoinedByString:@","]];
    }
    
    //read data from disk
    NSData* originalData = [[FileManager getFileManager] ReadFromDocumentsByFilename:@"AllJournals.plist"];
    NSArray* journals = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:originalData];
    
    //chekc if there is already data in plist
    //if not create one
    NSMutableArray *newArray = nil;
    
    if (journals) {
        newArray = [[NSMutableArray alloc] initWithArray:journals];
    } else {
        newArray = [[NSMutableArray alloc] init];
    }
    
    //check if it is a exsiting journal
    BOOL found = NO;
    for (int i = 0; i < [newArray count]; i++) {
        Journal *temp = (Journal*)[newArray objectAtIndex:i];
        if ([temp.create isEqualToDate:self.journal.create]) {
            [newArray replaceObjectAtIndex:i withObject:self.journal];
            found = YES;
            break;
        }
    }
    
    if (!found) {
        //insert this object on the front of the data
        [newArray insertObject:self.journal atIndex:0];
    }
    
    //encode data
    NSData* newJournalData = [NSKeyedArchiver archivedDataWithRootObject:newArray];
    
    //write to file
    [[FileManager getFileManager] SaveToDocumentsByFilenameAndData:@"AllJournals.plist" data:newJournalData];
}

#pragma mark Weather and location

- (void)updateWeatherAndLocation{
    [self CheckAndStartLocationManager];
}

- (void)deleteWeather{
    self.journal.weather = nil;
    self.weatherBarItem.image = [UIImage imageNamed:@"Barometer-100"];
}

- (void)updateWeatherByCoord:(CLLocationCoordinate2D)coord{
    [[WeatherManager getWeatherManager] getWeatherForCoord:coord
                                                   success:^(NSDictionary *dictionary, NSError *error) {
                                                       DLog(@"%@",dictionary);
                                                       
                                                       //use dictionary to create Weather object here and assign it to self.journal
                                                       Weather* weather = [[Weather alloc] initWithDictionary:dictionary];
                                                       
                                                       self.journal.weather = weather;
                                                       
                                                       //update UI element
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           DLog(@"%@",weather.iconName);
                                                           self.weatherBarItem.image = [UIImage imageNamed:weather.iconName];
                                                       });
                                                       
                                                   }
                                                   failure:^{
                                                       UIAlertView *alert = [[UIAlertView alloc]
                                                                             initWithTitle:@"Network Error"
                                                                             message:@"Cannot connect to Internet"
                                                                             delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil];
                                                       [alert show];
                                                       
                                                       //update UI element
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           self.weatherBarItem.image = [UIImage imageNamed:@"Barometer-100"];
                                                       });
                                                   }];
}

/**
 *  check if locationmanager is nil
 *  if so, create one
 *  start to update location
 */
- (void)CheckAndStartLocationManager{
    if(self.locationManager == nil){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    }else{
        [self.locationManager startUpdatingLocation];
    }
    
    if (self.geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
}

/**
 *  delete location attribute and update image of locationBarItem
 */
- (void)deleteLocation{
    self.journal.location = nil;
    self.journal.address = nil;
    self.locationBarItem.image = [UIImage imageNamed:@"Map Marker-100"];
}

/**
 *  check for AuthorizationStatus
 *  if Authorized, set up and start up update location
 *  else alert to report error
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager setDistanceFilter:500];
        [manager setDesiredAccuracy:kCLLocationAccuracyBest];
        [manager setHeadingFilter:kCLDistanceFilterNone];
        manager.activityType = CLActivityTypeFitness;
        [manager startUpdatingLocation];
    }else{
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Wrong Authorization Status"
//                              message:@"Unathorized to get location data"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocationCoordinate2D coordinate = [[locations firstObject] coordinate];
    
    //check if need to update location data of journal
    if (self.needUpdateLocation) {
        //update location variable in Journal and update baritem image
        self.journal.location = [locations firstObject];
        self.locationBarItem.image = [UIImage imageNamed:@"Location-100"];
        
        //get address from location
        DLog(@"Resolving the Address");
        [self.geocoder reverseGeocodeLocation:self.journal.location completionHandler:^(NSArray *placemarks, NSError *error) {
            //DLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                self.journal.address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@ %@",
                                        (placemark.subThoroughfare)?placemark.subThoroughfare:@"",
                                        (placemark.thoroughfare)?placemark.thoroughfare:@"",
                                        (placemark.postalCode)?placemark.postalCode:@"",
                                        (placemark.locality)?placemark.locality:@"",
                                        (placemark.administrativeArea)?placemark.administrativeArea:@"",
                                        (placemark.country)?placemark.country:@""];
            } else {
                DLog(@"%@", error.debugDescription);
            }
        } ];
        //code for journal
    }
    
    //check if need to update weather data of journal
    if (self.needUpdateWeather) {
        [self updateWeatherByCoord:coordinate];
    }

    //turn off locationManager to save battery
    [self.locationManager stopUpdatingLocation];
}

#pragma mark Photos

- (void)showGallery{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)showCamera{
    //if we run the application on the simulator, it will crash
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
        
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)deletePhoto{
    self.journal.imagePath = nil;
    self.cameraImageView.image = [UIImage imageNamed:@"SLR Camera-100"];
}

/**
 *  Dismiss view if click "cancel"
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/**
 *  If pick a image, save it
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    //crop image to square
    //http://stackoverflow.com/questions/17712797/ios-custom-uiimagepickercontroller-camera-crop-to-square
    CGSize imageSize = chosenImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
        [chosenImage drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                 blendMode:kCGBlendModeCopy
                     alpha:1.];
        chosenImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    //save image to document by FileManager
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    
    //create imageName by create Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString* imageName = [[NSString alloc] initWithFormat:@"%@.png",[dateFormatter stringFromDate:self.journal.create]];
    
    [[FileManager getFileManager] SaveToDocumentsByFilenameAndData:imageName data:pngData];
    
    //show image in the view
    self.cameraImageView.image = chosenImage;
    
    //check if need to save image to photos
    if (self.saveToLibrary) {
        DLog(@"SaveToLibrary is true");
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:pngData], nil, nil, nil);
    }else{
        DLog(@"SaveToLibrary false");
    }
    
    self.journal.imagePath = imageName;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark action sheets

- (IBAction)showWeatherActionSheet:(id)sender {
    
    NSString *weatherDescription;
    
    if (self.journal.weather) {
        weatherDescription = [self.journal.weather description];
    }else{
        weatherDescription = @"No weather description";
    }
    
    UIActionSheet *weatherSheet = [[UIActionSheet alloc] initWithTitle:weatherDescription
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@"Remove weather"
                                                     otherButtonTitles:@"Get weather", nil];
    //set tag for delegate method
    weatherSheet.tag = 101;
    [weatherSheet showInView:self.view];
    
}

- (IBAction)showMapActionSheet:(id)sender {
    
    NSString *locationDescription;
    
    if (self.journal.location) {
        locationDescription = self.journal.address;
    }else{
        locationDescription = @"No location information";
    }
    
    UIActionSheet *mapSheet = [[UIActionSheet alloc] initWithTitle:locationDescription
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:@"Remove location"
                                                 otherButtonTitles:@"Get location", @"Show in map", nil];
    //set tag for delegate method
    mapSheet.tag = 102;
    [mapSheet showInView:self.view];
}

- (IBAction)showCameraActionSheet:(id)sender {
    
    UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:@"Add photos to your journal"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Remove photo"
                                                    otherButtonTitles:@"Take a photo", @"Pick from photos", nil];
    //set tag for delegate method
    cameraSheet.tag = 103;
    [cameraSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 101) {
        DLog(@"WEATHER, %ld",(long)buttonIndex);
        
        if (buttonIndex == 1) { //get weather
            //only update weather
            self.needUpdateWeather = YES;
            self.needUpdateLocation = NO;
            [self updateWeatherAndLocation];
        }else if (buttonIndex == 0){//delete weather
            [self deleteWeather];
        }
        
    }else if (actionSheet.tag == 102){
        DLog(@"LOCATION, %ld", (long)buttonIndex);
        
        if (buttonIndex == 0) { //delete location
            [self deleteLocation];
        }else if (buttonIndex == 1){ //get location
            self.needUpdateLocation = YES;
            self.needUpdateWeather = NO;
            [self updateWeatherAndLocation];
        }else if (buttonIndex == 2){
            
            if (self.journal.location) {
                ShowMapViewController *smvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowMapViewController"];
                smvc.location = self.journal.location;
                smvc.showBackButton = YES;
                smvc.modalTransitionStyle= UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:smvc animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"No location information"
                                      message:@"Cannot show in map because there is no location information"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }

        }
        
    }else if (actionSheet.tag == 103){
        DLog(@"PHOTOS, %ld", (long)buttonIndex);
        
        if (buttonIndex == 0) {
            [self deletePhoto];
        }else if (buttonIndex == 1){
            [self showCamera];
        }else if (buttonIndex == 2){
            [self showGallery];
        }
        
    }

}


@end
