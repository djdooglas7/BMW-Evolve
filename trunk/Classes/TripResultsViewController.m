//
//  TripResultsViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 1/28/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "TripResultsViewController.h"
#import "TripSegment.h"
#import "DataManager.h"
#import "XAuthTwitterEngine.h"
#import "MD5Hash.h"

static NSString* kAppId = @"154480201269892";
static NSString* kOAuthConsumerKey = @"6JzDOjZ9VSWMZ2F2zcNpRA";
static NSString* kOAuthConsumerSecret = @"dakDo3LWd2eHlUDFhmNSoAmSy0wmOALnMpvGbSdbyg";


@implementation TripResultsViewController

@synthesize _facebook, _engine;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// facebook init
	_facebook = [[Facebook alloc] initWithAppId:kAppId];
	arrPermissions =  [[NSArray arrayWithObjects:
						@"publish_stream",@"read_stream", @"offline_access",nil] retain];
	
	// twitter init
	_engine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector:@selector(twitterSucceeded:)
												 name: @"TwitterSucceeded"
											   object: username];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector:@selector(twitterFailed:)
												 name: @"TwitterFailed"
											   object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector:@selector(startActivityViewer:)
												 name: @"StartActivityViewer"
											   object: nil];
	
	// get tips from plist
	NSString *finalPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Tips.plist"];
	NSDictionary *dictPlistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
	arrTips = [dictPlistData objectForKey:@"Tips"];
	
	NSArray *arrTrips = [[NSArray alloc] initWithArray:[[DataManager sharedManager] retrieveTripItems]];
	trip = [arrTrips objectAtIndex:[arrTrips count]-1];
	if (trip) {
		
		if ([trip.strName isEqualToString:@""]) {
			lblName.text = [NSString stringWithFormat:@"Trip Details"];
		} else {
			lblName.text = [NSString stringWithFormat:@"%@ Details", trip.strName];
		}

		flTotalMiles = 0.0;
		intervalTotalDiff = 0.0;
		intervalDrivingDiff = 0.0;
		intervalParkedDiff = 0.0;
		intervalChargingDiff = 0.0;
		intervalFlexChargingDiff = 0.0;
		

        NSSet *setSegment = trip.tripSegment;
        for (TripSegment *seg in setSegment)
        {
            
            flTotalMiles += [seg.numDistance floatValue];
            NSDate *startDate = (NSDate*)seg.dateStart;
            NSDate *endDate = (NSDate*)seg.dateEnd; 
            intervalTotalDiff += [endDate timeIntervalSinceDate:startDate];
            
            if ([seg.strType isEqualToString:@"Driving"]) {
                intervalDrivingDiff += [endDate timeIntervalSinceDate:startDate];
            } else if ([seg.strType isEqualToString:@"Parked"]) {
                intervalParkedDiff += [endDate timeIntervalSinceDate:startDate];
            } else if ([seg.strType isEqualToString:@"Station"]) {
                intervalChargingDiff += [endDate timeIntervalSinceDate:startDate];
            } else if ([seg.strType isEqualToString:@"Opprotunity"]) {
                intervalFlexChargingDiff += [endDate timeIntervalSinceDate:startDate];
            }
        }
		
		
		long min = (long)intervalTotalDiff / 60;    // divide two longs, truncates
		long sec = (long)intervalTotalDiff % 60;    // remainder of long divide
		lblTime.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
		
		lblDist.text = [NSString stringWithFormat:@"%i miles", (int)flTotalMiles];
		
		min = (long)intervalDrivingDiff / 60;    // divide two longs, truncates
		sec = (long)intervalDrivingDiff % 60;    // remainder of long divide
		lblDriving.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
		
		min = (long)intervalParkedDiff / 60;    // divide two longs, truncates
		sec = (long)intervalParkedDiff % 60;    // remainder of long divide
		lblParked.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
		
		min = (long)(intervalChargingDiff + intervalFlexChargingDiff) / 60;    // divide two longs, truncates
		sec = (long)(intervalChargingDiff + intervalFlexChargingDiff) % 60;    // remainder of long divide
		lblCharging.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
		
		//lblSpeed.text = [NSString stringWithFormat:@"%i mph", (int)(flTotalMiles/((float)intervalDrivingDiff / 3600))];
		
		lblCharge.text = [NSString stringWithFormat:@"%.1f%%", [[DataManager sharedManager] getCurrentCharge]];
 
		
		[self sendData];
	}

	[self changeTip];
}


-(void) changeTip
{
	intTipCounter = (arc4random() % ([arrTips count]-1));
	NSDictionary *dictTip = [arrTips objectAtIndex:intTipCounter];
	lblTip.text = [dictTip objectForKey:@"tip"];
	if ([[dictTip objectForKey:@"badge"] isEqualToString:@"YES"]) {
		imgBadge.hidden = NO;
	} else {
		imgBadge.hidden = YES;
	}
	imgTip.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [dictTip objectForKey:@"condition"]]];	
}


