//
//  LoginViewController.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/24.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UITableViewController <UITextFieldDelegate> {
	UITextField *textFieldUsername;
	UITextField *textFieldPassword;
}

@property(nonatomic, retain, readonly) UITextField *textFieldUsername;
@property(nonatomic, retain, readonly) UITextField *textFieldPassword;

@end
