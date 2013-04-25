//
//  TripResultsViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 1/28/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "Trip.h"
#import "XAuthTwitterViewController.h"
#import "XAuthTwitterEngineDelegate.h"

@class XAuthTwitterEngine;

@interface TripResultsViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, XAuthTwitterEngineDelegate> {

	Facebook* _facebook;
	NSArray* arrPermissions;
	BOOL blnFbLoggedIn;
	
	IBOutlet UILabel *lblName;
	IBOutlet UILabel *lblTime;
	IBOutlet UILabel *lblDist;
	IBOutlet UILabel *lblDriving;
	IBOutlet UILabel *lblParked;
	IBOutlet UILabel *lblCharging;
	IBOutlet UILabel *lblCharge;
	
	NSArray *arrTips;
	IBOutlet UIImageView *imgTip;
	int intTipCounter;
	IBOutlet UILabel *lblTip;
	IBOutlet UIImageView *imgBadge;
	
	Trip *trip;
	NSTimeInterval intervalTotalDiff;
	NSTimeInterval intervalDrivingDiff;
	NSTimeInterval intervalParkedDiff;
	NSTimeInterval intervalChargingDiff;
	NSTimeInterval intervalFlexChargingDiff;
	float flTotalMiles;
	
	XAuthTwitterEngine *_engine;
	NSString *username;
	UIActivityIndicatorView	*spinner;
    
    NSString *strFBMsg;
    NSString *strTwitterMsg;
}

@property (nonatomic, retain) Facebook* _facebook;
@property (nonatomic, retain) XAuthTwitterEngine *_engine;

-(IBAction) homePressed:(id)sender;
-(IBAction) ratingsPressed:(id)sender;
-(IBAction) followPressed:(id)sender;
-(void) tipsPressed:(id)sender;
-(void) fbButtonClick:(id)sender;
-(void) tipDetailPressed:(id)sender;
-(void) twitterPressed:(id)sender;
- (void)twitterSucceeded:(NSNotification *)aNotification;
- (void)twitterFailed:(NSNotification *)aNotification;

@end
