//
//  CCAddTaskViewController.h
//  Overdue
//
//  Created by Eliot Arntz on 10/29/13.
//  Copyright (c) 2013 Code Coalition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTask.h"

/* A protocol for methods to be implemented by the CCViewController class when the user presses the add or cancel button */
@protocol CCAddTaskViewControllerDelegate <NSObject>

-(void)didCancel;
-(void)didAddTask:(CCTask *)task;

@end

/* Conform to the UITextViewDelegate and UITextFieldDelegate to allow the keyboard to be dismissed */
@interface CCAddTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

/* A delegate property which will allow us to call the protocol methods. */
@property (weak, nonatomic) id <CCAddTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
