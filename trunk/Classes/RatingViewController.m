//
//  RatingViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/8/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "RatingViewController.h"
#import "DataManager.h"
#import "XAuthTwitterEngine.h"

static NSString* kAppId = @"154480201269892";
static NSString* kOAuthConsumerKey = @"6JzDOjZ9VSWMZ2F2zcNpRA";
static NSString* kOAuthConsumerSecret = @"dakDo3LWd2eHlUDFhmNSoAmSy0wmOALnMpvGbSdbyg";

@implementation RatingViewController

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
	
    strFBMessage = [[NSString alloc] init];
    strTwitterMessage = [[NSString alloc] init];
	_facebook = [[Facebook alloc] initWithAppId:kAppId];
	//_facebook = [[[[Facebook alloc] init] autorelease] retain];
	arrPermissions =  [[NSArray arrayWithObjects:
                      @"publish_stream",@"read_stream", @"offline_access",nil] retain];
	
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
	
	[self displayRating];
}


-(void) displayRating
{
	NSArray *arrTrips = [[NSArray alloc] initWithArray:[[DataManager sharedManager] retrieveTripItems]];
	
	if ([arrTrips count] == 1) {
		lblDescription.text = @"Way to hug those corners. You looked like a natural out there. Now just record at least two more trips to get your EV rating. Go to Results to learn more about your drive or tap below to get the latest on the launch of the BMW ActiveE.";
		lblName.text = @"NICE DRIVING";
		lblTitle.text = @"You finished your first trip";
		imgMedal.image = [UIImage imageNamed:@"medalFirstTrip.png"];
        
        strFBMessage = @"Only two more trips to find out if I’m electric vehicle compatible. Tired of gas prices and filling up? Join me and others and find out how easily you could convert to an electric vehicle. Visit bmwactivatethefuture.com to learn more.";
        strTwitterMessage = @"Two more trips & I'll know if I'm electric vehicle compatible. Download the app to see for yourself.";
	} else if ([arrTrips count] == 2) {
		lblDescription.text = @"That was some electric driving out there. Looking good. Now just record one more trip to get your EV rating. Go to Results to learn more about your drive or tap below to get the latest on the launch of the BMW ActiveE.";
		lblName.text = @"ALMOST THERE!";
		lblTitle.text = @"You just completed your second trip";
		imgMedal.image = [UIImage imageNamed:@"medalSecondTrip.png"];
        
        strFBMessage = @"Only one more trip to find out if I’m electric vehicle compatible. Tired of gas prices and filling up? Join me and others and find out how easily you could convert to an electric vehicle. Visit bmwactivatethefuture.com to learn more.";
        strTwitterMessage = @"One more trip & I'll know if I'm electric vehicle compatible. Visit BMWActivateTheFuture.com to learn more.";
	} else {
		int intHitZero = 0;
		
		for (Trip *trip in arrTrips)
		{
			NSLog(@"%@", trip.dateStart);
			if (trip.blnHitZero == [NSNumber numberWithInt:1]) 
				intHitZero++;
		}
		
		float flRating = (float)(intHitZero/[arrTrips count]);
		
		NSString *finalPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"zipCodes.plist"];
		NSArray *arrTypes = [NSArray arrayWithContentsOfFile:finalPath];
		BOOL isInRange = [arrTypes containsObject:[NSString stringWithFormat:@"%i", [[DataManager sharedManager] getZipCode]]];
		
		if (flRating < .33) {
			if (isInRange) {
				lblDescription.text = @"Looks like you’re ready to kiss gas goodbye. Based on your driving patterns, current location and distances traveled, you’re an excellent candidate to drive a BMW EV as a primary vehicle. Go to Results to learn more about your drive or tap below to get the latest on the launch of the BMW ActiveE.";	
			} else {
				lblDescription.text = @"Looks like you’re ready to kiss gas goodbye. Based on your driving patterns, current location and distances traveled, you’re an excellent candidate to drive a BMW EV as a primary vehicle. Tap below to stay connected or click Results to learn more.";	
			}

			lblName.text = [NSString stringWithFormat:@"CONGRATS"];
			lblTitle.text = @"You are a BMW EV Pro";
			imgMedal.image = [UIImage imageNamed:@"medal3.png"];
            
            strFBMessage = @"I’m an EV Pro! Find out how electric vehicle compatible you are. Download the BMW EVolve app and track your driving patterns.";
            strTwitterMessage = @"I’m an EV Pro! Download the @BMW EVolve app to see how electric vehicle compatible you are. Visit BMWActivateTheFuture.com to learn more.";
		} else if (flRating > .66) {
			if (isInRange) {
				lblDescription.text = @"Looks like you love driving. A lot. Based on your tendency for longer drives, a BMW EV could benefit your lifestyle as a secondary vehicle. Go to Results to learn more about your drive or tap below to get the latest on the launch of the BMW ActiveE.";
			} else {
				lblDescription.text = @"Looks like you love driving. A lot. Based on your tendency for longer drives, a BMW EV could benefit your lifestyle as a secondary vehicle. Tap below to stay connected or click Results to learn more.";
			}
			
			lblName.text = [NSString stringWithFormat:@"RIGHT ON"];
			lblTitle.text = @"You are EV COMPATIBLE";
			imgMedal.image = [UIImage imageNamed:@"medal1.png"];
            
            strFBMessage = @"I’m EV Ready. Find out how EV-compatible you are. Visit bmwactivatethefuture.com to learn more and track your driving patterns.";
            strTwitterMessage = @"I’m EV Ready. Visit bmwactivatethefuture.com to see how EV-compatible you are.";
		} else {
			if (isInRange) {
				lblDescription.text = @"Prepare to get electric. Based on your set location and the distances traveled, a BMW EV would significantly benefit your daily commute as a primary and/or secondary vehicle. Go to Results to learn more about your drive or tap below to get the latest on the launch of the BMW ActiveE.";
			} else {
				lblDescription.text = @"Prepare to get electric. Based on your set location and the distances traveled, a BMW EV would significantly benefit your daily commute as a primary and/or secondary vehicle. Tap below to stay connected or click Results to learn more.";
			}
			
			lblName.text = [NSString stringWithFormat:@"WELL DONE"];
			lblTitle.text = @"You are EV READY";
			imgMedal.image = [UIImage imageNamed:@"medal2.png"];
            
            strFBMessage = @"I’m EV Compatible. Find out how EV-compatible you are. Visit bmwactivatethefuture.com to learn more and track your driving patterns.";
            strTwitterMessage = @"I’m EV Compatible. Visit bmwactivatethefuture.com to learn more and see how EV-compatible you are.";
		}
	}
}


