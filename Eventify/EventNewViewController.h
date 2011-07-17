//
//  StorifySampleCodeViewController.h
//  StorifySampleCode
//
//  Created by dperez on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorifySampleCodeViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UITextField *storyTitle;

- (IBAction) createStoryButtonPressed:(id) sender;
- (IBAction) getStoriesButtonPressed:(id) sender;

@end
