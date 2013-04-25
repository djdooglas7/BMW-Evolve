//
//  SetupViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/2/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetupViewController : UIViewController <UITextFieldDelegate> {
	
	IBOutlet UIView *introView;
	
	IBOutlet UIView *step1View;
	IBOutlet UITextField *txtFieldZipCode;
	
	IBOutlet UIView *step2View;
	IBOutlet UISwitch *swchShareData;
	
	IBOutlet UIView *step3View;
	IBOutlet UITextField *txtFieldFirstName;
	IBOutlet UITextField *txtFieldLastName;
	IBOutlet UITextField *txtFieldEmail;
}

-(IBAction) continueIntroPressed:(id)sender;
-(IBAction) continueStep1Pressed:(id)sender;
-(IBAction) continueStep2Pressed:(id)sender;
-(IBAction) submitStep3Pressed:(id)sender;
-(IBAction) skipStep3Pressed:(id)sender;
-(IBAction) continueFinishPressed:(id)sender;
-(IBAction) continueURLPressed:(id)sender;
-(void) helpPressed:(id)sender;
- (BOOL) validateEmail: (NSString *) candidate;

@end
