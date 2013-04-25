//
//  BMWE3AppDelegate.h
//  BMWE3
//
//  Created by Doug Strittmatter on 11/2/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMWE3ViewController;
@class DailyHistoryViewController;
@class DiveViewController;
@class EnvironmentViewController;
@class FinishTripViewController;
@class HelpViewController;
@class MapHistoryViewController;
@class ParkedViewController;
@class RatingViewController;
@class ResultsViewController;
@class SavingsViewController;
@class SettingsViewController;
@class SetupViewController;
@class StartTripViewController;
@class TipDetailViewController;
@class TipsViewController;
@class TripHistoryViewController;
@class TripResultsViewController;
@class UpdatesViewController;
@class XAuthTwitterViewController;

typedef enum screnTypeTag
{
	kDailyHistoryScreen = 0,
	kDiveScreen,
	kEnvironmentScreen,
	kFinishTripScreen,
	kHelpScreen,
	kMapHistoryScreen,
	kParkScreen,
	kRatingScreen,
	kResultsScreen,
	kSavingsScreen,
	kSettingsScreen,
	kSetupScreen,
	kStartTripScreen,
	kTipDetailScreen,
	kTipsScreen,
	kTripHistoryScreen,
	kTripResultsScreen,
	kTripScreen,
	kUpdatesScreen,
	kXAuthTwitterScreen
} ScreenType;

@interface BMWE3AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
	
    UIWindow *window;
	
    BMWE3ViewController *bmwe3ViewController;
	DailyHistoryViewController *dailyHistoryViewController;
	DiveViewController *diveViewController;
	EnvironmentViewController *environmentViewController;
	FinishTripViewController *finishTripViewController;
	HelpViewController *helpViewController;
	MapHistoryViewController *mapHistoryViewController;
	ParkedViewController *parkedViewController;
	RatingViewController *ratingViewController;
	ResultsViewController *resultsViewController;
	SavingsViewController *savingsViewController;
	SettingsViewController *settingsViewController;
	SetupViewController *setupViewController;
	StartTripViewController *startTripViewController;
	TipDetailViewController *tipDetailViewController;
	TipsViewController *tipsViewController;
	TripHistoryViewController *tripHistoryViewController;
	TripResultsViewController *tripResultsViewController;
	UpdatesViewController *updatesViewController;
	XAuthTwitterViewController *xAuthTwitterViewController;
	
	UITabBarController *tabController;
	
	int currentScreenType;
	int lastScreenType;
    
    BOOL isNotDriving;
    BOOL hasPassedMidnight;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BMWE3ViewController *bmwe3ViewController;
@property (nonatomic, retain) IBOutlet DailyHistoryViewController *dailyHistoryViewController;
@property (nonatomic, retain) IBOutlet DiveViewController *diveViewController;
@property (nonatomic, retain) IBOutlet EnvironmentViewController *environmentViewController;
@property (nonatomic, retain) IBOutlet FinishTripViewController *finishTripViewController;
@property (nonatomic, retain) IBOutlet HelpViewController *helpViewController;
@property (nonatomic, retain) IBOutlet MapHistoryViewController *mapHistoryViewController;
@property (nonatomic, retain) IBOutlet ParkedViewController *parkedViewController;
@property (nonatomic, retain) IBOutlet RatingViewController *ratingViewController;
@property (nonatomic, retain) IBOutlet ResultsViewController *resultsViewController;
@property (nonatomic, retain) IBOutlet SavingsViewController *savingsViewController;
@property (nonatomic, retain) IBOutlet SettingsViewController *settingsViewController;
@property (nonatomic, retain) IBOutlet SetupViewController *setupViewController;
@property (nonatomic, retain) IBOutlet StartTripViewController *startTripViewController;
@property (nonatomic, retain) IBOutlet TipDetailViewController *tipDetailViewController;
@property (nonatomic, retain) IBOutlet TipsViewController *tipsViewController;
@property (nonatomic, retain) IBOutlet TripHistoryViewController *tripHistoryViewController;
@property (nonatomic, retain) IBOutlet TripResultsViewController *tripResultsViewController;
@property (nonatomic, retain) IBOutlet UpdatesViewController *updatesViewController;
@property (nonatomic, retain) IBOutlet XAuthTwitterViewController *xAuthTwitterViewController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;
@property (nonatomic, readonly) IBOutlet int currentScreenType;
@property (nonatomic, readonly) IBOutlet int lastScreenType;

-(void) displayTripView;
-(void) displayDailyHistoryView;
-(void) displayDiveView;
-(void) displayEnvironmentView;
-(void) displayFinishTripView;
-(void) displayHelpView;
-(void) displayMapHistoryView;
-(void) displayParkView;
-(void) displayRatingView;
-(void) displayResultsView;
-(void) displaySavingsView;
-(void) displaySettingsView;
-(void) displaySetupView;
-(void) displayStartTripView;
-(void) displayTipDetailView;
-(void) displayTipsView;
-(void) displayTripHistoryView;
-(void) displayTripResultsView;
-(void) displayUpdatesView;
-(void) displayXAuthTwitterView;

-(void) resetTips;
-(void) resetDrivingScreen;
-(void) resetCharge;
-(void) resetParkScreen;

-(void) signupAlert;

@end

