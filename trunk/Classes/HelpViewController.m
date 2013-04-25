//
//  HelpViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/22/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "HelpViewController.h"
#import "BMWE3AppDelegate.h"

@implementation HelpViewController

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[scrViewHelp setContentSize:CGSizeMake(320.0, 2828.0)];
	
}



-(void) backPressed:(id)sender
{
	
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	if ([applicationDelegate lastScreenType] == kStartTripScreen) {
		[applicationDelegate displayStartTripView];
	} else if ([applicationDelegate lastScreenType] == kParkScreen) {
		[applicationDelegate displayParkView];
	}
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
