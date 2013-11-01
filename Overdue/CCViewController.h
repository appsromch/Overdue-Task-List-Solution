//
//  CCViewController.h
//  Overdue
//
//  Created by Eliot Arntz on 10/29/13.
//  Copyright (c) 2013 Code Coalition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAddTaskViewController.h"
#import "CCDetailTaskViewController.h"

/* Conform to the protocols both Apple created and the ViewController protocols */
@interface CCViewController : UIViewController <CCAddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, CCDetailTaskViewControllerDelegate>

/* We will use this NSMutableArray to hold all of the task objects to update our tableView. We will have to add and remove objects from this array as the user makes changes to the taskList */
@property (strong, nonatomic) NSMutableArray *taskObjects;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender;
- (IBAction)addTaskBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
