//
//  CCViewController.m
//  Overdue
//
//  Created by Eliot Arntz on 10/29/13.
//  Copyright (c) 2013 Code Coalition. All rights reserved.
//

#import "CCViewController.h"

@interface CCViewController ()

@end

@implementation CCViewController

/* Lazy instantation in the taskObjects getter. We ensure that if we call the taskObjects array it will always be allocated and initialized */
-(NSMutableArray *)taskObjects
{
    if (!_taskObjects){
        _taskObjects = [[NSMutableArray alloc] init];
    }
    
    return _taskObjects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /* Set the tableView's datasource and delegate properties to self so that the UITableViewControllerDelegate and UITableViewControllerDataSource know to pass message to this instance of the viewController. */
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    /* Access NSUserDefaults for the array containing the task's saved as NSDictionary objects. */
    NSArray *tasksAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY];
    
    /* Iterate over the returned array with fast enumeration. Convert each dictionary into a CCTask object using the helper method taskObjectForDictionary. Add the returned task objects to the taskObjectsArray */
    for (NSDictionary *dictionary in tasksAsPropertyLists){
        CCTask *taskObject = [self taskObjectForDictionary:dictionary];
        [self.taskObjects addObject:taskObject];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /* Before transitioning to the CCAddTaskViewController set the delegate property to self. This way the CCAddTaskViewController will be able to call methods in the ViewController file. */
    if ([segue.destinationViewController isKindOfClass:[CCAddTaskViewController class]]){
        CCAddTaskViewController *addTaskViewController = segue.destinationViewController;
        addTaskViewController.delegate = self;
    }
    
    /* Before transitioning to the CCDetailTaskViewController determine the task selected by the user based on the sender argument of NSIndexPath. Set the task property of the detailTaskViewController. Also set the delegate property to self. This way the CCDetailTaskViewController will be able to call methods in the ViewController file. */

    else if ([segue.destinationViewController isKindOfClass:[CCDetailTaskViewController class]]){
        CCDetailTaskViewController *detailTaskViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        CCTask *taskObject = self.taskObjects[path.row];
        detailTaskViewController.task = taskObject;
        detailTaskViewController.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* When the reorderBarButtonItem is pressed check if the tableView is in editing mode. If it is setEditing mode to NO otherwise set it to YES. */
- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender
{
    if (self.tableView.editing == YES)[self.tableView setEditing:NO animated:YES];
    else [self.tableView setEditing:YES animated:YES];
}

/* When the addTaskBarButtonItem is pressed transition to the AddTaskViewController */
- (IBAction)addTaskBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"toAddTaskViewControllerSegue" sender:nil];
}

#pragma mark - CCAddTaskViewControllerDelegate

