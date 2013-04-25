//
//  UpdatesViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UpdatesViewController.h"
#import "DataManager.h"
#import "BMWE3AppDelegate.h"

static NSString* kAppId = @"154480201269892";

@implementation UpdatesViewController

@synthesize _facebook;

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
	
	_facebook = [[Facebook alloc] initWithAppId:kAppId];
	arrPermissions =  [[NSArray arrayWithObjects:
						@"publish_stream",@"read_stream", @"offline_access",nil] retain];
}



-(void) submitPressed:(id)sender
{
	if ([txtFieldFirstName.text isEqualToString:@""] || [txtFieldLastName.text isEqualToString:@""] || [txtFieldEmail.text isEqualToString:@""]) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Fields" 
														message:@"Please enter information in all the fields."
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else
	{
		[[DataManager sharedManager] setFirstName:txtFieldFirstName.text];
		[[DataManager sharedManager] setLastName:txtFieldLastName.text];
		[[DataManager sharedManager] setEmail:txtFieldEmail.text];
		[self backEmailPressed:nil];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EVolve Updates" 
														message:@"Thanks for signing up!"
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}


-(IBAction) continueURLPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.BMWActivateTheFuture.com"]];
}


-(void) emailPressed:(id)sender
{
	NSLog(@"email %@", [[DataManager sharedManager] getEmail]);
	if (![[DataManager sharedManager] getEmail]) 
	{
		viewEmail.hidden = NO;
		viewStart.hidden = YES;
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Connected" 
														message:@"Looks like you’re previously signed up for the latest news on the future of mobility. Stay tuned for more updates."
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}


-(void) backEmailPressed:(id)sender
{
	viewEmail.hidden = YES;
	viewStart.hidden = NO;
}


-(void) backStartPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	if ([applicationDelegate lastScreenType] == kRatingScreen) {
		[applicationDelegate displayRatingView];
	} else if ([applicationDelegate lastScreenType] == kSettingsScreen) {
		[applicationDelegate displaySettingsView];
	} else if ([applicationDelegate lastScreenType] == kTripResultsScreen) {
		[applicationDelegate displayTripResultsView];
	}
}


-(void) setViewPos:(float)flYPos
{
	// animate image views
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatCount:0];
	
	CGRect frame = self.view.frame;	
	frame.origin.y = flYPos;
	self.view.frame = frame;
	
	[UIView commitAnimations];
}


#pragma mark - fb methods

- (IBAction)fbButtonClick:(id)sender 
{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSDate *currentDate = [[NSDate alloc] init];
	
	if (![[DataManager sharedManager] getFacebookId]) 
	{
		// Authenticate user if not logged in or access topken has expired
		if ([prefs stringForKey:@"accessToken"] == nil || [currentDate compare:[prefs objectForKey:@"expirationDate"]] == NSOrderedDescending) {
			NSLog(@"Log In");
			[_facebook authorize:arrPermissions delegate:self];
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"You've already logged into Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"You've already logged into Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

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
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
}

-(void) fbDidLogout {
	if (_facebook.accessToken != nil) {
		NSLog(@"Test fail for test Logout");
	} 
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result{
	NSLog(@"request %@", result);
	// store facebook id
	NSDictionary *dictResult = [NSDictionary dictionaryWithDictionary:result];
	NSString *strId = [NSString stringWithString:[dictResult objectForKey:@"id"]];
	NSArray *arrId = [strId componentsSeparatedByString:@"_"];
	[[DataManager sharedManager] setFacebookId:[arrId objectAtIndex:0]];
	 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Your Facebook login was successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Your login failed to connect to Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

- (void)dialogCompleteWithUrl:(NSURL *)url {
	NSLog(@"dialogCompleteWithUrl");
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


#pragma mark - text field methods

- (BOOL)textFieldShouldReturn: (UITextField *)textField {
	[textField resignFirstResponder];
	[self setViewPos:20];
	return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:txtFieldLastName])
    {
        [self setViewPos:-60];
        
    } else if ([sender isEqual:txtFieldEmail])
    {
        [self setViewPos:-120];
        
    } else if ([sender isEqual:txtFieldFirstName])
    {
        [self setViewPos:0];
        
    }
}



- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	[self setViewPos:20];
	[txtFieldFirstName resignFirstResponder];
	[txtFieldLastName resignFirstResponder];
	[txtFieldEmail resignFirstResponder];
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
    [super dealloc];
}


@end
