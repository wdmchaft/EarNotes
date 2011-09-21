//
//  CustomModeViewController.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/08.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomModeViewController : UITableViewController {
	NSInteger quizObjectType;
	NSMutableArray *objects;
	BOOL *isObjectSelected;
}

@property(nonatomic, retain) NSMutableArray *objects;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andQuizObjectType:(NSInteger)aQuizObjectType;

@end