/* Delegate method called when a task is added in the AddTaskViewController. Notice that the task added is passed as a parameter.*/
-(void)didAddTask:(CCTask *)task
{
    /*  Add the task object to the taskObjects array. */
    [self.taskObjects addObject:task];
    
    /* Use NSUserDefaults to access all previously saved tasks. If there were not saved tasks we allocate and initialize the NSMutableArray named taskObjectsAsPropertyLists. */
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
    if (!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    /* First convert the task object to a property list using the method taskObjectAsAPropertyList. Then add the propertylist (dictionary) to the taskObjectsAsPropertyLists NSMutableArray. Synchronize will save the added array to NSUserDefaults.*/
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /* Dismiss the AddTaskViewController as the presented view and reload the tableView with the added task */
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

/* Dismiss the AddTaskViewController as the presented view.*/
-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CCDetailTaskViewControllerDelegate

/* Delegate call back from the CCDetailTaskViewController. Save the updated task to NSUserDefaults with the helper method saveTasks. Reload the tableView with the updated information */
-(void)updateTask
{
    [self saveTasks];
    [self.tableView reloadData];
}

#pragma mark - Helper Methods

/* Convert and return an NSDictionary of the taskObject */
-(NSDictionary *)taskObjectAsAPropertyList:(CCTask *)taskObject
{
    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title, TASK_DESCRIPTION : taskObject.description, TASK_DATE : taskObject.date, TASK_COMPLETION : @(taskObject.isCompleted) };
    return dictionary;
}

/* Convert a NSDictionary into a CCTask object and return it. Use the custom initializer we set setup in the CCTask.h file. */
-(CCTask *)taskObjectForDictionary:(NSDictionary *)dictionary
{
    CCTask *taskObject = [[CCTask alloc] initWithData:dictionary];
    return taskObject;
}

/* Method returns a BOOL based on whether the first date parameter is greater than the second date parameter. To compare the two date parameters we convert the NSDates into NSTimeInterval's using the method timeIntervalSince1970. */
-(BOOL)isDateGreaterThanDate:(NSDate *)date and:(NSDate *)toDate
{
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    NSTimeInterval toDateInterval = [toDate timeIntervalSince1970];
    
    if (dateInterval > toDateInterval) return YES;
    else return NO;
}

/* The method has two parameters a CCTask and a NSIndexPath */
-(void)updateCompletionOfTask:(CCTask *)task forIndexPath:(NSIndexPath *)indexPath
{
    /* Use NSUserDefaults to access all previously saved tasks. If there were not saved tasks we allocate and initialize the NSMutableArray named taskObjectsAsPropertyLists. */
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_OBJECTS_KEY] mutableCopy];
    if (!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    /* Remove the old dictionary stored at the indexPath.row that the user wants to update */
    [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
    
    /* Update the tasks completion from YES to NO or NO to YES based on the current status of the completion. */
    if(task.isCompleted == YES) task.isCompleted = NO;
    else task.isCompleted = YES;
    
    /* Convert the updated taskObject into a property list. Insert it into the array at the same location that we just removed the old task object from */
     [taskObjectsAsPropertyLists insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
    
    /* Save the updated array to NSUserDefaults. */
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /* Reload the tableView with the updated task. This works because the task we updated is stored in the heap. So updating it here updates it in the array of task objects. */
    [self.tableView reloadData];
}

-(void)saveTasks
{
    /* Create a NSMutableArray that we will NSDictionaries returned from the method taskObjectAsAPropertyList. */
    NSMutableArray *taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    for (int x = 0; x < [self.taskObjects count]; x ++){
        [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:self.taskObjects[x]]];
    }
    
    /* Save the updated array to NSUserDefaults. */
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /* The number of rows should be the number of task's in the taskObjects Array */
    return [self.taskObjects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* We will only have 1 section for now */
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Configure the cell...
    
    /* Determine which task object should be displayed for the specific indexPath.row. */
    CCTask *task = self.taskObjects[indexPath.row];
    cell.textLabel.text = task.title;
    
    /* Create a NSDateFormatter Object. Set the formatting type to include year, month and day. Use the formatter to convert the NSDate to an NSString.*/
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    
    /* Update the detailTextLabel with the date string */
    cell.detailTextLabel.text = stringFromDate;
    
    /* Determine if the task is overdue using the helper method isDateGreaterThanDate */
    BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
    
    /* Update the coloring of the cell's background if the task isCompleted, isOverdue or simply pending. */
    if (task.isCompleted == YES) cell.backgroundColor = [UIColor greenColor];
    else if (isOverDue == YES) cell.backgroundColor = [UIColor redColor];
    else cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

/* When the user taps a cell in the tableView the task's isCompleted status should update. Use the helper method updateCompletionOfTask. */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTask *task = self.taskObjects[indexPath.row];
    [self updateCompletionOfTask:task forIndexPath:indexPath];
}

/* Allow the user to edit tableViewCells for deletion */
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/* Method called when the users swipes and presses the delete key */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        /* If a user deletes the row remove the task at that row from the tasksArray */
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        /* With the updated array of task objects iterate over them and convert them to plists. Save the plists in the newTaskObjectsData NSMutableArray. Save this array to NSUserDefaults. */
        NSMutableArray *newTaskObjectsData = [[NSMutableArray alloc] init];
        
        for (CCTask *task in self.taskObjects){
            [newTaskObjectsData addObject:[self taskObjectAsAPropertyList:task]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:newTaskObjectsData forKey:TASK_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /* Animate the deletion of the cell */
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/* When the user taps the accessory button transition to the DetailTaskViewController */
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailTaskViewControllerSegue" sender:indexPath];
}

/* Allow the user to move cells in the tableView */
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/* Method called when the user moves a cell while in editing mode */
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    /* Determine which task was moved and update the taskObjects array by remove the object from it's old index and inserting it at it's new index. Save the updated taskObjects array to NSUserDefaults using the helper method saveTasks */
    CCTask *taskObject = self.taskObjects[sourceIndexPath.row];
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:taskObject atIndex:destinationIndexPath.row];
    [self saveTasks];
}

@end
