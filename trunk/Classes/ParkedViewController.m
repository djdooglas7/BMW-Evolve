//
//  ParkedViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/14/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "ParkedViewController.h"
#import "DataManager.h"

@implementation ParkedViewController

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
    //[[DataManager sharedManager] setCurrentCharge:99.92];
	isOpprotunityCharging = FALSE;
	
	[self meterGlowOff];
	
	// init miles dial
	[self setDialAndMeter];
	
}



-(void) storeTripSegment:(NSString*)strType
{    
    NSDate *dateToday = [[NSDate alloc] init];
	NSDate *dateStart = [[NSDate alloc] init];
	dateStart = [[DataManager sharedManager] getStartDate];
	
	[[DataManager sharedManager] addTripSegment:strType
								   andStartDate:dateStart 
									 andEndDate:dateToday 
									andDistance:[NSNumber numberWithFloat:0]];
    
	[[DataManager sharedManager] setStartDate:[NSDate date]];
}


-(void) rotateMeter
{	
	double getCurrentCharge = [[DataManager sharedManager] getCurrentCharge];
	CGAffineTransform transform = imgMeter.transform;
	//NSLog(@"transform %f", (M_PI * ((98 - dCharge) / 100.0)));
    // Rotate the view 90 degrees around its new center point.
    transform = CGAffineTransformRotate(transform, ((M_PI * ((98 - getCurrentCharge) / 100.0)) - flLastRotate));
    imgMeter.transform = transform;
	
	transform = imgMeterCharging.transform;
    transform = CGAffineTransformRotate(transform, ((M_PI * ((98 - getCurrentCharge) / 100.0)) - flLastRotate));
	imgMeterCharging.transform = transform;
	flLastRotate = (M_PI * ((98 - getCurrentCharge) / 100.0));
	
}


-(void) setDialAndMeter
{
	double dCharge = [[DataManager sharedManager] getCurrentCharge];
	
	// rotate meter
	CGAffineTransform transform = imgMeter.transform;
    transform = CGAffineTransformRotate(transform, (M_PI * ((98 - dCharge) / 100.0)));
    imgMeter.transform = transform;
	imgMeterCharging.transform = transform;
	flLastRotate = (M_PI * ((98 - dCharge) / 100.0));
	
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
                        intDigit1 = [strChar intValue];
						break;
					case 3:
						[currentDigit2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_white_%@.png", strChar]]];
                        intDigit2 = [strChar intValue];
						break;
					case 2:
						[currentDigit3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_white_%@.png", strChar]]];
                        intDigit3 = [strChar intValue];
						break;
					case 0:
						[currentDigit4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_black_%@.png", strChar]]];
                        intDigit4 = [strChar intValue];
						break;
					default:
						break;
				}
			}	
		}
	}
}


-(void) turnDialAndMeter
{
	double dCharge = [[DataManager sharedManager] getCurrentCharge];
	
	if (dCharge < 100.0) 
	{
        dCharge += .1;
        
		// add to current charge
		[[DataManager sharedManager] setCurrentCharge:(dCharge)];
		
		// move charge meter
		[self rotateMeter];
		
		dCharge = [[DataManager sharedManager] getCurrentCharge];
		NSString *strCharge = [[NSString alloc] initWithFormat:@"%.1f", dCharge];
		
		// loop through the digits of the charge, process from last to first
		for (int i=0; i<5; i++) {
			int intDigit = [strCharge length]-1-i;
			if (intDigit >= 0) {
				NSRange range = {intDigit,1};
				NSString *strChar = [NSString stringWithFormat:@"%@",[strCharge substringWithRange:range]];
				if (![strChar isEqualToString:@"."]) {
                    switch (i) {
                        case 4:
                            if (intDigit1 != [strChar intValue]) {
                                
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit1 
                                            andNewImageView:newDigit1 
                                            andCurrentValue:strChar];
                                intDigit1 = [strChar intValue];
                            }
                            break;
                        case 3:
                            if (intDigit2 != [strChar intValue]) {
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit2 
                                            andNewImageView:newDigit2
                                            andCurrentValue:strChar];
                                intDigit2 = [strChar intValue];
                            }
                            break;
                        case 2:
                            if (intDigit3 != [strChar intValue]) {
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit3 
                                            andNewImageView:newDigit3 
                                            andCurrentValue:strChar];
                                intDigit3 = [strChar intValue];
                            }
                            break;
                        case 0:
                            if (intDigit4 != [strChar intValue]) {
                                [self currentDigitAnimation:i
                                        andCurrentImageView:currentDigit4 
                                            andNewImageView:newDigit4 
                                            andCurrentValue:strChar];
                                intDigit4 = [strChar intValue];
                            }
                            break;
                        default:
                            break;
                    }
					
                }	
			}
		}
	}
}


