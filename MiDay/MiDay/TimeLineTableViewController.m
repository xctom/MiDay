//
//  TimeLineTableViewController.m
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "TimeLineTableViewController.h"
#import "Weather.h"
#import "JournalDetailViewController.h"
#import "FileManager.h"
#import "editViewController.h"

@interface TimeLineTableViewController() <UISearchBarDelegate,UISearchResultsUpdating>

@property (strong, nonatomic) NSMutableArray *journals;//The journals fit filter

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray* searchResults;

@end

@implementation TimeLineTableViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    
    //set up search controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    //three search scope
    self.searchController.searchBar.scopeButtonTitles = @[@"Title",@"Content",@"Tag"];
    self.searchController.searchBar.tintColor = [[UIColor alloc] initWithRed:0.204 green:0.286 blue:0.369 alpha:0.9];
    self.searchController.searchBar.delegate = self;
    
    //add search bar to tableview
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
   
    //if segue from category, remove all navigationItem
    if (self.tagFromCategory) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.title = self.tagFromCategory;
    }
}

- (void) viewWillAppear:(BOOL)animated{
    //read journal data
    [self readJournals];
    //reload data
    DLog(@"%lu",(unsigned long)[self.journals count]);
    [self.tableView reloadData];
}

#pragma mark search function
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchText scope:(NSInteger)scope{
    
    NSString* searchAttribute = nil;
    if (scope == 0) {//scope 0 for title
        searchAttribute = @"title";
    }else if(scope == 1){//scope 1 for content
        searchAttribute = @"content";
    }else if(scope == 2){//scope 2 for tags
        searchAttribute = @"tagsString";
    }
    
    NSString* predicteFormat = @"%K contains[c] %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicteFormat,searchAttribute,searchText];
    //update search result
    self.searchResults = [self.journals filteredArrayUsingPredicate:predicate];
}

#pragma mark data operations
- (void) readJournals{
    
    //read data from disk
    NSData* originalData = [[FileManager getFileManager] ReadFromDocumentsByFilename:@"AllJournals.plist"];
    NSArray* journals = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:originalData];
    
    if (journals) {
        self.journals = [[NSMutableArray alloc] initWithArray:journals];
    }else{
        journals = [[NSMutableArray alloc] init];
    }
    
    //check if need to filter journals by tags
    if (self.tagFromCategory) {

        NSString *searchAttribute = @"tagsString";
        NSString *predicteFormat = @"%K CONTAINS[c] %@";
        NSString *trickString = [[NSString alloc] initWithFormat:@",%@,",self.tagFromCategory];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicteFormat,searchAttribute,trickString];
        
        //update journals by tag word
        self.journals = [[NSMutableArray alloc] initWithArray:   [self.journals filteredArrayUsingPredicate:predicate]];
    }
}

#pragma mark table functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //check if the table is the result of the search
    if (self.searchController.active) {
        return [self.searchResults count];
    }else{
        return self.journals.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimelineTableViewCell *cell = (TimelineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"timelineCell" forIndexPath:indexPath];
    
    Journal * tempJournal = nil;
    
    //check if the table is the result of the search
    if (self.searchController.active) {
        tempJournal = (Journal *)[self.searchResults objectAtIndex:indexPath.row];
    }else{
        tempJournal = (Journal *) [self.journals objectAtIndex:indexPath.row];
    }
    
    cell.titleLabel.text = tempJournal.title;
    cell.contentLabel.text = tempJournal.content;
    
    //get month,weekday,day from createTime
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    cell.monthLabel.text = [[dateFormatter stringFromDate:tempJournal.create] uppercaseString];
    [dateFormatter setDateFormat:@"EEE"];
    cell.weekdayLabel.text = [[dateFormatter stringFromDate:tempJournal.create] uppercaseString];
    [dateFormatter setDateFormat:@"dd"];
    cell.dayLabel.text = [dateFormatter stringFromDate:tempJournal.create];
    
    //set image for cell
    UIImage *image;
    if (tempJournal.imagePath) {
        NSData *pngData = [[FileManager getFileManager] ReadFromDocumentsByFilename:tempJournal.imagePath];
        image = [UIImage imageWithData:pngData];
    }else if(tempJournal.weather) {//if no image use weather icon
        image = [UIImage imageNamed:tempJournal.weather.iconName];
    }else{
        //check create time to set right value to night_mode
        [dateFormatter setDateFormat:@"HH.mm"];
        NSString *strTime = [dateFormatter stringFromDate:tempJournal.create];
        
        if ([strTime floatValue] >= 18.00 || [strTime floatValue]  <= 6.00) {
            //night
            image = [UIImage imageNamed:@"night_Background"];
        }else{
            //day
            image = [UIImage imageNamed:@"day_Background"];
        }
    }

    cell.thumnailImageView.image = image;
    cell.thumnailImageView.layer.cornerRadius = 33.0;

    
    //check for location
    if (tempJournal.address) {
        cell.locationLabel.text = tempJournal.address;
    }else{
        cell.locationLabel.text = @"";
    }
    
    //check for tags
    
    for (UIView* view in [cell.tagsView subviews]) {
        [view removeFromSuperview];
    }
    
    if (tempJournal.tags) {
    
        float maxWidth = cell.frame.size.width - cell.tagsView.frame.origin.x - 10;
        float labelX = 0, labelY = 0;
        
        for (NSString* str in tempJournal.tags) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labelX,labelY,100,16)];
            
            label.backgroundColor = [[UIColor alloc] initWithRed:0.204 green:0.286 blue:0.369 alpha:0.9];
            label.textColor = [UIColor whiteColor];
            label.text = str;
            
            [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label sizeToFit];
            //create padding manually
            [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
            //set round corner
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            
            labelX += label.frame.size.width + 5;
            
            if (labelX < maxWidth) {
                [cell.tagsView addSubview:label];
            }else{
                break;
            }
            
        }
        
        
    }
    
    return cell;
    
}

#pragma mark edit tableViewCell

- (IBAction)toggleEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        
        [self.editButton setTitle:@"Edit"];
        
    }else {
        // Turn on edit mode
        [self.tableView setEditing:YES animated:YES];
        
        [self.editButton setTitle:@"Done"];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Journal *deleted = [self.journals objectAtIndex:indexPath.row];
        
        //if exists photo, delete it from disk
        [[FileManager getFileManager] RemoveFromDocumentsByFilename:deleted.imagePath];
        
        //delete journal in the array
        [self.journals removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSData* newData = [NSKeyedArchiver archivedDataWithRootObject:self.journals];
        [[FileManager getFileManager] SaveToDocumentsByFilenameAndData:@"AllJournals.plist" data:newData];
        
    }
}

#pragma mark remove inset of tableview
-(void)viewDidLayoutSubviews{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark segue
- (IBAction)unwindEditToTimeLine:(UIStoryboardSegue *)segue{
//get data from edit
    DLog(@"unwind from edit to timeline");
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showJournalDetail"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        Journal* selectedJournal = [self.journals objectAtIndex:indexPath.row];
        JournalDetailViewController* jdc = [segue destinationViewController];
        jdc.fromCategoryView = NO;
        jdc.journal = selectedJournal;
    }else if([[segue identifier] isEqualToString:@"showEditFromTimelineSegue"]){
        editViewController* evc = (editViewController*)[segue.destinationViewController topViewController];
        evc.needUpdateLocation = YES;
        evc.needUpdateWeather = YES;
    }
}


@end
