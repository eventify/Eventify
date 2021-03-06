//
//  UserTweetsViewController.h
//  Eventify
//
//  Created by carlos on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define kCellImageViewTag		1000
#define kCellLabelTag			1001

#define kLabelIndentedRect	CGRectMake(40.0, 12.0, 275.0, 20.0)
#define kLabelRect			CGRectMake(15.0, 12.0, 275.0, 20.0)

#import <UIKit/UIKit.h>
#import "Person.h"
#import "TwitterHelper.h"

@interface UserTweetsViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    Person *person;
	NSArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
    UIImage *selectedImage;
	UIImage *unselectedImage;
    BOOL inPseudoEditMode;
    NSMutableArray *selectedArray;
    UIToolbar *toolbar;
}

@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unselectedImage;
@property (nonatomic, retain) NSMutableArray *selectedArray;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) BOOL inPseudoEditMode;

- (void)loadTweetsForUser:(NSString *)userName;

@end

