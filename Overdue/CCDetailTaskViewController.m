//
//  CCDetailTaskViewController.m
//  Overdue
//
//  Created by Eliot Arntz on 10/29/13.
//  Copyright (c) 2013 Code Coalition. All rights reserved.
//

#import "CCDetailTaskViewController.h"

@interface CCDetailTaskViewController ()

@end

@implementation CCDetailTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /* Update the view objects with the task object.*/
    self.titleLabel.text = self.task.title;
    self.detailLabel.text = self.task.description;
    
    /* Set the NSDateFormatter to change the NSDate into an NSString with year-month-day. */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:self.task.date];
    
    /* Update the dateLabel with the returned string. */
    self.dateLabel.text = stringFromDate;
}

/* After you confirm that the destination ViewController is the CCEditTaskViewController. After we have a variable that points to the destination viewController we can set the delegate and task properties. */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CCEditTaskViewController class]]){
        CCEditTaskViewController *editTaskViewController = segue.destinationViewController;
        editTaskViewController.task = self.task;
        editTaskViewController.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* When the user presses the editBarButtonItem Segue to the CCEditTaskViewController */
- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"toEditTaskViewControllerSegue" sender:nil];
}

#pragma mark CCEditTaskViewControllerDelegate

/* When the callback occurs update the view objects with the updated task properties. Use the method popViewController to remove the CCDetailViewController instance and present the ViewController instance. Call the Delegate method updateTask that is implemented in the ViewController.m file. */
-(void)didUpdateTask
{
    self.titleLabel.text = self.task.title;
    self.detailLabel.text = self.task.description;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:self.task.date];
    self.dateLabel.text = stringFromDate;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate updateTask];
}
@end
