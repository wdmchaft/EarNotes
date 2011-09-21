//
//  QuizCreator.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/29.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizSimpleQuestion.h"
#import "QuizMultipleQuestion.h"
#import "SharedAppData.h"

typedef enum DIFFICULTY_LEVEL {
	DifficultyLevelVeryEasy = 0,
	DifficultyLevelEasy,
	DifficultyLevelNormal,
	DifficultyLevelHard,
	DifficultyLevelVeryHard,
	NUM_DIFFICULTY_LEVELS
}DifficultyLevel;

@interface QuizCreator : NSObject
{
	NSInteger questionCounter;
	NSInteger difficultyLevel;	// Quanto menor, mais fácil
	NSInteger answersNum;
	QuestionType questionType;
	
	QuizObject *lastQuizObject;
	QuestionType lastQuestionType;
}

@property(nonatomic, retain) QuizObject *lastQuizObject;
@property(nonatomic, readonly, assign) NSInteger questionCounter;
@property(nonatomic, assign) NSInteger difficultyLevel;
@property(nonatomic, readonly, assign) NSInteger answersNum;
@property(nonatomic, assign) QuestionType questionType;

-(QuizSimpleQuestion *)nextSimpleQuestion;
-(QuizMultipleQuestion *)nextMultipleQuestion;

-(void)incDifficultyLevel;
-(void)decDifficultyLevel;

-(NSInteger)getMaxNumberOfQuestionsForLevel: (NSInteger)level;
-(NSInteger)getMaxNumberOfLearningObjectsForLevel: (NSInteger)level;

@end

