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

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	   andQuizCreator:(id)aQuizCreator;

-(UIView *)createTwoButtonsView: (QuizSimpleQuestion *)question;
-(UIView *)createThreeButtonsView: (QuizSimpleQuestion *)question;
-(UIView *)createFourButtonsView: (QuizSimpleQuestion *)question;
-(UIView *)createQuizView: (QuizSimpleQuestion *)question;
-(UIView *)createSixButtonsView: (QuizSimpleQuestion *)question;
-(UIView *)createSevenButtonsView: (QuizSimpleQuestion *)question;
-(UIView *)createEightButtonsView: (QuizSimpleQuestion *)question;
-(UIView *)createNewObjectView: (QuizObject *)object;

-(NSArray*)createButtonsFrames: (NSInteger)numOfButtons padding:(float)thePadding;

-(void)addHorizontalEmptyStarsToView: (UIView *)theView;
-(void)addVerticalEmptyStarsToView: (UIView *)theView;

-(void)playQuestionSoundAndStartCountdown;

-(void)markButtonWithRightSymbol: (UIButton *)button;
-(void)markButtonWithWrongSymbol: (UIButton *)button;

-(void)nextQuestion;

-(void)countdownTicker;
-(void)updateInternalData: (BOOL)wasAnswersRight;

-(void)pauseApp;
-(void)unpauseApp;

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
