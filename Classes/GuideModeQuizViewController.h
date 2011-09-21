//
//  GuideModeQuizViewController.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/24.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizCreator.h"
#import "QuizSimpleQuestion.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAAnimation.h>
#import "Timer.h"

@interface GuideModeQuizViewController : UIViewController {
	id quizCreator;
	QuizSimpleQuestion *currentQuestion;
	UIView *currentQuestionView;
	UIButton *buttonQuestion;
	NSMutableArray *buttonsArray;
	UILabel *lblCountdown;
	
	NSInteger rightAnswersInARow;
	NSInteger wrongAnswersInARow;
	
	CGRect defFrame;
	
	float quizTime;
	
	float timeLeft;
	
	float timeLeftBeforePause;
	
	BOOL isCurrentQuestionNew;
	
	BOOL isCountdownPaused;
	
	CALayer *layerForAnimation;
	
	UIImageView *star1;
	UIImageView *star2;
	UIImageView *star3;
	UIImageView *star4;
	UIImageView *star5;
	UILabel *lblMultiplier;
	float multiplier;
	
	Timer *timer;
	Timer *buttonTimer;
	id lastButton;
	
	BOOL acceptEvents;
}

@property(nonatomic, retain) id quizCreator;
@property(nonatomic, retain) QuizSimpleQuestion *currentQuestion;
@property(nonatomic, retain) UIView *currentQuestionView;
@property(nonatomic, retain) UIButton *buttonQuestion;
@property(nonatomic, retain) NSMutableArray *buttonsArray;
@property(nonatomic, retain) UILabel *lblCountdown;

@property(nonatomic, retain) UIImageView *star1;
@property(nonatomic, retain) UIImageView *star2;
@property(nonatomic, retain) UIImageView *star3;
@property(nonatomic, retain) UIImageView *star4;
@property(nonatomic, retain) UIImageView *star5;
@property(nonatomic, retain) UILabel *lblMultiplier;

@property(nonatomic, assign) NSInteger rightAnswersInARow;
@property(nonatomic, assign) NSInteger wrongAnswersInARow;

@property(nonatomic, retain) Timer *timer;
@property(nonatomic, retain) Timer *buttonTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	   andQuizCreator:(id)aQuizCreator;

-(UIView *)createStrummingQuizView: (QuizSimpleQuestion *)question;
-(NSArray*)createStrummingButtonsFrames: (float)thePadding;
-(IBAction)strummingButtonPressed: (id)sender;
-(IBAction)strummingOkButtonPressed: (id)sender;

-(void)refreshTitle;

-(UIView *)createQuizView: (QuizSimpleQuestion *)question;
-(NSArray*)createButtonsFrames: (NSInteger)numOfButtons padding:(float)thePadding;

-(UIView *)createNewObjectView: (QuizObject *)object;

-(void)processAnswer: (BOOL)wasAnswersRight;

// Animation functions
-(void)showNewTrophies: (NSTimer *)theTimer;
-(void)showNewTrophy: (NSTimer *)theTimer;
-(void)showPointsGained: (NSInteger)points duration:(NSTimeInterval)seconds;

-(void)addHorizontalEmptyStarsToView: (UIView *)theView;
-(void)addVerticalEmptyStarsToView: (UIView *)theView;

-(void)playQuestionSoundAndStartCountdown;

-(void)markButtonWithRightSymbol: (UIButton *)button;
-(void)markButtonWithWrongSymbol: (UIButton *)button;

-(void)nextQuestion;

-(void)countdownTicker;

-(void)startCountdown;
-(void)pauseCountdown;
-(void)unpauseCountdown;
-(void)stopCountdown;

-(void)enableAnswers;
-(void)disableAnswers;

- (void)spinLayer:(CALayer *)inLayer 
		 duration:(CFTimeInterval)inDuration
		direction:(int)direction;

-(void)scaleUpAndDown:(CALayer *)inLayer 
			 duration:(CFTimeInterval)inDuration
				scale:(float)factor;

@end
