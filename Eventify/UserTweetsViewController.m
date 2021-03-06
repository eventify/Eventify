//
//  UserTweetsViewController.m
//  Eventify
//
//  Created by carlos on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserTweetsViewController.h"
#import "SBJson.h"


@implementation UserTweetsViewController

@synthesize person;
@synthesize listContent, filteredListContent;
@synthesize selectedImage;
@synthesize unselectedImage,inPseudoEditMode,selectedArray,toolbar;


#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidUnload
{
	self.filteredListContent = nil;
}

- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
    [person release];
    
	[super dealloc];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of rows: %d", [self.person.tweets count]);
	
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		return [self.person.tweets count];
    }
	else
	{
		return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *EditCellIdentifier = @"EditCell";
    
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EditCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:EditCellIdentifier] autorelease];
		
        
		UILabel *label = [[UILabel alloc] initWithFrame:kLabelRect];
		label.tag = kCellLabelTag;
		[cell.contentView addSubview:label];
		[label release];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:unselectedImage];
		imageView.frame = CGRectMake(5.0, 10.0, 23.0, 23.0);
		[cell.contentView addSubview:imageView];
		imageView.hidden = !inPseudoEditMode;
		imageView.tag = kCellImageViewTag;
        [imageView release];
    }
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
        [UIView beginAnimations:@"cell shift" context:nil];
        label.text =  [self.person.tweets objectAtIndex:indexPath.row];
        label.frame = (inPseudoEditMode) ? kLabelIndentedRect : kLabelRect;
        label.opaque = NO;
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kCellImageViewTag];
        NSNumber *selected = [selectedArray objectAtIndex:[indexPath row]];
        imageView.image = ([selected boolValue]) ? selectedImage : unselectedImage;
        imageView.hidden = !inPseudoEditMode;
        [UIView commitAnimations];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (inPseudoEditMode)
	{
		BOOL selected = [[selectedArray objectAtIndex:[indexPath row]] boolValue];
		[selectedArray replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:!selected]];
		[self.tableView reloadData];
	}
}

//	if (tableView == self.searchDisplayController.searchResultsTableView) 
//    {
//		//tweet = [self.filteredListContent objectAtIndex:indexPath.row];
//		cell.textLabel.text = [self.person.tweets objectAtIndex:indexPath.row];
//    }
//	else {
//		cell.textLabel.text = @"";
//    }
//      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
	
    [super viewDidLoad];
	
	self.title = @"Tweets";
	self.filteredListContent = [NSMutableArray array];
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
    
    self.person = [[Person alloc] init];
    	
	self.inPseudoEditMode = NO;
	
	self.selectedImage = [UIImage imageNamed:@"selected.png"];
	self.unselectedImage = [UIImage imageNamed:@"unselected.png"];
	
//    NSString *tweetName = [self.searchDisplayController.searchBar text];
//	[self loadTweetsForUser:tweetName];
	
//	deleteButton.target = self;
//	deleteButton.action = @selector(doDelete);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search button clicked");
    NSString *searchString = [self.searchDisplayController.searchBar text];
    [self loadTweetsForUser:searchString];
    self.inPseudoEditMode = !inPseudoEditMode;
	toolbar.hidden = !inPseudoEditMode;
}


- (void)loadTweetsForUser:(NSString *)userName {
    
    [self.person setUserName:userName];
    
    NSLog(@"get events for %@", [self.person userName]);
    
	NSArray *localMessages = [[NSArray alloc] initWithArray:[TwitterHelper fetchTimelineForUsername:[self.person userName]]];
	if (localMessages && [localMessages count]) {
		[self.person setStatusMessages:localMessages];
	}
	else {
		[self.person setStatusMessages:[NSArray arrayWithObject:[NSDictionary dictionaryWithObject:@"no tweets found" forKey:@"text"]]];
	}
	[localMessages release];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *message in [self.person statusMessages]) {
//        NSLog(@"%@", [message objectForKey:@"text"]);
		[temp addObject:[message objectForKey:@"text"]];
		self.person.tweets = temp;
    }
    NSLog(@"tweets %@", self.person.tweets);    
    
    NSDictionary *userInfo = [TwitterHelper fetchInfoForUsername:userName];
    NSLog(@"userInfo: %@", userInfo);
    
    self.person.description = [userInfo objectForKey:@"description"];
    self.person.image = [userInfo objectForKey:@"profile_image_url"];    
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	
	//	for (Item *item in listContent)
	//	{
	//		if ([scope isEqualToString:@"All"] || [item.type isEqualToString:scope])
	//		{
	//			NSComparisonResult result = [item.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
	//            if (result == NSOrderedSame)
	//			{
	//				[self.filteredListContent addObject:item];
	//            }
	//		}
	//	}
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSLog(@"heightForRowAtIndexPath");
    
    NSString *text = [self.person.tweets objectAtIndex:indexPath.row];
    CGFloat height = [text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(240,300) lineBreakMode:UILineBreakModeWordWrap].height;
    
    return height+40; 
}




#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end

