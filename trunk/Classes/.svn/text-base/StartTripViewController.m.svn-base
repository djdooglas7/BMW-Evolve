//
//  StartTripViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/3/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "StartTripViewController.h"
#import "DataManager.h"

@implementation StartTripViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	isCharging = NO;
	intTipCounter = 0;
	//arrTips = [[NSArray alloc] initWithObjects:@"DRIVING TIPS", @"TRAVEL DETAILS", @"DAILY MILEAGE", @"TRIPS MILEAGE", @"SAVINGS", nil];
	NSString *finalPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Tips.plist"];
	NSDictionary *dictPlistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
	arrTips = [dictPlistData objectForKey:@"Tips"];
	
	// init charge meter
	[self rotateMeter];
	
	// init miles dial
	[self setDial];
	
	

	// tip timer
	[NSTimer scheduledTimerWithTimeInterval:10 
									 target:self 
								   selector:@selector(changeTip) 
								   userInfo:nil 
									repeats:YES];
	[self changeTip];
}


-(void) rotateMeter
{
	double dCharge = [[DataManager sharedManager] getCurrentCharge];
	CGAffineTransform transform = imgMeter.transform;
	
    // Rotate the view 90 degrees around its new center point.
    transform = CGAffineTransformRotate(transform, (M_PI * ((98 - dCharge) / 100.0)));
    imgMeter.transform = transform;
}


-(void) setDial
{
	double dCharge = [[DataManager sharedManager] getCurrentCharge];
	NSString *strCharge = [[NSString alloc] initWithFormat:@"%.1f", dCharge];
	
	for (int i=0; i<5; i++) {
		int intDigit = [strCharge length]-1-i;
		if (intDigit >= 0) {
			NSRange range = {intDigit,1};
			NSString *strChar = [NSString stringWithFormat:@"%@",[strCharge substringWithRange:range]];
			if (![strChar isEqualToString:@"."]) {
				switch (i) {
					case 4:
						[currentDigit1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_white_%@.png", strChar]]];
						break;
					case 3:
						[currentDigit2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_white_%@.png", strChar]]];
						break;
					case 2:
						[currentDigit3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_white_%@.png", strChar]]];
						break;
					case 0:
						[currentDigit4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_black_%@.png", strChar]]];
						break;
					default:
						break;
				}
			}	
		}
	}
}



-(IBAction) startTripPressed:(id)sender
{	
	double dCharge = [[DataManager sharedManager] getCurrentCharge];
	NSMutableString *strCharge = [[NSMutableString alloc] init];
	
	if (dCharge == 100) {
		[strCharge appendFormat:@"Your EV Battery is fully charged. You can drive approximately 100 miles before requiring a charge."];
	} else if (dCharge == 0) {
		[strCharge appendFormat:@"It looks like you EV Battery has no remaining charge. You can simulate charging through the Parked mode."];
	} else {
		[strCharge appendFormat:[NSString stringWithFormat:@"Your EV Battery has %.1f charge remaining. You can drive approximately %.1f miles before requiring a charge.", dCharge, dCharge]];
	}

	
	lblHelp.text = [NSString stringWithFormat:@"While DRIVING, your travel will be logged and recorded.\n\nTo pause your commute, press PARK YOUR EV.\n\nTo replenish your battery, press GET CHARGED.\n\n%@", strCharge];
	startView.hidden = NO;
}


-(void) startDrivingPressed:(id)sender
{
	[[DataManager sharedManager] setStartDate:[NSDate date]];
	
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTripView];
	startView.hidden = YES;
}


-(void) ratingPressed:(id)sender
{
	NSArray *arrTrips = [[NSArray alloc] initWithArray:[[DataManager sharedManager] retrieveTripItems]];
	
	if ([arrTrips count] > 0) {
		id applicationDelegate = [[UIApplication sharedApplication] delegate];
		[applicationDelegate displayRatingView];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not So Fast" 
														message:@"In order for BMW EVolve to best assess your information, we recommend recording at least one trip. The more trips you record the more acurate the results."
													   delegate:self 
											  cancelButtonTitle:@"Go Back" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

		
}


-(void) backPressed:(id)sender
{
	startView.hidden = YES;
}


-(void) settingsPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displaySettingsView];
}


-(void) helpPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayHelpView];
}


-(void) tipDetailPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTipDetailView];	
	NSDictionary *dictTip = [arrTips objectAtIndex:intTipCounter];
	[[applicationDelegate tipDetailViewController] setText:[dictTip objectForKey:@"tip"] andBadge:imgBadge.hidden andType:[dictTip objectForKey:@"condition"]];
}


-(void) percentPressed:(id)sender
{
	if (viewMiles.hidden == NO) {
		viewMiles.hidden = YES;
	} else {
		viewMiles.hidden = NO;
	}
}


/*- (IBAction)toggleChargePressed:(id)sender
{
    if (!isCharging) 
	{
		timerCharge = [NSTimer scheduledTimerWithTimeInterval:144 
													   target:self 
													 selector:@selector(chargeAdded) 
													 userInfo:nil 
													  repeats:YES];
	} else {
		if (timerCharge != nil ) {
			[timerCharge invalidate];
			timerCharge = nil;
		}
	}

	
}


-(void) chargeAdded
{
	double dCharge = [[DataManager sharedManager] getCurrentCharge];
	if (dCharge < 100) [[DataManager sharedManager] setCurrentCharge:(dCharge + 1)];
}*/


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	[[DataManager sharedManager] setSubmitInfo:4];
	 
	if (buttonIndex == 1) 
	{
		
	}
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
	
	/*if (intTipCounter == [arrTips count]-1) {
		intTipCounter = 0;
	} else {
		intTipCounter++;
	}*/

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
