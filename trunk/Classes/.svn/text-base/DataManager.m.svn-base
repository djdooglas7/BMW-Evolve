//
//  DataManager.m
//  Puma
//
//  Created by Doug Strittmatter on 10/8/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "DataManager.h"
#import "MD5Hash.h"

static DataManager *sharedDataManager = nil;

@implementation DataManager

@synthesize isFinishedLoading, frcTrip, arrTripSegments;

+ (DataManager*)sharedManager
{
    if (sharedDataManager == nil) {
        sharedDataManager = [[super allocWithZone:NULL] init];
    }
    return sharedDataManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

//*****************************************************************


-(id) init
{
	isFinishedLoading = NO;
	
	arrTripSegments = [[NSMutableArray alloc] init];
	
	/*NSString *finalPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Coords.plist"];
	dictPlistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
	arrTypes = [dictPlistData objectForKey:@"types"];*/
	
	//arrLatitude = [NSMutableArray array];
    //arrLongitude = [NSMutableArray array];
	
	/*NSManagedObjectContext *context = [self managedObjectContext];
    Coord *nsmoCoords = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Coord" 
                                      inManagedObjectContext:context];
    nsmoCoords.latitude = [NSNumber numberWithDouble:37.779941] ;
    nsmoCoords.longitude = [NSNumber numberWithDouble:-122.417908];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }*/
    
    // Test listing all FailedBankInfos from the store
    /*NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coord" 
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Coord *info in fetchedObjects) {
        NSLog(@"latitude: %@", info.latitude);
        NSLog(@"longitude: %@", info.longitude);
    }        
    [fetchRequest release];*/
	
	return self;
}


-(void)addPreferences
{
	// set default preferences
	[self setMoveToBackground:TRUE];
	[self setLocationAccuracyBestForNavigation:TRUE];
	[self setCurrentCharge:100.0];
	[self setSubmitInfo:0];
	[self setShareData:TRUE];
	[self setHitZero:FALSE];
	[self setSetupComplete:FALSE];
	[self setFirstName:@""];
}


# pragma mark - NSUserDefaults

-(void)setMoveToBackground:(BOOL)blnValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:blnValue forKey:@"MoveToBackground"];
}


-(BOOL)isMoveToBackground
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"MoveToBackground"];
}


-(void)setLocationAccuracyBestForNavigation:(BOOL)blnValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:blnValue forKey:@"LocationAccuracyBestForNavigation"];
}


-(BOOL)isLocationAccuracyBestForNavigation
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"LocationAccuracyBestForNavigation"];
}


-(void)setStartDate:(NSDate*)startDate
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:startDate forKey:@"StartDate"];
}


-(NSDate*)getStartDate
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return (NSDate *)[prefs objectForKey:@"StartDate"];
}


-(void)setCurrentCharge:(double)value
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setDouble:value forKey:@"CurrentCharge"];
}


-(double)getCurrentCharge
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs doubleForKey:@"CurrentCharge"];
}


-(void)setSubmitInfo:(int)intValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:intValue forKey:@"SubmitInfo"];
}


-(int)getSubmitInfo
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs integerForKey:@"SubmitInfo"];
}


-(void)setZipCode:(NSString*)value
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:value forKey:@"ZipCode"];
}


-(NSString*)getZipCode
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs objectForKey:@"ZipCode"];
}


-(void)setShareData:(BOOL)blnValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:blnValue forKey:@"ShareData"];
}


-(BOOL)getShareData
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"ShareData"];
}


-(void)setFirstName:(NSString*)strValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:strValue forKey:@"FirstName"];
}


-(NSString*)getFirstName
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return (NSString *)[prefs objectForKey:@"FirstName"];
}


-(void)setLastName:(NSString*)strValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:strValue forKey:@"LastName"];
}


-(NSString*)getLastName
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return (NSString *)[prefs objectForKey:@"LastName"];
}


-(void)setEmail:(NSString*)strValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:strValue forKey:@"Email"];
}


-(NSString*)getEmail
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return (NSString *)[prefs objectForKey:@"Email"];
}


-(void)setFacebookId:(NSString*)strValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:strValue forKey:@"FacebookId"];
}


-(NSString*)getFacebookId
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return (NSString *)[prefs objectForKey:@"FacebookId"];
}


-(void)setAmountSaved:(float)value
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:value forKey:@"AmountSaved"];
}


-(float)getAmountSaved
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs floatForKey:@"AmountSaved"];
}


