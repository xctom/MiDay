//
//  MapViewController.m
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "MapViewController.h"
#import "FileManager.h"
#import "Journal.h"
#import "JournalDetailViewController.h"

@interface MapViewController()

@property (strong, nonatomic) NSMutableArray* journals;//The journals with locations
@property (strong, nonatomic) NSMutableArray* annotationArr;

@end

@implementation MapViewController

-(void)viewDidLoad{
    //set delegate
    self.mapView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.journals == nil) {
        self.journals = [[NSMutableArray alloc] init];
    }

    [self loadJournalsWithLocation];
}

-(void)loadJournalsWithLocation{
    NSData * originalData= [[FileManager getFileManager] ReadFromDocumentsByFilename:@"AllJournals.plist"];
    NSArray* tempJournals = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:originalData];
    
    for (Journal *journal in tempJournals) {
        //only add journals with location
        if (journal.location) {
            [self.journals addObject:journal];
        }
    }
}

-(void)mapViewWillStartRenderingMap:(MKMapView *)mapView{
    DLog(@"start!");
    //add pins only when there is no pins
    if ([self.mapView.annotations count] == 0) {
        
        //remove all original annotations
        for (id annotation in self.mapView.annotations) {
            [self.mapView removeAnnotation:annotation];
        }
        
        //add pin
        self.annotationArr = [[NSMutableArray alloc] init];
        
        //dateformatter for subtitle
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM dd EEE YYYY HH:mm a"];
        
        for (Journal* journal in self.journals) {
            MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
            pin.title = journal.title;
            pin.subtitle = [df stringFromDate:journal.create];
            pin.coordinate = journal.location.coordinate;
            [self.mapView addAnnotation:pin];
            [self.annotationArr addObject:pin];
        }
        
        [self.mapView showAnnotations:self.annotationArr animated:NO];
    }

}

//customize annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"current"];
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.enabled = YES;
    pinAnnotationView.canShowCallout = YES;
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    
    NSInteger cheatTag = [self.annotationArr indexOfObject:annotation] + 1;
    Journal *journal = [self.journals objectAtIndex:cheatTag - 1];
    pinAnnotationView.tag = cheatTag;
    
    UIImage *image;
    //image
    if (journal.imagePath) {
        NSData *pngData = [[FileManager getFileManager] ReadFromDocumentsByFilename:journal.imagePath];
        image = [UIImage imageWithData:pngData];
    }else{
        if (journal.weather) {
            image = [UIImage imageNamed:journal.weather.iconName];
        }
    }
    
    pinAnnotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:image];
    pinAnnotationView.leftCalloutAccessoryView.frame = CGRectMake(0, 0, 40, 40);
    pinAnnotationView.leftCalloutAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
    
    pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    //when an annotation is tapped 
    Journal* journal = (Journal*)[self.journals objectAtIndex:view.tag - 1];
    
    JournalDetailViewController *jdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"JournalDetailViewController"];
    
    jdvc.journal = journal;
    jdvc.fromMapView = YES;
    
    //smvc.showBackButton = YES;
    jdvc.modalTransitionStyle= UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:jdvc animated:YES completion:nil];
    
}
@end
