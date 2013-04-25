//
//  FinishTripViewController.h
//  BMWE3
//
//  Created by Doug Strittmatter on 12/22/10.
//  Copyright 2010 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FinishTripViewController : UIViewController <UIPickerViewDelegate, UIAlertViewDelegate, UITextFieldDelegate> {

	IBOutlet UIPickerView *tripTypePickerView;
	IBOutlet UIButton *btnTripType;
	IBOutlet UITextField *txtFieldName;
	NSArray *arrTripTypes;
	NSMutableString *strTripType;
}

-(void) tripTypePressed:(id)sender;
-(void) backPressed:(id)sender;
-(void) endPressed:(id)sender;
-(void) txtFieldNamePressed:(id)sender;

@end
