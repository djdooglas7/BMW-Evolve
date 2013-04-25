//
//  BMWE3AppDelegate.m
//  BMWE3
//
//  Created by Doug Strittmatter on 11/2/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "BMWE3AppDelegate.h"
#import "BMWE3ViewController.h"
#import "DailyHistoryViewController.h"
#import "DiveViewController.h"
#import "EnvironmentViewController.h"
#import "FinishTripViewController.h"
#import "HelpViewController.h"
#import "MapHistoryViewController.h"
#import "ParkedViewController.h"
#import "RatingViewController.h"
#import "ResultsViewController.h"
#import "SavingsViewController.h"
#import "SettingsViewController.h"
#import "SetupViewController.h"
#import "StartTripViewController.h"
#import "TipDetailViewController.h"
#import "TipsViewController.h"
#import "TripHistoryViewController.h"
#import "TripResultsViewController.h"
#import "UpdatesViewController.h"
#import "XAuthTwitterViewController.h"
#import "DataManager.h"

@implementation BMWE3AppDelegate

@synthesize window;
@synthesize bmwe3ViewController;
@synthesize dailyHistoryViewController;
@synthesize diveViewController;
@synthesize environmentViewController;
@synthesize finishTripViewController;
@synthesize helpViewController;
@synthesize mapHistoryViewController;
@synthesize parkedViewController;
@synthesize ratingViewController;
@synthesize resultsViewController;
@synthesize savingsViewController;
@synthesize settingsViewController;
@synthesize setupViewController;
@synthesize startTripViewController;
@synthesize tipDetailViewController;
@synthesize tipsViewController;
@synthesize tripHistoryViewController;
@synthesize tripResultsViewController;
@synthesize updatesViewController;
@synthesize xAuthTwitterViewController;
@synthesize tabController;
@synthesize currentScreenType;
@synthesize lastScreenType;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    
    // disable app shutdown
	[[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    hasPassedMidnight = NO;
    isNotDriving = NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if ([prefs objectForKey:@"LocationAccuracyBestForNavigation"] == nil) 
	{
        [[DataManager sharedManager] addPreferences];
    }
	
    if (![[DataManager sharedManager] getChargeResetDate]) {
        [self findMidnight];
    }
    
    [self resetCharge];
    [NSTimer scheduledTimerWithTimeInterval:60
									 target:self 
								   selector:@selector(resetCharge) 
								   userInfo:nil 
									repeats:YES];

    // Add the view controller's view to the window and display.
    //[window addSubview:tabController.view];
    [window makeKeyAndVisible];
	
	if ([[DataManager sharedManager] getSetupComplete]) {
		[self displayStartTripView];
	} else {
		[self displaySetupView];
	}
    
    [self signupAlert];

    return YES;
}


- (void) displayController:(UIViewController *)ctrl 
{
	[self removePreviousView];
	
    if ([ctrl.view superview]) 
	{
        [window bringSubviewToFront:ctrl.view];
	}
	else
	{
		[window addSubview:ctrl.view];
		//[self fadeTransition:DURATION_TRANSITION_FADE];
	}		
}


- (void) removePreviousView
{
	lastScreenType = currentScreenType;
	switch (currentScreenType)
	{
		case kTripScreen:
			[[bmwe3ViewController view] removeFromSuperview];
			break;
			
		case kDailyHistoryScreen:
			[[dailyHistoryViewController view] removeFromSuperview];
			dailyHistoryViewController = nil;
			break;
			
		case kDiveScreen:
			[[diveViewController view] removeFromSuperview];
			break;
			
		case kEnvironmentScreen:
			[[environmentViewController view] removeFromSuperview];
            environmentViewController = nil;
			break;
			
		case kFinishTripScreen:
			[[finishTripViewController view] removeFromSuperview];
			break;
			
		case kHelpScreen:
			[[helpViewController view] removeFromSuperview];
			break;
			
		case kMapHistoryScreen:
			[[mapHistoryViewController view] removeFromSuperview];
			break;	
			
		case kParkScreen:
			[[parkedViewController view] removeFromSuperview];
			break;
			
		case kRatingScreen:
			[[ratingViewController view] removeFromSuperview];
			ratingViewController = nil;
			break;
			
		case kResultsScreen:
			[[resultsViewController view] removeFromSuperview];
			break;
			
		case kSavingsScreen:
			[[savingsViewController view] removeFromSuperview];
            savingsViewController = nil;
			break;
			
		case kSettingsScreen:
			[[settingsViewController view] removeFromSuperview];
			break;
			
		case kSetupScreen:
			[[setupViewController view] removeFromSuperview];
			break;
			
		case kStartTripScreen:
			[[startTripViewController view] removeFromSuperview];
			startTripViewController = nil;
			break;
			
		case kTipDetailScreen:
			[[tipDetailViewController view] removeFromSuperview];
			tipDetailViewController = nil;
			break;
			
		case kTipsScreen:
			[[tipsViewController view] removeFromSuperview];
			break;
			
		case kTripHistoryScreen:
			[[tripHistoryViewController view] removeFromSuperview];
			break;
			
		case kTripResultsScreen:
			[[tripResultsViewController view] removeFromSuperview];
            tripResultsViewController = nil;
			break;
			
		case kUpdatesScreen:
			[[updatesViewController view] removeFromSuperview];
			break;
			
		case kXAuthTwitterScreen:
			[[xAuthTwitterViewController view] removeFromSuperview];
			break;
			
		default:
			break;
	}
}


-(void) displayTripView
{
	if (!bmwe3ViewController) {
		bmwe3ViewController = [[BMWE3ViewController alloc] initWithNibName:@"BMWE3ViewController" bundle:nil];
		
	}
    
	[self displayController:bmwe3ViewController];
	currentScreenType = kTripScreen;
}


-(void) displayDailyHistoryView
{
	if (!dailyHistoryViewController) {
		dailyHistoryViewController = [[DailyHistoryViewController alloc] initWithNibName:@"DailyHistoryViewController" bundle:nil];
		
	}
	
	[self displayController:dailyHistoryViewController];
	currentScreenType = kDailyHistoryScreen;
}


-(void) displayDiveView
{
	if (!diveViewController) {
		diveViewController = [[DiveViewController alloc] initWithNibName:@"DiveViewController" bundle:nil];
		
	}
	
	[self displayController:diveViewController];
	currentScreenType = kDiveScreen;
}


-(void) displayEnvironmentView
{
	if (!environmentViewController) {
		environmentViewController = [[EnvironmentViewController alloc] initWithNibName:@"EnvironmentViewController" bundle:nil];
		
	}
	
	[self displayController:environmentViewController];
	currentScreenType = kEnvironmentScreen;
}


-(void) displayFinishTripView
{
	if (!finishTripViewController) {
		finishTripViewController = [[FinishTripViewController alloc] initWithNibName:@"FinishTripViewController" bundle:nil];
		
	}
	
	[self displayController:finishTripViewController];
	currentScreenType = kFinishTripScreen;
}


-(void) displayHelpView
{
	if (!helpViewController) {
		helpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
		
	}
	
	[self displayController:helpViewController];
	currentScreenType = kHelpScreen;
}


-(void) displayMapHistoryView
{
	if (!mapHistoryViewController) {
		mapHistoryViewController = [[MapHistoryViewController alloc] initWithNibName:@"MapHistoryViewController" bundle:nil];
		
	}
	
	[self displayController:mapHistoryViewController];
	currentScreenType = kMapHistoryScreen;
}


-(void) displayParkView
{
	if (!parkedViewController) {
		parkedViewController = [[ParkedViewController alloc] initWithNibName:@"ParkedViewController" bundle:nil];
		
	}
	
	[self displayController:parkedViewController];
	currentScreenType = kParkScreen;
}


-(void) displayRatingView
{
	if (!ratingViewController) {
		ratingViewController = [[RatingViewController alloc] initWithNibName:@"RatingViewController" bundle:nil];
		
	}
	
	[self displayController:ratingViewController];
	currentScreenType = kRatingScreen;
}


-(void) displayResultsView
{
	if (!resultsViewController) {
		resultsViewController = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
		
	}
	
	[self displayController:resultsViewController];
	currentScreenType = kResultsScreen;
}


-(void) displaySavingsView
{
	if (!savingsViewController) {
		savingsViewController = [[SavingsViewController alloc] initWithNibName:@"SavingsViewController" bundle:nil];
		
	}
	
	[self displayController:savingsViewController];
	currentScreenType = kSavingsScreen;
}


-(void) displaySettingsView
{
	if (!settingsViewController) {
		settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
		
	}
	
	[self displayController:settingsViewController];
	currentScreenType = kSettingsScreen;
}


-(void) displaySetupView
{
	if (!setupViewController) {
		setupViewController = [[SetupViewController alloc] initWithNibName:@"SetupViewController" bundle:nil];
		
	}
	
	[self displayController:setupViewController];
	currentScreenType = kSetupScreen;
}


-(void) displayStartTripView
{
	if (!startTripViewController) {
		startTripViewController = [[StartTripViewController alloc] initWithNibName:@"StartTripViewController" bundle:nil];
		
	}
	
	[self displayController:startTripViewController];
	currentScreenType = kStartTripScreen;
}


-(void) displayTipDetailView
{
	if (!tipDetailViewController) {
		tipDetailViewController = [[TipDetailViewController alloc] initWithNibName:@"TipDetailViewController" bundle:nil];
		
	}
	
	[self displayController:tipDetailViewController];
	currentScreenType = kTipDetailScreen;
}


-(void) displayTipsView
{
	if (!tipsViewController) {
		tipsViewController = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:nil];
		
	}
	
	[self displayController:tipsViewController];
	currentScreenType = kTipsScreen;
}


