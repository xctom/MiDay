//
//  CategoryViewController.m
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "CategoryViewController.h"
#import "FileManager.h"
#import "Journal.h"
#import "JournalDetailViewController.h"
#import "TimeLineTableViewController.h"

@interface CategoryViewController()
@property (weak, nonatomic) IBOutlet UILabel *pictureLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (strong, nonatomic) NSMutableArray* tags;//tags for tagView
@property (strong, nonatomic) NSMutableArray* journals;//journals with Photo
@property (strong, nonatomic) NSMutableArray *pictures;


@property BOOL addTagViewLocationOutbound;
@end

@implementation CategoryViewController

#pragma mark Read Tags from Disc
- (void) readTags{
    // read Tags data from disc
    NSArray *tempTags = [[NSArray alloc] init];
    NSData *tagsData = [[FileManager getFileManager] ReadFromDocumentsByFilename:@"Tags.plist"];
    tempTags = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:tagsData];
    self.tags =(NSMutableArray *) tempTags;
    DLog(@"Here in the readTags: %lu",(unsigned long)self.tags.count);
    
}

#pragma mark View Will Appear
-(void) viewWillAppear:(BOOL)animated{
    //readTags from the disc
    [self readTags];
    //set inital tagViewBound to outside true
    self.addTagViewLocationOutbound = true;
    //Load tableView
    [self loadImagesFromJournals];
    [self.tableView reloadData];
    //read Pictures from the disc
    //load picture Views
    [self.pictureTableView reloadData];
}

#pragma mark view Did Load
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Initialize the view for viewDidLoad
    
    //show tableView, hide PictureView
    [self.pictureTableView setHidden:YES];
    [self.tableView setHidden:NO];
    [self.editTagButton setTitle:@"Edit"];
    [self.editTagButton setEnabled:YES];
    [self.addTagButton setTitle:@"Add"];
    [self.addTagButton setEnabled:YES];
    self.tagNameTextField.delegate = self;
    
    // Label Tag and Picture touch enable
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabel:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabel:)];
    tap.numberOfTapsRequired=1;
    [self.tagsLabel setUserInteractionEnabled:YES];
    [self.pictureLabel setUserInteractionEnabled:YES];
    [self.tagsLabel addGestureRecognizer:tap];
    [self.pictureLabel addGestureRecognizer:tap1];
    [self.tagsLabel setTextColor:[UIColor blackColor]];
    [self.pictureLabel setTextColor:[UIColor grayColor]];

    self.automaticallyAdjustsScrollViewInsets=NO;
    
}

#pragma mark segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"CategoryPictureToDetailSegue"]) {
        JournalDetailViewController *jdvc = (JournalDetailViewController*)segue.destinationViewController;
        NSIndexPath *index = [self.pictureTableView indexPathForSelectedRow];
        jdvc.fromCategoryView = YES;
        jdvc.journal = (Journal*)[self.pictures objectAtIndex:index.row];
    }else if ([segue.identifier isEqualToString:@"CategoryToTimeLineSegue"]){
        TimeLineTableViewController *ttvc = (TimeLineTableViewController*)segue.destinationViewController;
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        ttvc.tagFromCategory = (NSString*)[self.tags objectAtIndex:index.row];
    }
}
#pragma mark Load Images From Disc
// This is for reading Journals and select those have pictures save in the journals array.
-(void)loadImagesFromJournals{
    NSData * originalData= [[FileManager getFileManager] ReadFromDocumentsByFilename:@"AllJournals.plist"];
    NSArray* tempJournals = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:originalData];
    self.journals = [[NSMutableArray alloc] initWithArray:tempJournals];
    self.pictures = [[NSMutableArray alloc] init];
    for (Journal * cJournal in self.journals) {
        if (cJournal.imagePath) {
            [self.pictures addObject:cJournal];
        }
    }
}

