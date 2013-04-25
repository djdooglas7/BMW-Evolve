//
//  TripHistoryViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/10/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

//  Retrieves and displays saved trip data

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TripHistoryTableViewCell.h"

@interface TripHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {

	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSArray *arrFetchedObjects;
	
	IBOutlet UITableView *tblView;
	IBOutlet TripHistoryTableViewCell *tblViewCell;
    
    NSIndexPath *indexDelete;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *tblView;

-(IBAction) backPressed:(id)sender;
-(IBAction) editPressed:(id)sender;
-(IBAction) tipsPressed:(id)sender;

@end
