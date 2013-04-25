//
//  SettingsViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 11/8/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UISwitch *swchShareData;
    IBOutlet UISwitch *toggleNavigationAccuracyButton;
	IBOutlet UITextField *txtFieldZipCode;
    
    int *intLastScreen;
}


@property (nonatomic, retain) IBOutlet UISwitch *toggleNavigationAccuracyButton;


- (IBAction)toggleBestAccuracy:(id)sender;
- (void)switchToBackgroundMode:(BOOL)background;
-(void) backPressed:(id)sender;
-(void) helpPressed:(id)sender;
-(void) updatesPressed:(id)sender;

@end
