//
//  XAuthTwitterViewController.m
//  XAuthTwitterEngineDemo
//
//  Created by Aral Balkan on 28/02/2010.
//  Copyright Naklab 2010. All rights reserved.
//


#import "XAuthTwitterViewController.h"
#import "XAuthTwitterEngine.h"
#import "BMWE3AppDelegate.h"
#import "Trip.h"
#import "DataManager.h"

static NSString* kOAuthConsumerKey = @"Tvf9AkreDqbSZLvdXsQZA";
static NSString* kOAuthConsumerSecret = @"47FhMTz7krLR9jvo19AHUf2QD2oKoWL1ZtrJWkcM";
//static NSString* kOAuthConsumerKey = @"MJpuPQp1jTbtkYfShmua8g";
//static NSString* kOAuthConsumerSecret = @"PQUmyomOpM0C6dJaKehEbVUSnEpG1SF9FbnkAz8q580";

@implementation XAuthTwitterViewController

@synthesize usernameTextField, passwordTextField, twitterEngine;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Sanity check
	if ([kOAuthConsumerKey isEqualToString:@""] || [kOAuthConsumerSecret isEqualToString:@""])
	{
		NSLog(@"Please add your Consumer Key and Consumer Secret from http://twitter.com/oauth_clients/details/<your app id> to the XAuthTwitterViewController.h before running the app. Thank you!");
		//UIAlertViewQuick(@"Missing oAuth details", message, @"OK");
	}
	
	//
	// Initialize the XAuthTwitterEngine.
	//
	self.twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;

	[usernameTextField addTarget:self 
				  action:@selector(textFieldDone:) 
		forControlEvents:UIControlEventEditingDidEndOnExit]; 
	[passwordTextField addTarget:self 
						  action:@selector(textFieldDone:) 
				forControlEvents:UIControlEventEditingDidEndOnExit];
	
	// Focus
	[self.usernameTextField becomeFirstResponder];
	btnLogin.enabled = YES;
	
	
}

-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	if ([applicationDelegate lastScreenType] == kRatingScreen) {
		[applicationDelegate displayRatingView];
	} else if ([applicationDelegate lastScreenType] == kTripResultsScreen) {
		[applicationDelegate displayTripResultsView];
	}
}


- (void) cancel {
	[self performSelector: @selector(dismissModalViewControllerAnimated:) 
			   withObject: (id) kCFBooleanTrue afterDelay: 0.0];
}


- (IBAction)textFieldDone:(id)sender {  
	[self xAuthAccessTokenRequestButtonTouchUpInside];
	//[sender resignFirstResponder];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.usernameTextField = nil;
	self.passwordTextField = nil;
	self.sendTweetButton = nil;
}


- (void)dealloc {
	
	[self.usernameTextField release];
	[self.passwordTextField release];
	[self.sendTweetButton release];
	[self.twitterEngine release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Actions

- (IBAction)xAuthAccessTokenRequestButtonTouchUpInside
{
	NSString *username = self.usernameTextField.text;
	NSString *password = self.passwordTextField.text;
	
	NSLog(@"About to request an xAuth token exchange for username: ]%@[ password: ]%@[.",
		  username, password);
	
	spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
	spinner.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 - 20);
	[self.view addSubview: spinner];
	[spinner startAnimating];
	btnLogin.enabled = NO;
	
	[self.twitterEngine exchangeAccessTokenForUsername:username password:password];
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
	
	[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"cachedXAuthAccessTokenKey"];

	[spinner stopAnimating];
	btnLogin.enabled = YES;
	[[NSNotificationCenter defaultCenter]
	 postNotificationName: @"LoginLabel"
	 object: username];
	
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	if ([applicationDelegate lastScreenType] == kRatingScreen) {
        NSArray *arrTrips = [[NSArray alloc] initWithArray:[[DataManager sharedManager] retrieveTripItems]];
        
        if ([arrTrips count] == 1) 
        {
            [twitterEngine sendUpdate:@"Two more trips & I'll know if I'm EV-compatible. Download the @BMWActiveE EVolve app to see for yourself."];
        } else if ([arrTrips count] == 2) {
            [twitterEngine sendUpdate:@"One more trip & I'll know if I'm EV-compatible. Download the @BMWActiveE EVolve app to see for yourself."];
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
                [twitterEngine sendUpdate:@"I’m an EV Pro! Download the @BMWActiveE EVolve app to see how EV-compatible you are."];
            } else if (flRating > .66) {
                [twitterEngine sendUpdate:@"I’m EV-ready. Download the @BMWActiveE EVolve app to see how EV-compatible you are."];
            } else {
                [twitterEngine sendUpdate:@"I’m EV-compatible. Download the @BMWActiveE EVolve app to see how EV-compatible you are."];
            }
        }

        
		[applicationDelegate displayRatingView];
	} else if ([applicationDelegate lastScreenType] == kTripResultsScreen) {
        [twitterEngine sendUpdate:@"I just used the @BMWActiveE EVolve app to track and learn about my driving patterns. Join the mission."];
		[applicationDelegate displayTripResultsView];
	}
    
	
	//[self performSelector: @selector(dismissModalViewControllerAnimated:) 
			   //withObject: (id) kCFBooleanTrue afterDelay: 0.0];
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
	
	[spinner stopAnimating];
	btnLogin.enabled = YES;
	[passwordTextField becomeFirstResponder];

	
	//UIAlertViewQuick(@"Authentication error", @"Please check your username and password and try again.", @"OK");

	if ([[error domain] isEqualToString: @"HTTP"])
	{
		switch ([error code]) {
				
			case 22:
			{
				
				UIAlertViewQuick(@"No Connection", @"You've lost your Internet connection. Please reconnect and try again.", @"OK");	
				break;				
			}
				
			case -1012:
			{
				// Unauthorized. The user's credentials failed to verify.
				UIAlertViewQuick(@"Invalid Login", @"Your username and password could not be verified. Double check that you entered them correctly and try again.", @"OK");	
				break;				
			}
				
			case 502:
			{
				// Bad gateway: twitter is down or being upgraded.
				UIAlertViewQuick(@"Twitter's Down", @"Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");	
				break;				
			}
				
			case 503:
			{
				// Service unavailable
				UIAlertViewQuick(@"Twitter's Busy", @"Twitter is overloaded. Please wait a few seconds and try again.", @"OK");	
				break;								
			}
				
			default:
			{
				NSString *errorMessage = [[NSString alloc] initWithFormat: @"%d %@", [error	code], [error localizedDescription]];
				UIAlertViewQuick(@"Twitter error!", @"Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");	
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
				
			case -1012:
			{
				// Unauthorized. The user's credentials failed to verify.
				UIAlertViewQuick(@"Invalid Login", @"Your username and password could not be verified. Double check that you entered them correctly and try again.", @"OK");	
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
				UIAlertViewQuick(@"Twitter's Down", @"Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");
				[errorMessage release];
			}
		}
	}
}


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
				NSString *errorMessage = [[NSString alloc] initWithFormat:@"%@ xx %d: %@", [error domain], [error code], [error localizedDescription]];
				UIAlertViewQuick(@"Twitter's Down", @"Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");
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
				UIAlertViewQuick(@"Twitter's Down", @"Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");
				[errorMessage release];
			}
		}
	}
	
}


@end