-(void)setGasSaved:(float)value
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:value forKey:@"GasSaved"];
}


-(float)getGasSaved
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs floatForKey:@"GasSaved"];
}


-(void)setCO2Saved:(float)value
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:value forKey:@"CO2Saved"];
}


-(float)getCO2Saved
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs floatForKey:@"CO2Saved"];
}


-(void)setHitZero:(BOOL)blnValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:blnValue forKey:@"HitZero"];
}


-(BOOL)getHitZero
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"HitZero"];
}


-(void)setSetupComplete:(BOOL)blnValue
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:blnValue forKey:@"SetupComplete"];
}


-(BOOL)getSetupComplete
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"SetupComplete"];
}


-(void)setChargeResetDate:(NSDate*)resetDate
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:resetDate forKey:@"ChargeResetDate"];
}


-(NSDate*)getChargeResetDate
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return (NSDate *)[prefs objectForKey:@"ChargeResetDate"];
}


-(void)setSleepDate:(NSDate*)sleepDate
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:sleepDate forKey:@"SleepDate"];
}


-(NSDate*)getSleepDate
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return (NSDate *)[prefs objectForKey:@"SleepDate"];
}


-(void) sendUserData
{
	NSString *urlString = [NSString stringWithFormat:@"http://review.kbsp.com/~jleonov/active2/main/index.php/appinput"];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	//set headers
	NSString *contentType = [NSString stringWithFormat:@"text/xml"];
	[request addValue:contentType forHTTPHeaderField: @"Content-type"];
	[request addValue:contentType forHTTPHeaderField: @"Accept"];
	
	
	//create the body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"<newUser>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<firstName>%@</firstName>", [self getFirstName]] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<lastName>%@</lastName>", [self getLastName]] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<zip>%i</zip>", (int)[self getZipCode]] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>", [self getEmail]] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSString *strMD5Values = [NSString stringWithFormat:@"%@%@%i%@", [self getFirstName], [self getLastName], (int)[self getZipCode], [self getEmail]];
	NSString *strMD5Key = [NSString stringWithFormat:@"5P04-3942-394A-G2M9"];
	NSString *strMD5Both = [NSString stringWithFormat:@"%@%@", [MD5Hash returnMD5Hash:strMD5Values], [MD5Hash returnMD5Hash:strMD5Key]];
	[postBody appendData:[[NSString stringWithFormat:@"<key>%@</key>", [MD5Hash returnMD5Hash:strMD5Both]] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithFormat:@"</newUser>"] dataUsingEncoding:NSUTF8StringEncoding]];
	NSString *postBodyresult = [[[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"postBody: %@", postBodyresult);
	
	//post
	[request setHTTPBody:postBody];
	NSLog(@"request: %@", request);
	
	//get response
	NSHTTPURLResponse* urlResponse = nil;
	NSError *error = [[[NSError alloc] init] autorelease];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	NSString *result = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	
	if ([urlResponse statusCode] == 1) {
		NSLog(@"Response success: %@", result);
	} else {
		NSLog(@"Response error: %@", result);
	}
}


# pragma mark - core data methods

-(void) addCoord:(CLLocationCoordinate2D)coord
{
	NSManagedObjectContext *context = [self managedObjectContext];
    Coord *nsmoCoords = [NSEntityDescription
						 insertNewObjectForEntityForName:@"Coord" 
						 inManagedObjectContext:context];
    nsmoCoords.latitude = [NSNumber numberWithDouble:coord.latitude];
    nsmoCoords.longitude = [NSNumber numberWithDouble:coord.longitude];
	
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
		NSLog(@"saved latitude: %f", coord.latitude);
        NSLog(@"saved longitude: %f", coord.longitude);
	}

}


-(void) addCoordHistory:(CLLocationCoordinate2D)coord
{
	NSManagedObjectContext *context = [self managedObjectContext];
    Coord *nsmoCoords = [NSEntityDescription
						 insertNewObjectForEntityForName:@"CoordHistory" 
						 inManagedObjectContext:context];
    nsmoCoords.latitude = [NSNumber numberWithDouble:coord.latitude];
    nsmoCoords.longitude = [NSNumber numberWithDouble:coord.longitude];
	
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
		NSLog(@"saved latitude: %f", coord.latitude);
        NSLog(@"saved longitude: %f", coord.longitude);
	}
	
}


