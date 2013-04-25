//
//  DailyHistoryViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/17/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "DailyHistoryViewController.h"
#import "Trip.h"
#import "TripSegment.h"
#import "DataManager.h"


@implementation DailyHistoryViewController

@synthesize managedObjectContext, fetchedResultsController, tblView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	arrFetchedObjects = [[NSArray alloc] init];
	
	if (managedObjectContext == nil) 
	{ 
        managedObjectContext = [[DataManager sharedManager] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	// calculate miles per day
	arrDaily = [[NSMutableArray alloc] init];
	int intCount = 0;
	float flDailyDist = 0;
	float flTotalDist = 0;
	//NSNumber *flDailyDist = [[NSNumber alloc] initWithInt:0];
	NSString *strLastDate = [[NSString alloc] init];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd"];
	NSArray* reversedArray = [[arrFetchedObjects reverseObjectEnumerator] allObjects];

	for (Trip *info in reversedArray) 
	{
		//Trip *info = [fetchedResultsController objectAtIndexPath:indexPath];
		NSSet *setSegment = info.tripSegment;
		NSSortDescriptor *sortNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"dateStart" ascending:YES] autorelease];
		NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortNameDescriptor, nil] autorelease];
		NSArray *arrSegments = [setSegment sortedArrayUsingDescriptors:sortDescriptors];
		
		NSString *strDate = [dateFormat stringFromDate:info.dateStart];
		NSLog(@"%@",strDate);
		if (intCount != 0) 
		{
			if (![strDate isEqualToString:strLastDate]) 
			{
				NSDictionary *dictDaily = [[NSDictionary alloc] initWithObjectsAndKeys:strLastDate,@"strDate",[NSString stringWithFormat:@"%.0f", flDailyDist],@"flMiles",nil];
				[arrDaily addObject:dictDaily];
				flDailyDist = 0;
			}
		}
			
		for (TripSegment *tripSegment in arrSegments) {
			//NSLog(@"dateStart %@", tripSegment.dateStart);
			flDailyDist += [tripSegment.numDistance floatValue];
			flTotalDist += [tripSegment.numDistance floatValue];
		}
		

		if (intCount == [arrFetchedObjects count]-1) 
		{
			NSDictionary *dictDaily = [[NSDictionary alloc] initWithObjectsAndKeys:strDate,@"strDate",[NSString stringWithFormat:@"%.0f", flDailyDist],@"flMiles",nil];
			[arrDaily addObject:dictDaily];
			flDailyDist = 0;
		}
		
		
		
		strLastDate = [NSString stringWithString:strDate];
		intCount++;
	}
	
	//
    // Create a header view. Wrap it in a container to allow us to position
    // it better.
    //
    UIView *containerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 320, 60)]
	 autorelease];
	
    UILabel *headerLabel =
	[[[UILabel alloc]
	  initWithFrame:CGRectMake(5, 10, 310, 40)]
	 autorelease];
    headerLabel.text = [NSString stringWithFormat:@"On average you drive about %.1f miles per day.", (flTotalDist/[arrDaily count])];
    headerLabel.textColor = [UIColor darkGrayColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.numberOfLines = 0;
	[containerView addSubview:headerLabel];
	tblView.tableHeaderView = containerView;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [arrDaily count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    DailyTableViewCell *cell = (DailyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"DailyTableViewCell" owner:self options:nil];
		cell = tblViewCell;
    }
    
    // Configure the cell...
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)configureCell:(DailyTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
    /*Trip *info = [fetchedResultsController objectAtIndexPath:indexPath];
	NSSet *setSegment = info.tripSegment;
	NSSortDescriptor *sortNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"dateStart" ascending:YES] autorelease];
	NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortNameDescriptor, nil] autorelease];
	NSArray *arrSegments = [setSegment sortedArrayUsingDescriptors:sortDescriptors];
	for (TripSegment *tripSegment in arrSegments) {
		NSLog(@"dateStart %@", tripSegment.dateStart);
	}*/
	
	NSDictionary *dictDaily = [NSDictionary dictionaryWithDictionary:[arrDaily objectAtIndex:indexPath.row]];
	//NSLog([NSString stringWithFormat:@"%@",[dictDaily objectForKey:@"strDate"]]);
    [cell setLabelDate:[dictDaily objectForKey:@"strDate"]];
	[cell setLabelMiles:[dictDaily objectForKey:@"flMiles"]];
	[cell setBarGraph:[[dictDaily objectForKey:@"flMiles"] floatValue]];
    /*cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", 
	 info.city, info.state];*/
	
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark - NSFetchedResultsController delegate

- (NSFetchedResultsController *)fetchedResultsController 
{
    /*if (fetchedResultsController != nil) {
	 return fetchedResultsController;
	 }
	 
	 NSManagedObjectContext *context = [self managedObjectContext];
	 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	 NSEntityDescription *entity = [NSEntityDescription 
	 entityForName:@"Trip" inManagedObjectContext:context];
	 [fetchRequest setEntity:entity];
	 
	 NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
	 initWithKey:@"tripSegment.startDate" ascending:NO];
	 [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
	 
	 [fetchRequest setFetchBatchSize:20];
	 
	 fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
	 managedObjectContext:context sectionNameKeyPath:nil 
	 cacheName:@"Root"];
	 fetchedResultsController.delegate = self;
	 [fetchRequest release];
	 
	 return fetchedResultsController;   */
	
	if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
		
		NSError *error;
		arrFetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
		
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateStart" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	return fetchedResultsController;
	
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [tblView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *tableView = tblView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tblView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tblView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [tblView endUpdates];
}


-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayDiveView];
}


-(void) tipsPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.BMWActivateTheFuture.com/"]];
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
