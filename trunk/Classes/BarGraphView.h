//
//  BarGraphView.h
//  BMWE3
//
//  Created by Doug Strittmatter on 1/11/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BarGraphView : UIView {

	NSArray *arrTripSegments;
}

- (id)initWithFrame:(CGRect)frame
			 andArray:(NSArray*)arrSegments;

@end
