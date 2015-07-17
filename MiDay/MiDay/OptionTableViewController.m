//
//  OptionTableViewController.m
//  MiDay
//
//  Created by Mingyang Yu on 3/4/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "OptionTableViewController.h"
#import "OptionDetailViewController.h"
@implementation OptionTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"options" ofType:@"plist"];
    
    //We create an NSDictionary instance from the property list we added to our project and assigned it to names.
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.names = dict;
    NSArray *array = [self.names allKeys];
    self.keys = array;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Setting Up Grouped Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //Specifies the number of sections.
    
    return [self.keys count];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Calculates the number of rows in a specific section.
    
    NSString *key = [self.keys objectAtIndex:section];
    
    NSArray *name = [self.names objectForKey:key];
    
    return [name count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //The indexPath.section will tell us which array to pull out of the names dictionary.
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    NSArray *name = [self.names objectForKey:key];
    static NSString *cellID = @"optionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.textLabel.text = [name objectAtIndex:indexPath.row];
    
    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    //Set the header value for each section. We return the letter for this group.
    
    NSString *key = [_keys objectAtIndex:section];
    
    return key;
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
// prepare for segue.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detailOption"]) {
        OptionDetailViewController *odvc = [segue destinationViewController];
        NSIndexPath *indexPath =[self.tableView indexPathForSelectedRow];
        NSInteger selectedRow = indexPath.row;
        NSInteger selectedSection = indexPath.section;
        NSString *key = [self.keys objectAtIndex:selectedSection];
        NSArray *name = [self.names objectForKey:key];
        [odvc setSelection:[name objectAtIndex:selectedRow]];

    }
}



@end