-(void) sendData
{
	NSString *urlString = [NSString stringWithFormat:@"http://review.kbsp.com/~jleonov/active2/main/index.php/appinput"];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	//set headers
	NSString *contentType = [NSString stringWithFormat:@"text/xml"];
	[request addValue:contentType forHTTPHeaderField: @"Content-type"];
	[request addValue:contentType forHTTPHeaderField: @"Accept"];
	
	/*id applicationDelegate = [[UIApplication sharedApplication] delegate];
	NSMutableArray *arrShoeColors = [NSMutableArray arrayWithArray:[[applicationDelegate pumaViewController] arrCurrentColors]];
	
	NSMutableString *currentType = [[NSMutableString alloc] init];*/

	
	//create the body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"<newTrip>"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<tripName>%@</tripName>", trip.strName] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<fid>%@</fid>", [[DataManager sharedManager] getFacebookId]] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<tripCategory>%@</tripCategory>", trip.strCategory] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<triptime>%i</triptime>", (int)(intervalTotalDiff / 60)] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<distance>%f</distance>", flTotalMiles] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<drivetime>%i</drivetime>", (int)(intervalDrivingDiff / 60)] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<parkingtime>%i</parkingtime>", (int)(intervalParkedDiff / 60)] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<chargetime>%i</chargetime>", (int)(intervalChargingDiff / 60)] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<flexchargetime>%i</flexchargetime>", (int)(intervalFlexChargingDiff / 60)] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<averageremainingcharge>%f</averageremainingcharge>", [[DataManager sharedManager] getCurrentCharge]] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"<discharged>%i</discharged>", [trip.blnHitZero intValue]] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithFormat:@"<locations>"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableArray *arrCoords = [[DataManager sharedManager] retrieveCoordItems];
	int intCoordCount = 20;
	for (Coord *info in arrCoords) 
	{
		if (intCoordCount == 20) {
			[postBody appendData:[[NSString stringWithFormat:@"<location>"] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"<lat>%@</lat>", info.latitude] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"<long>%@</long>", info.longitude] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"<time>%@</time>", @" "] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"</location>"] dataUsingEncoding:NSUTF8StringEncoding]];
			
			intCoordCount = 0;
		} else {
			intCoordCount++;
		}	 
	}
	
	[[DataManager sharedManager] deleteCoordItems];
	
	[postBody appendData:[[NSString stringWithFormat:@"</locations>"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSString *strMD5Values = [NSString stringWithFormat:@"%@%@%@%i%f%i%i%i%i%f%i", trip.strName, [[DataManager sharedManager] getFacebookId], trip.strCategory, (int)(intervalTotalDiff / 60), flTotalMiles, (int)(intervalDrivingDiff / 60), (int)(intervalParkedDiff / 60), (int)(intervalChargingDiff / 60), (int)(intervalFlexChargingDiff / 60), [[DataManager sharedManager] getCurrentCharge], [trip.blnHitZero intValue]];
	//NSLog(@"strMD5Values %@", strMD5Values);
	//NSLog(@"strMD5Values MD5 %@", [MD5Hash returnMD5Hash:strMD5Values]);
	NSString *strMD5Key = [NSString stringWithFormat:@"5P04-3942-394A-G2M9"];
	//NSLog(@"strMD5Key %@", strMD5Key);
	//NSLog(@"strMD5Key MD5 %@", [MD5Hash returnMD5Hash:strMD5Key]);
	NSString *strMD5Both = [NSString stringWithFormat:@"%@%@", [MD5Hash returnMD5Hash:strMD5Values], [MD5Hash returnMD5Hash:strMD5Key]];
	//NSLog(@"strMD5Both %@", strMD5Both);
	[postBody appendData:[[NSString stringWithFormat:@"<key>%@</key>", [MD5Hash returnMD5Hash:strMD5Both]] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithFormat:@"</newTrip>"] dataUsingEncoding:NSUTF8StringEncoding]];
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
		/*[self stopTimer];
		
		
		if (xmlParser)
		{
			[xmlParser release];
		}    
		xmlParser = [[NSXMLParser alloc] initWithData: responseData];
		[xmlParser setDelegate: self];
		[xmlParser setShouldResolveExternalEntities:YES];
		[xmlParser parse];
		
		[self sendImage];*/
		
		
		
		
	} else {
		NSLog(@"Response error: %@", result);
		
		/*if (xmlParser)
		{
			[xmlParser release];
		}    
		xmlParser = [[NSXMLParser alloc] initWithData: responseData];
		[xmlParser setDelegate: self];
		[xmlParser setShouldResolveExternalEntities:YES];
		[xmlParser parse];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Process Your Order" message:xmlError
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		xmlError = nil;*/
	}
	//[error release];
	//[result release];
	//[postBodyresult release];
}


-(IBAction) followPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayUpdatesView];
}


-(IBAction) homePressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayStartTripView];
}


-(IBAction) ratingsPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayRatingView];
}


-(void) tipsPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.BMWActivateTheFuture.com/"]];
}


-(void) tipDetailPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTipDetailView];	
	NSDictionary *dictTip = [arrTips objectAtIndex:intTipCounter];
	[[applicationDelegate tipDetailViewController] setText:[dictTip objectForKey:@"tip"] andBadge:imgBadge.hidden andType:[dictTip objectForKey:@"condition"]];
}


