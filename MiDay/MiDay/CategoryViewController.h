//
//  CategoryViewController.h
//  MiDay
//
//  Created by Mingyang Yu on 2/25/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITableView *pictureTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTagButton;

@property (weak, nonatomic) IBOutlet UIView *addTagView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editTagButton;
- (IBAction)addTags:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tagNameTextField;

- (IBAction)editTags:(UIBarButtonItem *)sender;
- (IBAction)addCurrentTagName:(id)sender;
- (IBAction)cancelAddingTag:(id)sender;


@property IBOutlet UITableView *tableView;
@end
