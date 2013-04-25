//
//  TripHistoryTableViewCell.h
//  BMWE3
//
//  Created by Doug Strittmatter on 1/10/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TripHistoryTableViewCell : UITableViewCell {

	IBOutlet UILabel *cellText;
	IBOutlet UILabel *lblTripName;
}

@property (nonatomic, retain) UILabel *lblTripName;

- (void)setLabelText:(NSString *)_text;
- (void)setTripNameText:(NSString *)_text;
- (void)setBarGraph:(NSArray*)arrSegments;

@end
