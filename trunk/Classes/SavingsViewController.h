//
//  SavingsViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/16/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavingsViewController : UIViewController {

	IBOutlet UILabel *lblTotalMiles;
	IBOutlet UILabel *lblSavings;
	IBOutlet UILabel *lblGallons;
	IBOutlet UILabel *lblSavingsPerGallon;
	
	NSArray *arrTrips;
}

-(void) backPressed:(id)sender;
-(void) tipsPressed:(id)sender;

@end