-(void) twitterPressed:(id)sender
{
	if (![_engine isAuthorized])
	{
		id applicationDelegate = [[UIApplication sharedApplication] delegate];
		[applicationDelegate displayXAuthTwitterView];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// IBAction

/**
 * Called on a login/logout button click.
 */
- (void)fbButtonClick:(id)sender 
{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSDate *currentDate = [[NSDate alloc] init];
	
	// Authenticate user if not logged in or access topken has expired
	if ([prefs stringForKey:@"accessToken"] == nil || [currentDate compare:[prefs objectForKey:@"expirationDate"]] == NSOrderedDescending) {
		NSLog(@"Log In");
		[_facebook authorize:arrPermissions delegate:self];
		// If logged in post contents
	} else {
		NSLog(@"Already Logged In");
		_facebook.accessToken = [prefs stringForKey:@"accessToken"];
		_facebook.expirationDate = [prefs objectForKey:@"expirationDate"];
		//NSLog(@"%@", fbController.accessToken);
		NSLog(@"Expiration Date: %@", _facebook.expirationDate);
		[self publishStream];
	}
}

/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (IBAction)getUserInfo:(id)sender {
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
}


/**
 * Make a REST API call to get a user's name using FQL.
 */
- (IBAction)getPublicInfo:(id)sender {
	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									@"SELECT uid,name FROM user WHERE uid=4", @"query",
									nil];
	[_facebook requestWithMethodName: @"fql.query"
						   andParams: params
					   andHttpMethod: @"POST"
						 andDelegate: self];
}

/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (void)publishStream 
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I just used the BMW EVolve app to track my driving patterns. Join me and others in learning how to save money, reduce harmful emissions and develop the cars of the future.",@"message",
                                   @"",@"name",
                                   @"http://www.bmwactivatethefuture.com/", @"link",
                                   @"http://electronstuff.com/uploadfiles/1280718801-6268orgru/1280747118_400876000.jpg", @"picture",
                                   nil];
	
	[_facebook requestWithGraphPath:@"me/feed"
						  andParams:params
					  andHttpMethod:@"POST"
						andDelegate:self];	
}


/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	
	blnFbLoggedIn = YES;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:_facebook.accessToken forKey:@"accessToken"];
	[prefs setObject:_facebook.expirationDate forKey:@"expirationDate"];
	[self publishStream];
}


/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on the format of the API response.
 * If you need access to the raw response, use
 * (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result 
{
	// store facebook id
	NSDictionary *dictResult = [NSDictionary dictionaryWithDictionary:result];
	NSString *strId = [NSString stringWithString:[dictResult objectForKey:@"id"]];
	NSArray *arrId = [strId componentsSeparatedByString:@"_"];
	[[DataManager sharedManager] setFacebookId:[arrId objectAtIndex:0]];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Your post to Facebook was successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
};

/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	//[self.label setText:[error localizedDescription]];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Your post failed to upload to Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
};


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
	//[self.label setText:@"publish successfully"];
}


# pragma mark - twitter methods

- (void)twitterSucceeded:(NSNotification *)aNotification {
	
	//activityIndicatorContainer.hidden = YES;
	[spinner stopAnimating];
	
	
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: @"SwitchTab"
	 object: nil];
	
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: @"NotificationLoadBio"
	 object: (NSDictionary*)[aNotification object]];
}


- (void)twitterFailed:(NSNotification *)aNotification {
	
	
	//activityIndicatorContainer.hidden = YES;
	[spinner stopAnimating];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to post" message:@"Twitter is busy or has lost your connection."
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)startActivityViewer:(NSNotification *)aNotification {
	
	spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	spinner.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 + 100);
	//activityIndicatorContainer.hidden = NO;
	[self.view addSubview: spinner];
	[spinner startAnimating];
}


#pragma mark -
#pragma mark XAuthTwitterEngineDelegate methods

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username
{
	//
	// Note: do not use NSUserDefaults to store this in a production environment. 
	// ===== Use the keychain instead. Check out SFHFKeychainUtils if you want 
	//       an easy to use library. (http://github.com/ldandersen/scifihifi-iphone) 
	//
	NSLog(@"Access token string returned: %@", tokenString);
    
    [_engine sendUpdate:@"I just used the @BMW EVolve app to track and learn about my driving patterns. Join the mission at BMWActivateTheFuture.com"];
	
	[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"cachedXAuthAccessTokenKey"];
}

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedXAuthAccessTokenKey"];
	
	NSLog(@"About to return access token string: %@", accessTokenString);
	
	return accessTokenString;
}


- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{
	NSLog(@"Error: %@", error);
	
	UIAlertViewQuick(@"Authentication error", @"Please check your username and password and try again.", @"OK");
}


//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}




//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}


- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier
{
    NSLog(@"Got statuses:\r%@", statuses);
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier
{
    NSLog(@"Got direct messages:\r%@", messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
    NSLog(@"Got user info:\r%@", userInfo);
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_facebook release];
	[_engine release];
    [super dealloc];
}


@end
