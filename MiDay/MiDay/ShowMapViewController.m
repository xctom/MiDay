//
//  ShowMapViewController.m
//  MiDay
//
//  Created by xuchen on 3/5/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "ShowMapViewController.h"

@interface ShowMapViewController ()

@property (nonatomic) MKCoordinateRegion adjustRegion;

@end

@implementation ShowMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    if (self.showBackButton) {
        self.backButton.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapViewWillStartRenderingMap:(MKMapView *)mapView{
    
    if ([self.mapView.annotations count] == 0) {
        DLog(@"la:%f, lo:%f",self.location.coordinate.latitude,self.location.coordinate.longitude);
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, METERS_PER_MILE / 5, METERS_PER_MILE / 5);
        self.adjustRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:self.adjustRegion animated:NO];
        
        for (id annotation in self.mapView.annotations) {
            [self.mapView removeAnnotation:annotation];
        }
        
        //add pin
        MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        pin.coordinate = self.location.coordinate;
        [self.mapView addAnnotation:pin];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"current"];
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    return pinAnnotationView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapBackButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
