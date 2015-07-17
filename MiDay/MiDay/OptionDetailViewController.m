//
//  OptionDetailViewController.m
//  MiDay
//
//  Created by Mingyang Yu on 3/4/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "OptionDetailViewController.h"

@interface OptionDetailViewController ()

@end

@implementation OptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayInfo];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) displayInfo{
    UILabel *tempLabel =(UILabel *)[self.view viewWithTag:123];
    NSString *tempStr = [[NSString alloc] initWithFormat:@"%@",self.selection];
    tempLabel.text =tempStr;
    UITextView * aboutThisVersion = (UITextView *)[self.view viewWithTag:130];
    UITextView * terms = (UITextView *)[self.view viewWithTag:131];
    UITextView * howToUse = (UITextView *) [self.view viewWithTag:132];
    UITextView * reportAproblem = (UITextView *) [self.view viewWithTag:133];
    aboutThisVersion.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    aboutThisVersion.contentOffset = CGPointMake(0, aboutThisVersion.contentOffset.y);
    [aboutThisVersion setHidden:YES];
    [terms setHidden:YES];
    [howToUse setHidden:YES];
    [reportAproblem setHidden:YES];
    if ([self.selection isEqualToString:@"About This Version"]) {
        [aboutThisVersion setHidden:NO];
    }
    else if([self.selection isEqualToString:@"Terms"]){
        [terms setHidden:NO];
        
    }
    else if([self.selection isEqualToString:@"How To Use"]){
        [howToUse setHidden:NO];
    }
    else if([self.selection isEqualToString:@"Report a Problem"]){
        [reportAproblem setHidden:NO];
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

@end
