//
//  TripHistoryTableViewCell.m
//  BMWE3
//
//  Created by Doug Strittmatter on 1/10/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "TripHistoryTableViewCell.h"
#import "BarGraphView.h"


@implementation TripHistoryTableViewCell

@synthesize lblTripName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


/*- (void)willTransitionToState:(UITableViewCellStateMask)state {
	
    [super willTransitionToState:state];
	
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
		
        for (UIView *subview in self.subviews) {
			
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {             
				
                subview.hidden = YES;
                subview.alpha = 0.0;
            }
        }
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
	
    [super willTransitionToState:state];
	
    if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask) {
        for (UIView *subview in self.subviews) {
			
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
				
                UIView *deleteButtonView = (UIButton *)[subview.subviews objectAtIndex:0];
                CGRect f = deleteButtonView.frame;
                f.origin.x = -250;
				//f.size.width = 29.0;
				//f.size.height = 29.0;
                deleteButtonView.frame = f;
				
				//UIImageView *imgDelete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_delete.png"]];
				//[subview addSubview:imgDelete];
				//deleteButtonView.imageView.image = [UIImage imageNamed:@"button_delete.png"];
				
                subview.hidden = NO;
				
                [UIView beginAnimations:@"anim" context:nil];
                subview.alpha = 1.0;
                [UIView commitAnimations];
            }
        }
    }
}*/


- (void)setLabelText:(NSString *)_text {
	cellText.text = _text;
	
}


- (void)setTripNameText:(NSString *)_text {
	lblTripName.text = _text;
}


- (void)setBarGraph:(NSArray*)arrSegments
{
	BarGraphView *barView = [[BarGraphView alloc] initWithFrame:CGRectMake(100, 20, 200, 12)
														 andArray:arrSegments];
	[self addSubview:barView];
}


- (void)dealloc {
    [super dealloc];
}


@end
