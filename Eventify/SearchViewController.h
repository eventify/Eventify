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

@interface SearchViewController : UITableViewController {
    Person *person;
}

@property (nonatomic, retain) Person *person;

@end

