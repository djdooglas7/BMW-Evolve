//
//  UpdatesViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface UpdatesViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, UITextFieldDelegate> {

	IBOutlet UITextField *txtFieldFirstName;
	IBOutlet UITextField *txtFieldLastName;
	IBOutlet UITextField *txtFieldEmail;
	
	Facebook* _facebook;
	NSArray* arrPermissions;
	NSArray* _permissions;
	NSString* _token;
	BOOL blnFbLoggedIn;
	
	IBOutlet UIView *viewStart;
	IBOutlet UIView *viewEmail;
}

@property (nonatomic, retain) Facebook* _facebook;

-(void) submitPressed:(id)sender;
-(IBAction) continueURLPressed:(id)sender;
-(IBAction)fbButtonClick:(id)sender;
-(void) emailPressed:(id)sender;
-(void) backStartPressed:(id)sender;
-(void) backEmailPressed:(id)sender;

@end
