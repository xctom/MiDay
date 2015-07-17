//
//  ChooseTagTableViewController.m
//  MiDay
//
//  Created by xuchen on 3/6/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "ChooseTagTableViewController.h"
#import "FileManager.h"
#import "editViewController.h"

@interface ChooseTagTableViewController ()

@property (strong, nonatomic) NSArray *AllTags;

@end

@implementation ChooseTagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.AllTags = [[NSArray alloc] init];
    NSData *tagsData = [[FileManager getFileManager] ReadFromDocumentsByFilename:@"Tags.plist"];
    self.AllTags = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:tagsData];
    
    for (NSString* str in self.chosenTags) {
        NSLog(@"%@",str);
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.AllTags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseTagCell" forIndexPath:indexPath];
    
    NSString *tag = (NSString*)[self.AllTags objectAtIndex:indexPath.row];
    cell.textLabel.text = tag;
    
    //if a chosen tag
    for (NSString* str in self.chosenTags) {
        if ([tag isEqualToString:str]) {
            [self.tableView selectRowAtIndexPath:indexPath
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSArray *indexPathArray = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *newChosenArr = [[NSMutableArray alloc] init];
    
    //send all chosen tags back
    for (NSIndexPath* path in indexPathArray) {
        [newChosenArr addObject:[self.AllTags objectAtIndex:path.row]];
    }
    
    editViewController* evc = (editViewController*)segue.destinationViewController;
    
    evc.journal.tags = [[NSArray alloc] initWithArray:newChosenArr];
    
}

@end
