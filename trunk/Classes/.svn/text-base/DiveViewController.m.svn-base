//
//  DiveViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/9/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "DiveViewController.h"


@implementation DiveViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	arrTitles = [[NSArray alloc] initWithObjects:@"DRIVING TIPS", @"TRIP DETAILS", @"DAILY MILEAGE", @"TRAVEL LOG", @"YOUR SAVINGS", @"CLEANER COMMUTE", nil];

}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayRatingView];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100.0, 14.0, 200.0, 18.0)] autorelease];		
		nameLabel.tag = 2;		
		nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
		[nameLabel setTextColor:[UIColor darkGrayColor]];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
		[cell.contentView addSubview:nameLabel];
		
		
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
	nameLabel.text = [arrTitles objectAtIndex:indexPath.row];
	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"diveIcon%i.png", indexPath.row+1]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) 
	{
		case 0:
			[[[UIApplication sharedApplication] delegate] displayTipsView];
			break;
			
		case 1:
			[[[UIApplication sharedApplication] delegate] displayMapHistoryView];
			break;
			
		case 2:
			[[[UIApplication sharedApplication] delegate] displayDailyHistoryView];
			break;
			
		case 3:
			[[[UIApplication sharedApplication] delegate] displayTripHistoryView];
			break;
			
		case 4:
			[[[UIApplication sharedApplication] delegate] displaySavingsView];
			break;
			
		case 5:
			[[[UIApplication sharedApplication] delegate] displayEnvironmentView];
			break;
			
		default:
			break;
	}
	
	[tableView  deselectRowAtIndexPath:indexPath  animated:YES]; 
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    switch (indexPath.row) 
	{
		case 0:
			[[[UIApplication sharedApplication] delegate] displayTipsView];
			break;
			
		case 1:
			[[[UIApplication sharedApplication] delegate] displayMapHistoryView];
			break;
			
		case 2:
			[[[UIApplication sharedApplication] delegate] displayDailyHistoryView];
			break;
			
		case 3:
			[[[UIApplication sharedApplication] delegate] displayTripHistoryView];
			break;
			
		case 4:
			[[[UIApplication sharedApplication] delegate] displaySavingsView];
			break;
			
		case 5:
			[[[UIApplication sharedApplication] delegate] displayEnvironmentView];
			break;
			
		default:
			break;
	}
	
	[tableView  deselectRowAtIndexPath:indexPath  animated:YES]; 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

