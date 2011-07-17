//
//  StorifySampleCodeViewController.m
//  StorifySampleCode
//
//  Created by dperez on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StorifySampleCodeViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation StorifySampleCodeViewController

@synthesize storyTitle;

- (void)dealloc
{
    [super dealloc];
}

- (IBAction) createStoryButtonPressed:(id) sender 
{
    NSLog(@"Creating Storify Story");
    
    NSURL *url = [NSURL URLWithString:@"http://storify.com/story/new"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"eventify1" forKey:@"username"];
    [request setPostValue:@"d6e2ba3299dc8e372f2f9788e1c8cb95" forKey:@"api_key"];
    [request setPostValue:storyTitle.text forKey:@"title"];
    [request setPostValue:@"This is our very first story!! Woohoo!!" forKey:@"description"];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    int statusCode = [request responseStatusCode];
    NSString *statusMessage = [request responseStatusMessage];
    NSLog(@"status code = %d", statusCode);
    NSLog(@"status message = %@", statusMessage);
    
    [storyTitle resignFirstResponder];
}

- (IBAction) getStoriesButtonPressed:(id)sender 
{
    NSURL *url = [NSURL URLWithString:@"http://storify.com/eventify1.json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
    }
    NSLog(@"User info with stories: %@", response);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
