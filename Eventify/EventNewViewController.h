//
//  StorifySampleCodeViewController.h
//  StorifySampleCode
//
//  Created by dperez on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface EventNewViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UITextField *storyTitle;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, assign) RootViewController *delegate;

- (IBAction) createStoryButtonPressed:(id) sender;
- (IBAction) getStoriesButtonPressed:(id) sender;
- (IBAction) dismissButtonPressed:(id) sender;

@end