// insert trip into core data
-(void) addTrip:(NSString*)strCategory
	andTripName:(NSString*)strName
{
    NSLog(@"strName %@", strName);
	NSManagedObjectContext *context = [self managedObjectContext];
    Trip *nsmoTrip = [NSEntityDescription
						 insertNewObjectForEntityForName:@"Trip" 
						 inManagedObjectContext:context];
    nsmoTrip.strCategory = strCategory;
	nsmoTrip.strName = strName;
	nsmoTrip.tripSegment = [NSSet setWithArray:arrTripSegments];
	TripSegment *segment = [arrTripSegments objectAtIndex:0];
	nsmoTrip.dateStart = segment.dateStart; 
	if ([self getHitZero]) {
		nsmoTrip.blnHitZero = [NSNumber numberWithInt:1];
	} else {
		nsmoTrip.blnHitZero = [NSNumber numberWithInt:0];
	}

	nsmoTrip.numTotalCharge = [NSNumber numberWithDouble:[self getCurrentCharge]];
	
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
		NSLog(@"saved Trip");
		[arrTripSegments removeAllObjects];
		
	}
}


-(void) cancelTrip
{
    [arrTripSegments removeAllObjects];
    [self setHitZero:FALSE];
}


-(void) addTripSegment:(NSString*)strType
		  andStartDate:(NSDate*)dateStart
			andEndDate:(NSDate*)dateEnd
		   andDistance:(NSNumber*)numDistance
{
	NSManagedObjectContext *context = [self managedObjectContext];
	TripSegment *nsmoTripSegment = [NSEntityDescription
									insertNewObjectForEntityForName:@"TripSegment" 
									inManagedObjectContext:context];
	nsmoTripSegment.strType = strType;
    nsmoTripSegment.dateStart = dateStart;
	nsmoTripSegment.dateEnd = dateEnd;
	nsmoTripSegment.numDistance = numDistance;
	nsmoTripSegment.numCharge = [NSNumber numberWithDouble:[self getCurrentCharge]];
	
	[arrTripSegments addObject:nsmoTripSegment];
}


- (NSMutableArray *)retrieveCoordItems
{
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coord" 
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
	NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *arrCoords = [[NSMutableArray alloc] init];
    for (Coord *info in fetchedObjects) {
        //NSLog(@"retrieved latitude: %@", info.latitude);
        //NSLog(@"retrieved longitude: %@", info.longitude);
		[arrCoords addObject:info];
    }        
    [fetchRequest release];
	
	return arrCoords;
	[arrCoords release];
}


- (NSMutableArray *)retrieveCoordHistory
{
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoordHistory" 
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
	NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *arrCoordsHistory = [[NSMutableArray alloc] init];
    for (Coord *info in fetchedObjects) {
        //NSLog(@"retrieved latitude history: %@", info.latitude);
        //NSLog(@"retrieved longitude history: %@", info.longitude);
		[arrCoordsHistory addObject:info];
    }        
    [fetchRequest release];
	
	return arrCoordsHistory;
	[arrCoordsHistory release];
}


- (NSMutableArray *)retrieveTripItems
{
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Trip" 
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
	NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *arrTrips = [[NSMutableArray alloc] init];
    for (Trip *info in fetchedObjects) {
        //NSLog(@"retrieved trip");
		[arrTrips addObject:info];
    }        
    [fetchRequest release];
	return arrTrips;
	[arrTrips release];
}


-(void) deleteCoordItems
{
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coord" 
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
	NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Coord *info in fetchedObjects) {
		[context deleteObject:info];
    }        
    [fetchRequest release];
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
		NSLog(@"deleted coords");
	}
}


- (NSFetchedResultsController *)fetchedResultsController 
{
    if (frcTrip != nil) {
        return frcTrip;
    }
	
	NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"Trip" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
	
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
							  initWithKey:@"tripSegment.startDate" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
	
    [fetchRequest setFetchBatchSize:20];
	
    frcTrip = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
												  managedObjectContext:context sectionNameKeyPath:@"strName" 
												   cacheName:@"Root"];
    frcTrip.delegate = self;
    [fetchRequest release];
	
    return frcTrip;    
	
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    //NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"BMWE3.sqlite"]];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *coordMapPath = [[paths lastObject] stringByAppendingPathComponent:@"Coord.sqlite"];
	NSURL *storeUrl = [NSURL fileURLWithPath:coordMapPath];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


- (void)dealloc
{
    [managedObjectContext release];
    [persistentStoreCoordinator release];
	[arrTripSegments release];
	[super dealloc];
}


@end