#pragma mark Tap Labels
// Method set tap on label, what should each do when tap Tag or Picture Label
-(void)tapOnLabel: (UIGestureRecognizer *) gestureRecognizer{
    UILabel * label =(UILabel *) [gestureRecognizer view];
    DLog(@"%ld",(long)label.tag);
    if (label.tag==121) {
        [self.pictureTableView setHidden:YES];
        [self.tableView setHidden:NO];
        [self.editTagButton setTitle:@"Edit"];
        [self.editTagButton setEnabled:YES];
        [self.addTagButton setTitle:@"Add"];
        [self.addTagButton setEnabled:YES];
        [self.tagsLabel setTextColor:[UIColor blackColor]];
        [self.pictureLabel setTextColor:[UIColor grayColor]];
        [self.tableView reloadData];
    }
    else if (label.tag==122){
        [self.tableView setHidden:YES];
        [self.pictureTableView setHidden:NO];
        [self.editTagButton setTitle:@""];
        [self.editTagButton setEnabled:NO];
        [self.addTagButton setTitle:@""];
        [self.addTagButton setEnabled:NO];
        [self.tagsLabel setTextColor:[UIColor grayColor]];
        [self.pictureLabel setTextColor:[UIColor blackColor]];
        [self.pictureTableView reloadData];
    }
}
#pragma mark Set Up Table Views for Tag & Picture View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag==101){
        return [self.tags count];
    }
    else
        return [self.pictures count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"TableView is: %ld",(long)tableView.tag);
    if (tableView.tag==101) {
        DLog(@"%ld",(long)indexPath.row);
        UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"tagTableCell" forIndexPath:indexPath];
        DLog(@"%@",[self.tags objectAtIndex:indexPath.row]);
        cell.textLabel.text= [self.tags objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        
        UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"pictureCell" forIndexPath:indexPath];
        Journal *currentJournal =[self.pictures objectAtIndex:indexPath.row];
        NSData *pngData = [[FileManager getFileManager] ReadFromDocumentsByFilename:currentJournal.imagePath];
        DLog(@"currentJournal Image Path: %@",currentJournal.imagePath);
        UIImage * image=[[UIImage imageWithData:pngData] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0) resizingMode:UIImageResizingModeStretch];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:image]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = (UILabel *) [self.view viewWithTag:103];
        titleLabel.text = currentJournal.title;
        UILabel *dateLabel = (UILabel *) [self.view viewWithTag:104];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, MMM dd, YYYY"];
        dateLabel.text = [dateFormatter stringFromDate:currentJournal.create];
        return cell;
        
    }
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%ld",(long)indexPath.row);
}
#pragma mark Set Up Subviews
// view Did Layout Subviews set the frame to the corresponding location.
-(void)viewDidLayoutSubviews
{
    // set round corner for add tag view
    self.addTagView.layer.cornerRadius = 5;
    self.addTagView.layer.masksToBounds = YES;
    // set round corner for textfield
//    self.tagNameTextField.layer.cornerRadius = 5;
//    self.tagNameTextField.layer.cornerRadius = YES;
    
    DLog(@"Inside viewDidLayoutSubviews");
    if (self.addTagViewLocationOutbound) {
        CGRect frame = self.addTagView.frame;
        frame.origin.x = self.view.center.x-frame.size.width/2;
        frame.origin.y = -94;
        self.addTagView.frame=frame;
        self.addTagView.alpha = 0;
    }
    else{
        self.addTagView.center = self.view.center;
        self.addTagView.alpha = 0.8;
    }
    
    if ([self.pictureTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.pictureTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.pictureTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.pictureTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// Function created for edit tags table view.
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
// Edit the tags.
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.tags removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //update disc
        NSArray * tempTags = [[NSArray alloc] init];
        tempTags = self.tags;
        NSData * saveTagData = [NSKeyedArchiver archivedDataWithRootObject:tempTags];
        [[FileManager getFileManager] SaveToDocumentsByFilenameAndData:@"Tags.plist" data:saveTagData];
    }
}
#pragma mark Add Tag Names Box
// Tap Add Tags start animation.
- (IBAction)addTags:(id)sender {
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.addTagView.center = CGPointMake(self.view.center.x, self.view.center.y);
                         self.addTagView.alpha = 0.8;
                     }
                     completion:^(BOOL completed){
                         DLog(@"Finish Display info sheet");
                         self.addTagViewLocationOutbound = false;
                     }];
}
// Dismiss Keyboard, delegate set to itself.
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    DLog(@"in text Field Should Return");
    if (textField==self.tagNameTextField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}


// Set Edit Button Mode
- (IBAction)editTags:(UIBarButtonItem *)sender {
    DLog(@"Editing Tag Table");
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"Edit";
    }else{
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"Done";
    }
}


// Accept a tag name in the text field and start analyzing it.
- (IBAction)addCurrentTagName:(id)sender {
    self.addTagViewLocationOutbound = true;
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.addTagView.alpha = 0;
                     }
                     completion:^(BOOL completed){
                         
                     }];
    NSString * tempTagName = self.tagNameTextField.text;
    self.tagNameTextField.text=nil;
    [self textFieldShouldReturn:self.tagNameTextField];
    BOOL flag = true;
    if (![tempTagName isEqual:@""]) {
        for (NSString * str in self.tags) {
            if ([tempTagName isEqualToString:str]) {
                flag=false;
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Tag Exists" message:@"The Tag you entered already exists." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }
        if (flag) {
            [self.tags addObject:tempTagName];
            NSArray * tempTags = [[NSArray alloc] init];
            tempTags = self.tags;
            NSData * saveTagData = [NSKeyedArchiver archivedDataWithRootObject:tempTags];
            [[FileManager getFileManager] SaveToDocumentsByFilenameAndData:@"Tags.plist" data:saveTagData];
            [self.tableView reloadData];
        }
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Null Tag" message:@"You didn't enter anything" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)cancelAddingTag:(id)sender {
    DLog(@"Before set true");
    self.addTagViewLocationOutbound = true;
    DLog(@"after set true");
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.addTagView.alpha = 0;
                     }
                     completion:^(BOOL completed){
                        
                     }];
    [self textFieldShouldReturn:self.tagNameTextField];
    self.tagNameTextField.text=nil;
    
}




@end
