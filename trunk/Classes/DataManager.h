//
//  DataManager.h
//  Puma
//
//  Created by Doug Strittmatter on 10/8/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "Coord.h"
#import "Trip.h"
#import "TripSegment.h"

@interface DataManager : NSObject <NSFetchedResultsControllerDelegate> {

	// Database variables
	NSString *databaseName;
	NSString *databasePath;
	
	// Array to store the coord objects
	NSMutableArray *arrLatitude;
	NSMutableArray *arrLongitude;
	
	NSMutableArray *arrTripSegments;
	
	NSFetchedResultsController *frcTrip;
	
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	BOOL isFinishedLoading;
	
	
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSFetchedResultsController *frcTrip;
@property (nonatomic, retain, readonly) NSMutableArray *arrTripSegments;
@property (nonatomic) BOOL isFinishedLoading;

-(void)setMoveToBackground:(BOOL)blnValue;
-(BOOL)isMoveToBackground;

-(void)setLocationAccuracyBestForNavigation:(BOOL)blnValue;
-(BOOL)isLocationAccuracyBestForNavigation;

-(void)setStartDate:(NSDate*)startDate;
-(NSDate*)getStartDate;

-(void)setCurrentCharge:(double)value;
-(double)getCurrentCharge;

-(void)setSubmitInfo:(int)intValue;
-(int)getSubmitInfo;

-(void)setZipCode:(NSString*)intValue;
-(NSString*)getZipCode;

-(void)setShareData:(BOOL)blnValue;
-(BOOL)getShareData;

-(void)setFirstName:(NSString*)strValue;
-(NSString*)getFirstName;

-(void)setLastName:(NSString*)strValue;
-(NSString*)getLastName;

-(void)setEmail:(NSString*)strValue;
-(NSString*)getEmail;

-(void)setFacebookId:(NSString*)strValue;
-(NSString*)getFacebookId;

-(void)setAmountSaved:(float)value;
-(float)getAmountSaved;

-(void)setGasSaved:(float)value;
-(float)getGasSaved;

-(void)setCO2Saved:(float)value;
-(float)getCO2Saved;

-(void)setHitZero:(BOOL)blnValue;
-(BOOL)getHitZero;

-(void)setSetupComplete:(BOOL)blnValue;
-(BOOL)getSetupComplete;

-(void)setChargeResetDate:(NSDate*)resetDate;
-(NSDate*)getChargeResetDate;

-(void)setSleepDate:(NSDate*)sleepDate;
-(NSDate*)getSleepDate;

-(void) sendUserData;

-(void)addPreferences;

-(NSMutableArray *)retrieveCoordItems;
-(void) addCoord:(CLLocationCoordinate2D)coord;
-(void) deleteCoordItems;

-(NSMutableArray *)retrieveCoordHistory;
-(void) addCoordHistory:(CLLocationCoordinate2D)coord;

- (NSMutableArray *)retrieveTripItems;
-(void) addTrip:(NSString*)strCategory
	andTripName:(NSString*)strName;
-(void) cancelTrip;

-(void) addTripSegment:(NSString*)strType
		  andStartDate:(NSDate*)dateStart
			andEndDate:(NSDate*)dateEnd
		   andDistance:(NSNumber*)numDistance;

// Class Methods
+ (DataManager*)sharedManager;


@end
