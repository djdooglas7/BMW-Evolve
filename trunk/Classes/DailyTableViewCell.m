//
//  DailyTableViewCell.m
//  BMWE3
//
//  Created by Doug Strittmatter on 2/2/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "DailyTableViewCell.h"


@implementation DailyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)setLabelDate:(NSString *)_text {
	lblDate.text = _text;
	
}


- (void)setLabelMiles:(NSString *)_text {
	lblMiles.text = [NSString stringWithFormat:@"%@ mi", _text];
}


- (void)setBarGraph:(float)flMiles
{
	if (flMiles < 100) {
		imgBarGraph.frame = CGRectMake(imgBarGraph.frame.origin.x, imgBarGraph.frame.origin.y, flMiles*1.5, imgBarGraph.frame.size.height);
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
