//
//  TipDetailViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 2/15/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TipDetailViewController : UIViewController {

	IBOutlet UILabel *lblTip;
	IBOutlet UILabel *lblPioneer;
	IBOutlet UILabel *lblTitle;
	IBOutlet UIImageView *imgBadge;
	IBOutlet UIImageView *imgTip;
}

-(void) backPressed:(id)sender;
-(void) tipsPressed:(id)sender;
-(void) setText:(NSString*)strText
	   andBadge:(BOOL)blnBadge
		andType:(NSString*)strType;

@end
