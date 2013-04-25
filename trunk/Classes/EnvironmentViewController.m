//
//  EnvironmentViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/22/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "EnvironmentViewController.h"
#import "DataManager.h"

@implementation EnvironmentViewController

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
	
	NSArray *arrTrips = [[NSArray alloc] initWithArray:[[DataManager sharedManager] retrieveTripItems]];
	float flTotalMiles = 0.0;
	
	for (Trip *trip in arrTrips)
	{
		NSSet *setSegment = trip.tripSegment;
		for (TripSegment *seg in setSegment)
		{
			flTotalMiles += [seg.numDistance floatValue];
		}
	}
	
	lblMiles.text = [NSString stringWithFormat:@"%.1f miles", flTotalMiles];
	lblCO2.text = [NSString stringWithFormat:@"%.1f lbs. of vehicle", (flTotalMiles * .78)];
	lblPlasma.text = [NSString stringWithFormat:@"%.1f hours", ((flTotalMiles/25)*99.41)];
}



-(void) backPressed:(id)sender
{
	id applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayDiveView];
}


-(void) tipsPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.BMWActivateTheFuture.com/"]];
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
