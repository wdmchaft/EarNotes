//
//  UsersViewController.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/23.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"	

@interface UsersViewController : UITableViewController <CustomAlertViewDelegate, UIAlertViewDelegate> {
	NSInteger indexOfUser;
}

@end
