//
//  BarGraphView.m
//  BMWE3
//
//  Created by Doug Strittmatter on 1/11/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "BarGraphView.h"
#import "TripSegment.h"

@implementation BarGraphView


- (id)initWithFrame:(CGRect)frame
		   andArray:(NSArray*)arrSegments
{
    
    self = [super initWithFrame:frame];
    if (self) {
		
		arrTripSegments = [[NSArray alloc] initWithArray:arrSegments];
		/*for (TripSegment *seg in arrTripSegments) 
		{
			NSLog(@"trip %@", seg.trip);
			NSLog(@"dateStart %@", seg.dateStart);
			NSLog(@"dateEnd %@", seg.dateEnd);
			NSLog(@"strType %@", seg.strType);
		}*/
		
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGContextBeginPath(context);
	
	TripSegment *seg = (TripSegment *)[arrTripSegments objectAtIndex:0];
	NSDate *startDate = (NSDate*)seg.dateStart;
	
	seg = (TripSegment *)[arrTripSegments objectAtIndex:[arrTripSegments count]-1];
	NSDate *endDate = (NSDate*)seg.dateEnd;
	
	NSTimeInterval intervalTotalDiff = [endDate timeIntervalSinceDate:startDate];
	//NSLog(@"intervalTotalDiff %@", [[NSString alloc] initWithFormat:@"%0.0f",intervalTotalDiff]);
	float flTotalDiff = (float)intervalTotalDiff;
	float flTotalBarDist = 0.0;
	
	for (int i=0; i<[arrTripSegments count]; i++) 
	{
		TripSegment *seg = (TripSegment*)[arrTripSegments objectAtIndex:i];
		startDate = (NSDate*)seg.dateStart;
		endDate = (NSDate*)seg.dateEnd;
		
		NSTimeInterval intervalDiff = [endDate timeIntervalSinceDate:startDate];
		float flDiff = (float)intervalDiff;
		
		float flBarDist = (float)((flDiff/flTotalDiff) * 200);
	
		if ([seg.strType isEqualToString:@"Driving"]) {
			CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
		} else if ([seg.strType isEqualToString:@"Parked"]) {
			CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
		} else if ([seg.strType isEqualToString:@"Station"]) {
			CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
		} else if ([seg.strType isEqualToString:@"Opprotunity"]) {
			CGContextSetRGBFillColor(context, 0.7, 0.7, 1.0, 1.0);
		}
		
		CGContextFillRect(context, CGRectMake(flTotalBarDist, 0.0, flBarDist, 20.0));
		flTotalBarDist += flBarDist;
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
