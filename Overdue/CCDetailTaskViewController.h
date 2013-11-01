//
//  CCDetailTaskViewController.h
//  Overdue
//
//  Created by Eliot Arntz on 10/29/13.
//  Copyright (c) 2013 Code Coalition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTask.h"
#import "CCEditTaskViewController.h"

/* A protocol for methods to be implemented by the CCViewController class when the user presses the save button in the CCEditTaskViewController. */
@protocol CCDetailTaskViewControllerDelegate <NSObject>

-(void)updateTask;

@end

/* Conform to the CCEditTaskViewControllerDelegate */
@interface CCDetailTaskViewController : UIViewController <CCEditTaskViewControllerDelegate>

/* A CCTask property can be set in the CCViewController.m file to pass a specific task to the CCDetailTaskViewController. */
@property (strong, nonatomic) CCTask *task;
/* A delegate property which will allow us to call the protocol methods. */
@property (weak, nonatomic) id <CCDetailTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
