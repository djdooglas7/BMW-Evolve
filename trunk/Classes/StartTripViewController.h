//
//  StartTripViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/3/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartTripViewController : UIViewController <UIAlertViewDelegate> {
	
	BOOL isCharging;
	NSTimer *timerCharge;
	IBOutlet UIView *startView;
	
	IBOutlet UILabel *lblTip;
	IBOutlet UIImageView *imgTip;
	IBOutlet UIImageView *imgBadge;
	int intTipCounter;
	NSArray *arrTips;
	
	IBOutlet UIImageView *imgMeter;
	
	IBOutlet UILabel *lblHelp;
	
	IBOutlet UIView *viewMiles;
	IBOutlet UIImageView *currentDigit1;
	IBOutlet UIImageView *currentDigit2;
	IBOutlet UIImageView *currentDigit3;
	IBOutlet UIImageView *currentDigit4;
}

-(IBAction) startTripPressed:(id)sender;
-(void) startDrivingPressed:(id)sender;
-(void) ratingPressed:(id)sender;
-(void) backPressed:(id)sender;
-(void) settingsPressed:(id)sender;
-(void) helpPressed:(id)sender;
-(void) percentPressed:(id)sender;
-(void) tipDetailPressed:(id)sender;

@end
