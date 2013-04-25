//
//  SettingsViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 11/8/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "SettingsViewController.h"
#import "DataManager.h"
#import "BMWE3AppDelegate.h"

@implementation SettingsViewController

@synthesize toggleNavigationAccuracyButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	txtFieldZipCode.text = [[DataManager sharedManager] getZipCode];
	toggleNavigationAccuracyButton.on = [[DataManager sharedManager] isLocationAccuracyBestForNavigation];
	swchShareData.on = [[DataManager sharedManager] getShareData];
    
    id applicationDelegate = [[UIApplication sharedApplication] delegate];
    intLastScreen = [applicationDelegate lastScreenType];

}


-(void) viewDidAppear:(BOOL)animated
{
    id applicationDelegate = [[UIApplication sharedApplication] delegate];
    if ([applicationDelegate lastScreenType] != kUpdatesScreen) {
        intLastScreen = [applicationDelegate lastScreenType];
    }
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(void) backPressed:(id)sender
{
	[self processForm];
	
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	if (intLastScreen == kStartTripScreen) {
		[applicationDelegate displayStartTripView];
	} else if (intLastScreen == kParkScreen) {
		[applicationDelegate displayParkView];
	}
}


-(void) helpPressed:(id)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
													message:@"Allow BMW EVolve to maximize the accuracy of your results, while using slightly more energy from your smartphone battery."
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


-(void) updatesPressed:(id)sender
{
	[self processForm];
	
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayUpdatesView];
}


-(void) processForm
{
	/*if ([txtFieldZipCode.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Code" 
														message:@"Please enter a valid zip code."
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {*/
		[[DataManager sharedManager] setZipCode:txtFieldZipCode.text];
		[[DataManager sharedManager] setShareData:swchShareData.on];
		[[DataManager sharedManager] setLocationAccuracyBestForNavigation:toggleNavigationAccuracyButton.isOn];
		
		
	//}
}



- (BOOL)textFieldShouldReturn: (UITextField *)textField {
	[textField resignFirstResponder];

	
	return YES;
}


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {

	[txtFieldZipCode resignFirstResponder];
}


// called them the app is moved to the background (user presses the home button) or to the foreground 
//
- (void)switchToBackgroundMode:(BOOL)background
{

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