-(void) currentDigitAnimation:(int)intDigitCount
		  andCurrentImageView:(UIImageView*)imgViewCurrent
			  andNewImageView:(UIImageView*)imgViewNew
			  andCurrentValue:(NSString*)strValue
{
    double dCharge = [[DataManager sharedManager] getCurrentCharge];
	
	if (dCharge < 100.1) 
	{
        if (intDigitCount == 0) {
            [imgViewNew setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_black_%@.png", strValue]]];
        } else {
            [imgViewNew setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_white_%@.png", strValue]]];
        }
        
        NSArray *arrDigitAnimation = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:intDigitCount], imgViewCurrent, imgViewNew, strValue, nil];

        // animate image views
        [UIView beginAnimations:nil context:arrDigitAnimation];
        [UIView setAnimationDuration:2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatCount:0];
        [UIView setAnimationDidStopSelector:@selector(digitAnimationFinished:finished:context:)];
        
        CGRect frame = imgViewCurrent.frame;	
        frame.origin.y = 1;
        imgViewCurrent.frame = frame;
        
        frame = imgViewNew.frame;	
        frame.origin.y = 76;
        imgViewNew.frame = frame;
        
        [UIView commitAnimations];
    }
}


-(void) digitAnimationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
	NSArray *arrDigitAnimation = [NSArray arrayWithArray:context];
	//NSLog(@"%i", [arrDigitAnimation count]);
	
	int intDigitCount = [[arrDigitAnimation objectAtIndex:0] intValue];
	UIImageView *imgViewCurrent = (UIImageView*)[arrDigitAnimation objectAtIndex:1];
	UIImageView *imgViewNew = (UIImageView*)[arrDigitAnimation objectAtIndex:2];
	NSString *strValue = (NSString*)[arrDigitAnimation objectAtIndex:3];
	
	if (intDigitCount == 0) {
		[imgViewCurrent setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_black_%@.png", strValue]]];
	} else {
		[imgViewCurrent setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_odometer_white_%@.png", strValue]]];
	}
	
	// return imgviews to original position
	CGRect frame = imgViewCurrent.frame;	
	frame.origin.y = 76;
	imgViewCurrent.frame = frame;
	
	frame = imgViewNew.frame;	
	frame.origin.y = 151;
	imgViewNew.frame = frame;
}


-(void) meterGlowOff
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatCount:0];
	[UIView setAnimationDidStopSelector:@selector(meterGlow)];
	
	imgGaugeCharging.alpha = 0;
	imgMeterCharging.alpha = 0;
	
	[UIView commitAnimations];
	
}


-(void) meterGlow
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatCount:0];
	[UIView setAnimationDidStopSelector:@selector(meterGlowOff)];
	
	imgGaugeCharging.alpha = 1;
	imgMeterCharging.alpha = 1;
	
	[UIView commitAnimations];

}


-(void) startChargeTimer
{
	[self stopChargeTimer];
	
	if (isOpprotunityCharging) 
	{
		if (!timerCharge)
			timerCharge = [NSTimer scheduledTimerWithTimeInterval:90.0 
														   target:self 
														 selector:@selector(turnDialAndMeter) 
														 userInfo:nil 
														  repeats:YES];
	} else {
		if (!timerCharge)
			timerCharge = [NSTimer scheduledTimerWithTimeInterval:14.4 
														   target:self 
														 selector:@selector(turnDialAndMeter) 
														 userInfo:nil 
														  repeats:YES];
	}
}


-(void) stopChargeTimer
{
	if (timerCharge) {
		[timerCharge invalidate];
		timerCharge = nil;
	}
}


- (void)chargePressed:(id)sender
{
	if ([[btnCharge currentTitle] isEqualToString:@"STOP CHARGING"]) 
	{
		[self stopChargeTimer];
		[btnCharge setTitle:@"GET CHARGED" forState:UIControlStateNormal];
        [navItemTitle setTitle:@"Parked"];
		isOpprotunityCharging = FALSE;
		[btnChargeType setImage:[UIImage imageNamed:@"plug.png"] forState:UIControlStateNormal];
		
		if (isOpprotunityCharging) 
		{
			[self storeTripSegment:@"Opprotunity"];
		} else {
			[self storeTripSegment:@"Station"];
		}
		
		imgGaugeCharging.hidden = YES;
		imgMeterCharging.hidden = YES;
		
	} else if ([[btnCharge currentTitle] isEqualToString:@"GET CHARGED"]) 
	{
		[self startChargeTimer];
		[btnCharge setTitle:@"STOP CHARGING" forState:UIControlStateNormal];
        [navItemTitle setTitle:@"Charging"];
		
		[self storeTripSegment:@"Parked"];
		
		imgGaugeCharging.hidden = NO;
		imgMeterCharging.hidden = NO;
	}
}


