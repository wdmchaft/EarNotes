//
//  QuizCreator.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/29.
//  Copyright 2010 Unknow. All rights reserved.
//


#import "QuizCreator.h"

static const NSInteger MAX_NUM_OF_ANSWERS = 8;

@implementation QuizCreator

@synthesize questionCounter, difficultyLevel, answersNum, questionType, lastQuizObject;

-(id)init {
	if (self = [super init]) {
		questionCounter = 0;
		difficultyLevel = DifficultyLevelNormal;
		answersNum = 2;
		questionType = QuestionTypeSingleSound;
		lastQuizObject = nil;
	}
	
	return self;
}

-(QuizSimpleQuestion *)nextSimpleQuestion {
	return nil;
}

-(QuizMultipleQuestion *)nextMultipleQuestion {
	return nil;
}

-(void)incDifficultyLevel {
	if (difficultyLevel < NUM_DIFFICULTY_LEVELS - 1) {
		difficultyLevel++;
	}
}

-(void)decDifficultyLevel {
	if (difficultyLevel > 0) {
		difficultyLevel--;
	}
}

-(NSInteger)getMaxNumberOfQuestionsForLevel: (NSInteger)level {
	// TODO: Modificar consoante a implementação de GuideModeQuizViewController
	if (level >= 0 && level <= 5) {
		return 2;
	} else if (level >= 6 && level <= 10) {
		return 3;
	} else if (level >= 11 && level <= 15) {
		return 4;
	} else if (level >= 16 && level <= 20) {
		return 5;
	} else if (level >= 21 && level <= 25) {
		return 6;
	} else if (level >= 26 && level <= 30) {
		return 7;
	} else {
		return 8;
	} 
}

-(NSInteger)getMaxNumberOfLearningObjectsForLevel: (NSInteger)level {
	if (level >= 0 && level <= 3) {
		return 3;
	}else if (level >= 4 && level <= 7) {
		return 4;
	}else if (level >= 8 && level <= 10) {
		return 5;
	} else if (level >= 11 && level <= 15) {
		return 6;
	} else if (level >= 16 && level <= 20) {
		return 7;
	} else if (level >= 21 && level <= 25) {
		return 8;
	} else if (level >= 26 && level <= 30) {
		return 9;
	} else {
		return 10;
	} 
}

-(void)dealloc {
	[lastQuizObject release];
	[super dealloc];
}

@end