-(IBAction) diveDeeperPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayDiveView];
}


-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayStartTripView];
}


-(IBAction) followPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayUpdatesView];
}


-(void) tipsPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.BMWActivateTheFuture.com/"]];
}


-(void) twitterPressed:(id)sender
{
	if (![_engine isAuthorized])
	{
		//XAuthTwitterViewController *xauthController = [[XAuthTwitterViewController alloc] init];
		//[self presentModalViewController: xauthController animated: YES];
		id applicationDelegate = [[UIApplication sharedApplication] delegate];
		[applicationDelegate displayXAuthTwitterView];
	} else {
        [_engine sendUpdate:strTwitterMessage];
    }
}


#pragma mark - fb methods


- (IBAction)fbButtonClick:(id)sender 
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


- (void)publishStream 
{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   strFBMessage ,@"message",
                                   @"",@"name",
                                   @"http://www.bmwactivatethefuture.com/", @"link",
                                   @"http://electronstuff.com/uploadfiles/1280718801-6268orgru/1280747118_400876000.jpg", @"picture",
                                   nil];
	
	[_facebook requestWithGraphPath:@"me/feed"
						  andParams:params
					  andHttpMethod:@"POST"
						andDelegate:self];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// Private helper function

- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	return str;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
// FBSessionDelegate

/**
 * Start All test when the user logged in
 */
