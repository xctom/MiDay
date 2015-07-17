//
//  JournalDetailViewController.m
//  MiDay
//
//  Created by xuchen on 3/2/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "JournalDetailViewController.h"
#import "FileManager.h"
#import "ShowImageViewController.h"
#import "ShowMapViewController.h"
#import "editViewController.h"

@interface JournalDetailViewController ()

@property (nonatomic) float scrollWidth;

@end

@implementation JournalDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    if (self.fromCategoryView) {
        self.editBarButton.title = @"";
        self.editBarButton.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up delegate
    self.mapView.delegate = self;
    
    if (self.fromMapView) {
        self.backButton.hidden = NO;
        self.photoImageView.userInteractionEnabled = NO;
        self.mapView.userInteractionEnabled = NO;
    }
    
    [self setUpUI];
}

- (void)setUpUI{
    
    self.navigationItem.title = @"Journal";
    
    //set value for ui element
    self.titleLabel.text = self.journal.title;
    self.contentTextView.text = self.journal.content;
    self.contentTextView.font = [UIFont fontWithName:@"Helvetica" size:15];
    [self.contentTextView scrollRangeToVisible: NSMakeRange(0, 1)];
    
    //weather
    self.weatherDetailLabel.text = self.journal.weather.detail;
    self.weatherImageView.image = [UIImage imageNamed:self.journal.weather.iconName];
    self.weatherTempLabel.text = [[NSString alloc] initWithFormat:@"%ld℉",(long)self.journal.weather.temp];
    
    //address
    self.locationLabel.text = self.journal.address;
    
    //date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM dd, YYYY"];
    self.dateLabel.text = [dateFormatter stringFromDate:self.journal.create];
    
    //image
    if (self.journal.imagePath) {
        NSData *pngData = [[FileManager getFileManager] ReadFromDocumentsByFilename:self.journal.imagePath];
        self.photoImageView.image = [UIImage imageWithData:pngData];
    }else{
        //check create time to set right value to night_mode
        [dateFormatter setDateFormat:@"HH.mm"];
        NSString *strTime = [dateFormatter stringFromDate:self.journal.create];
        
        if ([strTime floatValue] >= 18.00 || [strTime floatValue]  <= 6.00) {
            //night
            self.photoImageView.image = [UIImage imageNamed:@"night_Background"];
        }else{
            //day
            self.photoImageView.image = [UIImage imageNamed:@"day_Background"];
        }
        
        [self.photoImageView setUserInteractionEnabled:NO];
    }
    
    //location
    if (!self.journal.location) {
        [self.mapView setUserInteractionEnabled:NO];
    }
    
    [self setTags];
}

- (void)setTags{
    float labelX = 0, labelY = 0;
    for (NSString* str in self.journal.tags) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labelX,labelY,100,18)];
        
        label.backgroundColor = [[UIColor alloc] initWithRed:0.204 green:0.286 blue:0.369 alpha:0.9];
        label.textColor = [UIColor whiteColor];
        label.text = str;
        
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label sizeToFit];
        //create padding manually
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        //set round corner
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        
        labelX += label.frame.size.width + 5;
        [self.tagsScrollView addSubview:label];
    }
    
    self.scrollWidth = labelX;
}

- (void)viewDidLayoutSubviews{
    self.tagsScrollView.contentSize = CGSizeMake(self.scrollWidth, 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark segue
//- (IBAction)unwindEditToDetail:(UIStoryboardSegue *)segue{
//    //get data from edit
//    DLog(@"unwind from edit to detail");
//    
//}


#pragma mark mapView
-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    
    if (self.journal.location) {
        DLog(@"la:%f, lo:%f",self.journal.location.coordinate.latitude,self.journal.location.coordinate.longitude);
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.journal.location.coordinate, METERS_PER_MILE/3, METERS_PER_MILE/3);
        MKCoordinateRegion adjustRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustRegion animated:NO];
        
        for (id annotation in self.mapView.annotations) {
            [mapView removeAnnotation:annotation];
        }
        
        //add pin
        MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        pin.coordinate = self.journal.location.coordinate;
        [mapView addAnnotation:pin];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"current"];
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    return pinAnnotationView;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showImageSegue"]) {
        
        ShowImageViewController* sivc = (ShowImageViewController*)[segue destinationViewController];
        DLog(@"%@",self.photoImageView.image);
        sivc.image = self.photoImageView.image;
        
    }else if([segue.identifier isEqualToString:@"showMapSegue"]) {
       
        ShowMapViewController* smvc = (ShowMapViewController*)[segue destinationViewController];
        smvc.location = self.journal.location;
        smvc.showBackButton = NO;
        
    }else if([segue.identifier isEqualToString:@"showEditFromDetailSegue"]){
        
        editViewController* evc = (editViewController*)[segue.destinationViewController topViewController];
        evc.needUpdateLocation = NO;
        evc.needUpdateWeather = NO;
        evc.journal = self.journal;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)DismissView:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
