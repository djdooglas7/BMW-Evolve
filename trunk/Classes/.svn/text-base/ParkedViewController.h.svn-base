//
//  ParkedViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/14/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ParkedViewController : UIViewController <UIAlertViewDelegate> {

	IBOutlet UIButton *btnCharge;
	IBOutlet UIButton *btnChargeType;
	BOOL isOpprotunityCharging;
	
	IBOutlet UIImageView *imgMeter;
	IBOutlet UIImageView *imgMeterCharging;
	IBOutlet UIImageView *imgGaugeCharging;
	NSTimer *timerMeter;
	float flLastRotate;
	
	IBOutlet UIView *viewMiles;
	IBOutlet UIImageView *currentDigit1;
	IBOutlet UIImageView *newDigit1;
	IBOutlet UIImageView *currentDigit2;
	IBOutlet UIImageView *newDigit2;
	IBOutlet UIImageView *currentDigit3;
	IBOutlet UIImageView *newDigit3;
	IBOutlet UIImageView *currentDigit4;
	IBOutlet UIImageView *newDigit4;
    
    int intDigit1;
    int intDigit2;
    int intDigit3;
    int intDigit4;

	BOOL wasLastCharZero;
	NSTimer *timerCharge;
    
    IBOutlet UINavigationItem *navItemTitle;
     
}

- (void)chargePressed:(id)sender;
- (void)chargeTypePressed:(id)sender;
- (void)drivePressed:(id)sender;
- (void)endPressed:(id)sender;
-(void) percentPressed:(id)sender;
-(void) settingsPressed:(id)sender;
-(void) helpPressed:(id)sender;
-(void) switchToBackgroundMode:(BOOL)background;

@end
