//
//  TipDetailViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 2/15/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "TipDetailViewController.h"
#import "BMWE3AppDelegate.h" 

@implementation TipDetailViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	
	if ([applicationDelegate lastScreenType] == kTipsScreen) {
		[applicationDelegate displayTipsView];
	} else if ([applicationDelegate lastScreenType] == kStartTripScreen) {
		[applicationDelegate displayStartTripView];
	} else if ([applicationDelegate lastScreenType] == kTripResultsScreen) {
		[applicationDelegate displayTripResultsView];
	}
	
}


-(void) tipsPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://forum.BMWActivateTheFuture.com/tips"]];
}


-(void) setText:(NSString*)strText
	   andBadge:(BOOL)blnBadge
		andType:(NSString*)strType
{
	lblTip.text = strText;
	lblTitle.text = [NSString stringWithFormat:@"%@ TIP", [strType uppercaseString]];
	imgTip.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Detail.png", strType]];
	
	CGSize maximumSize = CGSizeMake(288, 9999);
    UIFont *tipFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    CGSize tipStringSize = [strText sizeWithFont:tipFont 
								   constrainedToSize:maximumSize 
									   lineBreakMode:lblTip.lineBreakMode];
	
    CGRect tipFrame = CGRectMake(16, 126, 288, tipStringSize.height);
	
    lblTip.frame = tipFrame;
	imgBadge.hidden = blnBadge;
	lblPioneer.hidden = blnBadge;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
