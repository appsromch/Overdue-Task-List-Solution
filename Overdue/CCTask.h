//
//  CCTask.h
//  Overdue
//
//  Created by Eliot Arntz on 10/29/13.
//  Copyright (c) 2013 Code Coalition. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTask : NSObject

/* Properties of our CCTask model */
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL isCompleted;

/* Custom Initializer which has a single parameter of class NSDictionary. */ 
-(id)initWithData:(NSDictionary *)data;

@end
