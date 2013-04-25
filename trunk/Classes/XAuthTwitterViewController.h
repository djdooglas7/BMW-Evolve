//
//  XAuthTwitterViewController.h
//  XAuthTwitterEngineDemo
//
//  Created by Aral Balkan on 28/02/2010.
//  Copyright Naklab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAuthTwitterEngineDelegate.h"
#import "OAToken.h"


@class XAuthTwitterEngine;

@interface XAuthTwitterViewController : UIViewController <XAuthTwitterEngineDelegate> {
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UIButton *btnLogin;
	UIActivityIndicatorView	*spinner;
	
	XAuthTwitterEngine *twitterEngine;
}

@property (nonatomic, retain) UITextField *usernameTextField, *passwordTextField;
@property (nonatomic, retain) UIButton *sendTweetButton;
@property (nonatomic, retain) XAuthTwitterEngine *twitterEngine;

- (IBAction)xAuthAccessTokenRequestButtonTouchUpInside;
- (IBAction)sendTestTweetButtonTouchUpInside;
- (IBAction) cancel;
-(void) backPressed:(id)sender;

@end