-(void) percentPressed:(id)sender
{
	if (viewMiles.hidden == NO) {
		viewMiles.hidden = YES;
	} else {
		viewMiles.hidden = NO;
	}
}


- (void)chargeTypePressed:(id)sender
{

	if (isOpprotunityCharging) 
	{
		isOpprotunityCharging = FALSE;
		[self stopChargeTimer];
		imgGaugeCharging.hidden = YES;
		imgMeterCharging.hidden = YES;
		[btnCharge setTitle:@"GET CHARGED" forState:UIControlStateNormal];
        [navItemTitle setTitle:@"Parked"];
		[btnChargeType setImage:[UIImage imageNamed:@"plug.png"] forState:UIControlStateNormal];
		[self storeTripSegment:@"Opprotunity"];
		
	} else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flex Charge" 
														message:@"Made an unexpected detour?\n\nDrive with confidence knowing the BMW ActiveE allows you to Flex Charge your battery by simply plugging your EV into a three-prong outlet, giving you an additional 4 miles for every hour charged."
													   delegate:self 
											  cancelButtonTitle:@"Go Back" 
											  otherButtonTitles:@"Flex Charge", nil];
		[alert show];
		[alert release];
		
	}
}


- (void)drivePressed:(id)sender
{
	[self stopChargeTimer];
	imgGaugeCharging.hidden = YES;
	imgMeterCharging.hidden = YES;
	
	if ([[btnCharge currentTitle] isEqualToString:@"STOP CHARGING"])  
	{
		if (isOpprotunityCharging) 
		{
			[self storeTripSegment:@"Opprotunity"];
		} else {
			[self storeTripSegment:@"Station"];
		}
	} else {
		
		[self storeTripSegment:@"Parked"];
	}
	
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayTripView];
	[[applicationDelegate bmwe3ViewController] startLocationManager];
    [applicationDelegate resetParkScreen];
}


- (void)endPressed:(id)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End Trip" message:@"By clicking END TRIP, you are simulating the end of your driving day or the start of a different trip type."
												   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End Trip", nil];
	[alert show];
	[alert release];
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


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	if ((alertView.title == @"Flex Charge") && (buttonIndex == 1))
	{
		isOpprotunityCharging = TRUE;
		if ([[btnCharge currentTitle] isEqualToString:@"STOP CHARGING"]) 
		{
			[self storeTripSegment:@"Station"];
		} else {
			[self storeTripSegment:@"Parked"];
			
		}
		[self startChargeTimer];
		imgGaugeCharging.hidden = NO;
		imgMeterCharging.hidden = NO;
		[btnChargeType setImage:[UIImage imageNamed:@"plugCharging.png"] forState:UIControlStateNormal];
		[btnCharge setTitle:@"STOP CHARGING" forState:UIControlStateNormal];
        [navItemTitle setTitle:@"Flex Charging"];
	}
	
	if ((alertView.title == @"End Trip") && (buttonIndex == 1))
	{
		[self stopChargeTimer];
		
		if ([[btnCharge currentTitle] isEqualToString:@"STOP CHARGING"]) 
		{
			if (isOpprotunityCharging) 
			{
				[self storeTripSegment:@"Opprotunity"];
			} else {
				[self storeTripSegment:@"Station"];
			}
		} else {
			
			[self storeTripSegment:@"Parked"];
		}
		
		id applicationDelegate = [[UIApplication sharedApplication] delegate];
		[applicationDelegate displayFinishTripView];
		[applicationDelegate resetParkScreen];
	} 
}


// add charge while app was in background
- (void)switchToBackgroundMode:(BOOL)background
{
    if (background)
    {
        [[DataManager sharedManager] setSleepDate:[NSDate date]];
        //[self stopChargeTimer];
    }
    else
    {
        double dCharge = [[DataManager sharedManager] getCurrentCharge];
        NSDate *dateWake = [NSDate date];
        NSTimeInterval intervalTotalDiff = [dateWake timeIntervalSinceDate:[[DataManager sharedManager] getSleepDate]];
        double dTotalDiff = (double)intervalTotalDiff;
        
        if ([[btnCharge currentTitle] isEqualToString:@"STOP CHARGING"]) 
		{
			if (isOpprotunityCharging) 
			{
				dCharge += (dTotalDiff / 900);
			} else {
				dCharge += (dTotalDiff / 144);
			}
            if (dCharge > 100.0) {
                dCharge = 100.0;
            }
            [[DataManager sharedManager] setCurrentCharge:dCharge];
            
            if (isOpprotunityCharging) 
			{
                if (dTotalDiff >= 90) {
                    [self turnDialAndMeter];
                }
			} else {
				if (dTotalDiff >= 14.4) {
                    [self turnDialAndMeter];
                }
			}
            
            //[self startChargeTimer];
		}
    }
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
