//
//  DailyHistoryViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/17/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DailyTableViewCell.h"

@interface DailyHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {

	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSArray *arrFetchedObjects;
	
	IBOutlet UITableView *tblView;
	IBOutlet DailyTableViewCell *tblViewCell;
	NSMutableArray *arrDaily;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *tblView;

-(void) backPressed:(id)sender;
-(IBAction) tipsPressed:(id)sender;

@end