- (void)fbDidLogin {
	
	blnFbLoggedIn = YES;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:_facebook.accessToken forKey:@"accessToken"];
	[prefs setObject:_facebook.expirationDate forKey:@"expirationDate"];
	[self publishStream];
}

-(void) fbDidLogout {
	if (_facebook.accessToken != nil) {
		NSLog(@"Test fail for test Logout");
	} 
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result{
	
	// store facebook id
	NSDictionary *dictResult = [NSDictionary dictionaryWithDictionary:result];
	NSString *strId = [NSString stringWithString:[dictResult objectForKey:@"id"]];
	NSArray *arrId = [strId componentsSeparatedByString:@"_"];
	[[DataManager sharedManager] setFacebookId:[arrId objectAtIndex:0]];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Your post to Facebook was successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Your post failed to upload to Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

- (void)dialogCompleteWithUrl:(NSURL *)url {
	NSString *post_id = [self getStringFromUrl:[url absoluteString] needle:@"post_id="];
	
	if (post_id.length > 0) {
		NSLog(@"Test Success for testStreamPublish");
	} else {
		NSLog(@"Test Fail for testStreamPublish");
	}
}


- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error {
	if (error.code == 190) {
		NSLog(@"Test Logout Succeed");
	} else {
		NSLog(@"Test Logout Fail");
	}
	
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
    
    [_engine sendUpdate:strTwitterMessage];
	
	//[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"cachedXAuthAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"cachedXAuthAccessTokenKey"];
}

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	//NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedXAuthAccessTokenKey"];
    NSString *accessTokenString = @"";
	
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
#pragma mark -
#pragma mark MGTwitterEngineDelegate methods

- (void)requestSucceeded:(NSString *)connectionIdentifier
{
	NSLog(@"Twitter request succeeded: %@", connectionIdentifier);
	
	UIAlertViewQuick(@"BMW Tweet", @"The BMW EVolve tweet was successfully sent.", @"OK");
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
	NSLog(@"Twitter request failed: %@ with error:%@", connectionIdentifier, error);
    
	if ([[error domain] isEqualToString: @"HTTP"])
	{
		switch ([error code]) {
				
			case 401:
			{
				// Unauthorized. The user's credentials failed to verify.
				UIAlertViewQuick(@"Oops!", @"Your username and password could not be verified. Double check that you entered them correctly and try again.", @"OK");	
				break;				
			}
				
			case 502:
			{
				// Bad gateway: twitter is down or being upgraded.
				UIAlertViewQuick(@"Fail whale!", @"Looks like Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");	
				break;				
			}
				
			case 503:
			{
				// Service unavailable
				UIAlertViewQuick(@"Hold your taps!", @"Looks like Twitter is overloaded. Please wait a few seconds and try again.", @"OK");	
				break;								
			}
				
			default:
			{
				NSString *errorMessage = [[NSString alloc] initWithFormat: @"%d %@", [error	code], [error localizedDescription]];
				UIAlertViewQuick(@"Twitter error!", errorMessage, @"OK");	
				[errorMessage release];
				break;				
			}
		}
		
	}
	else 
	{
		switch ([error code]) {
				
			case -1009:
			{
				UIAlertViewQuick(@"You're offline!", @"Sorry, it looks like you lost your Internet connection. Please reconnect and try again.", @"OK");					
				break;				
			}
				
			case -1200:
			{
				UIAlertViewQuick(@"Secure connection failed", @"I couldn't connect to Twitter. This is most likely a temporary issue, please try again.", @"OK");					
				break;								
			}
				
			default:
			{				
				NSString *errorMessage = [[NSString alloc] initWithFormat:@"%@ xx %d: %@", [error domain], [error code], [error localizedDescription]];
				UIAlertViewQuick(@"Twitter error!", errorMessage , @"OK");
				[errorMessage release];
			}
		}
	}
	
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
    [strFBMessage release];
    [strTwitterMessage release];
	[_facebook release];
	[_engine release];
    [super dealloc];
}


@end
