//
//  CMQuizViewController.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/09.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomQuizCreator.h"
#import "Timer.h"

@interface CMQuizViewController : UIViewController {
	CustomQuizCreator *quizCreator;
	
	QuizSimpleQuestion *currentQuestion;
	UIButton *buttonQuestion;
	NSMutableArray *buttonsArray;
	
	Timer *timer;
	
	Timer *buttonTimer;
	id lastButton;
	
	BOOL acceptEvents;
}

@property(nonatomic, retain) CustomQuizCreator *quizCreator;

@property(nonatomic, retain) QuizSimpleQuestion *currentQuestion;
@property(nonatomic, retain) UIButton *buttonQuestion;
@property(nonatomic, retain) NSMutableArray *buttonsArray;

@property(nonatomic, retain) Timer *timer;
@property(nonatomic, retain) Timer *buttonTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
 andCustomQuizCreator:(id)aQuizCreator;

-(void)nextQuestion: (NSTimer *)theTimer;

-(void)playSound: (NSTimer *)theTimer;

-(void)markButtonWithRightSymbol: (UIButton *)button;
-(void)markButtonWithWrongSymbol: (UIButton *)button;

-(UIView *)createStrummingQuizView: (QuizSimpleQuestion *)question;
-(NSArray*)createStrummingButtonsFrames: (float)thePadding;
-(IBAction)strummingButtonPressed: (id)sender;
-(IBAction)strummingOkButtonPressed: (id)sender;

-(UIView *)createQuizView: (QuizSimpleQuestion *)question;
-(NSArray*)createButtonsFrames: (NSInteger)numOfButtons padding:(float)thePadding;

@end
