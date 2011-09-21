//
//  SettingsViewController.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/23.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
	UISwitch *switchAutoLogin;
	UITextField *textFieldUsername;
	UITextField *textFieldPassword;
	UILabel *labelGuitar;
}

@property(nonatomic, retain, readonly) UISwitch *switchAutoLogin;
@property(nonatomic, retain, readonly) UITextField *textFieldUsername;
@property(nonatomic, retain, readonly) UITextField *textFieldPassword;
@property(nonatomic, retain, readonly) UILabel *labelGuitar;

- (void)dialogOKCancelAction;

@end
