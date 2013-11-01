//
//  CCEditTaskViewController.h
//  Overdue
//
//  Created by Eliot Arntz on 10/29/13.
//  Copyright (c) 2013 Code Coalition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTask.h"

@protocol CCEditTaskViewControllerDelegate <NSObject>

-(void)didUpdateTask;

@end

/* Conform to the UITextViewDelegate and UITextFieldDelegate to allow the keyboard to be dismissed */
@interface CCEditTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) CCTask *task;
@property (weak, nonatomic) id <CCEditTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)saveBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
