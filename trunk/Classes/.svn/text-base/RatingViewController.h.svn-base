//
//  RatingViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/8/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "XAuthTwitterViewController.h"
#import "XAuthTwitterEngineDelegate.h"

@class XAuthTwitterEngine;

@interface RatingViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, XAuthTwitterEngineDelegate> {

	Facebook* _facebook;
	NSArray* arrPermissions;
	NSArray* _permissions;
	NSString* _token;
	BOOL blnFbLoggedIn;
	
	IBOutlet UIImageView *imgMedal;
	IBOutlet UILabel *lblName;
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblDescription;
	
	XAuthTwitterEngine *_engine;
	NSString *username;
	UIActivityIndicatorView	*spinner;
    
    NSString *strFBMessage;
    NSString *strTwitterMessage;
}

@property (nonatomic, retain) Facebook* _facebook;
@property (nonatomic, retain) XAuthTwitterEngine *_engine;

-(IBAction) diveDeeperPressed:(id)sender;
-(void) backPressed:(id)sender;
-(IBAction) followPressed:(id)sender;
-(void) tipsPressed:(id)sender;
-(void) twitterPressed:(id)sender;
-(IBAction)fbButtonClick:(id)sender;
- (void)twitterSucceeded:(NSNotification *)aNotification;
- (void)twitterFailed:(NSNotification *)aNotification;

@end
