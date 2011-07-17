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
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	
	
	NSString *tweet = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		//tweet = [self.filteredListContent objectAtIndex:indexPath.row];
		cell.textLabel.text = [self.person.tweets objectAtIndex:indexPath.row];
    }
	else {
		cell.textLabel.text = @"";
    }
	return cell;
}


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
    
    person = [[Person alloc] init];
    [person setUserName:@"iosdevcamp"];
    
    NSLog(@"get events for %@", [person userName]);
    
	NSArray *localMessages = [[NSArray alloc] initWithArray:[TwitterHelper fetchTimelineForUsername:[person userName]]];
	if (localMessages && [localMessages count]) {
		[person setStatusMessages:localMessages];
	}
	else {
		[person setStatusMessages:[NSArray arrayWithObjects:@"no tweets found", nil]];
	}
	[localMessages release];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *message in [person statusMessages]) {
        NSLog(@"%@", [message objectForKey:@"text"]);
        [temp addObject:[message objectForKey:@"text"]];
    }
    self.person.tweets = temp;
    NSLog(@"tweets %@", self.person.tweets);
	
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert)
 {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
	
	/** @todo get the item ID so we can tell storify to add it to the story */
	// (some object) = [self.listContent objectAtIndex:indexPath.row];
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

