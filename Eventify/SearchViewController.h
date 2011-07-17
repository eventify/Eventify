//
//  SearchViewController.h
//  Eventify
//
//  Created by carlos on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "TwitterHelper.h"

@interface SearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    Person *person;
	NSArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
}

@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;

@end

