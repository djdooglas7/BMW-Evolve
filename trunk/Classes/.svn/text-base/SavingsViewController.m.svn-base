//
//  SavingsViewController.m
//  BMWE3
//
//  Created by Doug Strittmatter on 12/16/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import "SavingsViewController.h"
#import "DataManager.h"
#import "Trip.h"
#import "TripSegment.h"

@implementation SavingsViewController

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
	
	arrTrips = [[NSArray alloc] initWithArray:[[DataManager sharedManager] retrieveTripItems]];
	float flTotalMiles = 0.0;
	float flSavingsPerGallon = 0.0;
	
	for (Trip *trip in arrTrips)
	{
		NSSet *setSegment = trip.tripSegment;
		for (TripSegment *seg in setSegment)
		{
			flTotalMiles += [seg.numDistance floatValue];
		}
	}
	
	lblTotalMiles.text = [NSString stringWithFormat:@"%.1f miles", flTotalMiles];
	lblSavings.text = [NSString stringWithFormat:@"$%.2f in savings", ((flTotalMiles/25) * 2.5) - ((flTotalMiles/25)*(.0987*6.6))];
	lblGallons.text = [NSString stringWithFormat:@"%.1f gallons of gas", (flTotalMiles/25)];
	//lblSavingsPerGallon.text = [NSString stringWithFormat:@"%.1f / gallon", flSavingsPerGallon];
	lblSavingsPerGallon.text = [NSString stringWithFormat:@"$2.50 / gallon"];
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
	[arrTrips release];
    [super dealloc];
}


@end
