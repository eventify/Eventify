//
//  StorifySampleCodeViewController.m
//  StorifySampleCode
//
//  Created by dperez on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventNewViewController.h"
#import "EventViewController.h"
#import "UserTweetsViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation EventNewViewController

@synthesize storyTitle, navController;

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
    NSLog(@"create status code = %d", statusCode);
    NSLog(@"create status message = %@", statusMessage);
    
    [storyTitle resignFirstResponder];
    
    //if something was created, dismiss this VC and push the search controller.
    if (statusCode == 200) {
        //if created then publish it and push 2 controllers
        NSString *string = [NSString stringWithFormat:@"http://storify.com/eventify1/%@/publish", storyTitle.text];
        NSURL *url = [NSURL URLWithString:string];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:@"eventify1" forKey:@"authorUsername"];
        [request setPostValue:storyTitle.text forKey:@"title"];
        [request setPostValue:@"eventify1" forKey:@"username"];
        [request setPostValue:@"d6e2ba3299dc8e372f2f9788e1c8cb95" forKey:@"api_key"];
        [request setRequestMethod:@"POST"];
        [request startSynchronous];
        int statusCode = [request responseStatusCode];
        NSString *statusMessage = [request responseStatusMessage];
        NSLog(@"publish status code = %d", statusCode);
        NSLog(@"publish status message = %@", statusMessage);
        
        
        EventViewController *evc = [[EventViewController alloc] init];
        UserTweetsViewController *uvc = [[UserTweetsViewController alloc] init];
        
        [self.navController pushViewController:evc animated:NO];
        [self.navController pushViewController:uvc animated:NO];
        [self dismissModalViewControllerAnimated:YES];
    } 
    else  
    {
        //popup alert if we get anything other than a 200 code.
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Create Error:"
                                   message: @"Unable to create event on storify.com"
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        
    }
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

- (IBAction) dismissButtonPressed:(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
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
