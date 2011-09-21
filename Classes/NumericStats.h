//
//  NumericStats.h
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/21.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumericStats : NSObject <NSCoding> {
	NSMutableDictionary *data;
	
	double applicationOverallTimeSpent;
	double guideModeTimeSpent;
	double customModeTimeSpent;
	
	double chordsGuideModeTimeSpent;
	double notesGuideModeTimeSpent;
	double strummingGuideModeTimeSpent;
	
	
	NSInteger guideModeNumberOfQuestionsAnswered;
	NSInteger customModeNumberOfQuestionsAnswered;
	
	NSInteger chordsGuideModeNumberOfQuestionsAnswered;
	NSInteger notesGuideModeNumberOfQuestionsAnswered;
	NSInteger strummingGuideModeNumberOfQuestionsAnswered;
	
	NSInteger chordsGuideModeNumberOfRightAnswers;
	NSInteger notesGuideModeNumberOfRightAnswers;
	NSInteger strummingGuideModeNumberOfRightAnswers;
	
	NSInteger chordsGuideModeNumberOfWrongAnswers;
	NSInteger notesGuideModeNumberOfWrongAnswers;
	NSInteger strummingGuideModeNumberOfWrongAnswers;
	
	NSInteger chordsGuideModeNumberOfRightAnswersInRowRecord;
	NSInteger notesGuideModeNumberOfRightAnswersInRowRecord;
	NSInteger strummingGuideModeNumberOfRightAnswersInRowRecord;
	
	NSInteger chordsGuideModeNumberOfWrongAnswersInRowRecord;
	NSInteger notesGuideModeNumberOfWrongAnswersInRowRecord;
	NSInteger strummingGuideModeNumberOfWrongAnswersInRowRecord;
	
	
}

@property(nonatomic, readonly) double applicationOverallTimeSpent;
@property(nonatomic, readonly) double guideModeTimeSpent;
@property(nonatomic, readonly) double customModeTimeSpent;

@property(nonatomic, readonly) double chordsGuideModeTimeSpent;
@property(nonatomic, readonly) double notesGuideModeTimeSpent;
@property(nonatomic, readonly) double strummingGuideModeTimeSpent;


@property(nonatomic, readonly) NSInteger guideModeNumberOfQuestionsAnswered;
@property(nonatomic, readonly) NSInteger customModeNumberOfQuestionsAnswered;

@property(nonatomic, readonly) NSInteger chordsGuideModeNumberOfQuestionsAnswered;
@property(nonatomic, readonly) NSInteger notesGuideModeNumberOfQuestionsAnswered;
@property(nonatomic, readonly) NSInteger strummingGuideModeNumberOfQuestionsAnswered;

@property(nonatomic, readonly) NSInteger chordsGuideModeNumberOfRightAnswers;
@property(nonatomic, readonly) NSInteger notesGuideModeNumberOfRightAnswers;
@property(nonatomic, readonly) NSInteger strummingGuideModeNumberOfRightAnswers;

@property(nonatomic, readonly) NSInteger chordsGuideModeNumberOfWrongAnswers;
@property(nonatomic, readonly) NSInteger notesGuideModeNumberOfWrongAnswers;
@property(nonatomic, readonly) NSInteger strummingGuideModeNumberOfWrongAnswers;

@property(nonatomic, assign) NSInteger chordsGuideModeNumberOfRightAnswersInRowRecord;
@property(nonatomic, assign) NSInteger notesGuideModeNumberOfRightAnswersInRowRecord;
@property(nonatomic, assign) NSInteger strummingGuideModeNumberOfRightAnswersInRowRecord;

@property(nonatomic, assign) NSInteger chordsGuideModeNumberOfWrongAnswersInRowRecord;
@property(nonatomic, assign) NSInteger notesGuideModeNumberOfWrongAnswersInRowRecord;
@property(nonatomic, assign) NSInteger strummingGuideModeNumberOfWrongAnswersInRowRecord;

-(void)addTimeToApplicationOverall: (double)time;
-(void)addTimeToGuideMode: (double)time;
-(void)addTimeToCustomMode: (double)time;

-(void)addTimeToChordsGuideMode: (double)time;
-(void)addTimeToNotesGuideMide: (double)time;
-(void)addTimeToStrummingGuideMide: (double)time;

-(void)incCustomModeNumberOfQuestionsAnswered;

-(void)incChordsGuideModeNumberOfRightAnswers;
-(void)incNotesGuideModeNumberOfRightAnswers;
-(void)incStrummingGuideModeNumberOfRightAnswers;

-(void)incChordsGuideModeNumberOfWrongAnswers;
-(void)incNotesGuideModeNumberOfWrongAnswers;
-(void)incStrummingGuideModeNumberOfWrongAnswers;

-(void)resetAll;

@end
