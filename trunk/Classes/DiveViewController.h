//
//  DiveViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/9/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiveViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

	NSArray *arrTitles;
}

-(void) backPressed:(id)sender;

@end