-(void) displayTripHistoryView
{
	if (!tripHistoryViewController) {
		tripHistoryViewController = [[TripHistoryViewController alloc] initWithNibName:@"TripHistoryViewController" bundle:nil];
		
	}
	
	[self displayController:tripHistoryViewController];
	currentScreenType = kTripHistoryScreen;
}


-(void) displayTripResultsView
{
	if (!tripResultsViewController) {
		tripResultsViewController = [[TripResultsViewController alloc] initWithNibName:@"TripResultsViewController" bundle:nil];
		
	}
	
	[self displayController:tripResultsViewController];
	currentScreenType = kTripResultsScreen;
}


-(void) displayUpdatesView
{
	if (!updatesViewController) {
		updatesViewController = [[UpdatesViewController alloc] initWithNibName:@"UpdatesViewController" bundle:nil];
		
	}
	
	[self displayController:updatesViewController];
	currentScreenType = kUpdatesScreen;
}


-(void) displayXAuthTwitterView
{
	if (!xAuthTwitterViewController) {
		xAuthTwitterViewController = [[XAuthTwitterViewController alloc] initWithNibName:@"XAuthTwitterViewController" bundle:nil];
		
	}
	
	[self displayController:xAuthTwitterViewController];
	currentScreenType = kXAuthTwitterScreen;
}


