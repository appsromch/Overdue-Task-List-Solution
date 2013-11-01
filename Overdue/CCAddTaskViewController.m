//
//  CCAddTaskViewController.m
//  Overdue
//
//  Created by Eliot Arntz on 10/29/13.
//  Copyright (c) 2013 Code Coalition. All rights reserved.
//

#import "CCAddTaskViewController.h"

@interface CCAddTaskViewController ()

@end

@implementation CCAddTaskViewController

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
    
    /* set the textView and textField delegate properties to self so that we can implement their protocol methods */
    self.textView.delegate = self;
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Method returns a CCTask Object. We first create a CCTask object and then setup its' properties using the view's information. */
-(CCTask *)returnNewTaskObject
{
    CCTask *taskObject = [[CCTask alloc] init];
    taskObject.title = self.textField.text;
    taskObject.description = self.textView.text;
    taskObject.date = self.datePicker.date;
    taskObject.isCompleted = NO;
    
    return taskObject;
}

/* If the user presses the addTaskButton call the method defined in the protocol on the delegate property. Pass in a CCTask object using the method returnNewTaskObject. */
- (IBAction)addTaskButtonPressed:(UIButton *)sender
{
    [self.delegate didAddTask:[self returnNewTaskObject]];
}

/* If the user presses the cancelButton call the method defined in the protocol on the delegate property. */
- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self.delegate didCancel];
}

#pragma mark - UITextFieldDelegate

/* Method is called when the user taps the return key. When this action occurs we tell the textField to dismiss the keyboard. */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

/* UITextView Delegate method. This method is triggered when the user types a new character in the textView. */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /* Test if the entered text is a return. If it is we tell textView to dismiss the keyboard and then we stop the textView from entering in additional information as text. This is not a perfect solution because users cannot enter returns in their text and if they paste text with a return items after the return will not be added. For the functionality required in this project this solution works just fine. */
    if ([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];
        return NO;
    }
    else return YES;
}

@end
