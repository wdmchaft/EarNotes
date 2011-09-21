//
//  MainMenuViewController.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/07.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@class Timer;

@interface MainMenuViewController : UITableViewController <CustomAlertViewDelegate, UIAlertViewDelegate> {
	UIBarButtonItem *leftBarButton;
	UIBarButtonItem *rightBarButton;
	
	UIButton *btnGuideModeChords;
	UIButton *btnGuideModeStrumming;
	UIButton *btnGuideModeNotes;
	UIButton *btnCustomModeChords;
	UIButton *btnCustomModeStrumming;
	UIButton *btnCustomModeNotes;
	UIButton *btnStats;
	UIButton *btnTrophies;
	
	UIButton *btnChordsLevel;
	UIButton *btnNotesLevel;
	UIButton *btnStrummingLevel;
	
	BOOL isUserLoggedIn;
	
	Timer *timer;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *leftBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *rightBarButton;

@property (nonatomic, retain) UIButton *btnGuideModeChords;
@property (nonatomic, retain) UIButton *btnGuideModeStrumming;
@property (nonatomic, retain) UIButton *btnGuideModeNotes;
@property (nonatomic, retain) UIButton *btnCustomModeChords;
@property (nonatomic, retain) UIButton *btnCustomModeStrumming;
@property (nonatomic, retain) UIButton *btnCustomModeNotes;
@property (nonatomic, retain) UIButton *btnStats;
@property (nonatomic, retain) UIButton *btnTrophies;

@property (nonatomic, retain) UIButton *btnChordsLevel;
@property (nonatomic, retain) UIButton *btnNotesLevel;
@property (nonatomic, retain) UIButton *btnStrummingLevel;

@property (nonatomic, retain) Timer *timer;

-(IBAction)barButtonPressed: (id)sender;

-(IBAction)buttonPressed: (id)sender;

-(void)setupNavigationBar;
//-(void)setupView;

-(void)enableAll;
-(void)disableAll;

-(IBAction)showCustomAlert;

@end