// Facebook authentication handler
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if (currentScreenType == kRatingScreen) {
		return [[ratingViewController _facebook] handleOpenURL:url];
	} else if (currentScreenType == kTripResultsScreen) {
		return [[tripResultsViewController _facebook] handleOpenURL:url];
	} else if (currentScreenType == kUpdatesScreen) {
		return [[updatesViewController _facebook] handleOpenURL:url];
	}	
}


-(void) resetTips
{
	tipsViewController = nil;
}


-(void) resetDrivingScreen
{
	bmwe3ViewController = nil;
}


-(void) resetParkScreen
{
	parkedViewController = nil;
}


-(void) resetCharge
{
    if (!hasPassedMidnight) {
        NSDate *today = [NSDate date];
        if ([today compare:[[DataManager sharedManager] getChargeResetDate]] == NSOrderedDescending) {
            hasPassedMidnight = YES;
        }
    }
	if (currentScreenType != kTripScreen && currentScreenType != kParkScreen && currentScreenType != kFinishTripScreen && currentScreenType != kTripResultsScreen ) {
        isNotDriving = YES;
    } else {
        isNotDriving = NO;
    }
    if (hasPassedMidnight && isNotDriving) {
        [[DataManager sharedManager] setCurrentCharge:100.0];
        hasPassedMidnight = NO;
        isNotDriving = NO;
        [self findMidnight];
    }
}



-(void) findMidnight
{
    
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:today options:0];
    [components release];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    components = [gregorian components:unitFlags fromDate:tomorrow];
    components.hour = 0;
    components.minute = 0;
    
    NSDate *tomorrowMidnight = [gregorian dateFromComponents:components];
    [[DataManager sharedManager] setChargeResetDate:tomorrowMidnight];
    //NSLog(@"tomorrowMidnight %@", tomorrowMidnight);
    [gregorian release];
}


-(void) signupAlert
{
    if ([[DataManager sharedManager] getSubmitInfo] == 3) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get Involved" message:@"Just a reminder that signing up for updates gives you exclusive access to news on the future of mobility."
													   delegate:self cancelButtonTitle:@"Ignore" otherButtonTitles:@"Sign Up",nil];
		[alert show];
		[alert release];
        [[DataManager sharedManager] setSubmitInfo:4];
	} 
	else if ([[DataManager sharedManager] getSubmitInfo] < 3) 
	{
		[[DataManager sharedManager] setSubmitInfo:([[DataManager sharedManager] getSubmitInfo] + 1)];
	}
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 1)
	{
		[self displayUpdatesView];
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //BMWE3ViewController *mainViewController = (BMWE3ViewController *)self.tabController.selectedViewController;
    //[mainViewController switchToBackgroundMode:YES];

	switch (currentScreenType)
	{
		case kTripScreen:
			[bmwe3ViewController switchToBackgroundMode:YES];
			break;
            
        case kParkScreen:
            if (parkedViewController) {
                [parkedViewController switchToBackgroundMode:YES];
            }
            break;
			
		default:
			break;
	}

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //BMWE3ViewController *mainViewController = (BMWE3ViewController *)self.tabController.selectedViewController;
    //[mainViewController switchToBackgroundMode:NO];
	
	switch (currentScreenType)
	{
		case kTripScreen:
			[bmwe3ViewController switchToBackgroundMode:NO];
			break;
            
        case kParkScreen:
            if (parkedViewController) {
                [parkedViewController switchToBackgroundMode:NO];
            }
            break;
			
		default:
			break;
	}
    
    [self signupAlert];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
    [bmwe3ViewController release];
	[dailyHistoryViewController release];
	[diveViewController release];
	[environmentViewController release];
	[finishTripViewController release];
	[helpViewController release];
	[mapHistoryViewController release];
	[parkedViewController release];
	[ratingViewController release];
	[resultsViewController release];
	[savingsViewController release];
	[settingsViewController release];
	[setupViewController release];
	[startTripViewController release];
	[tipDetailViewController release];
	[tipsViewController release];
	[tripHistoryViewController release];
	[tripResultsViewController release];
	[updatesViewController release];
	[xAuthTwitterViewController release];
    [window release];
    [super dealloc];
}


@end
