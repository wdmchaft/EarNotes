//
//  QuizSimpleQuestion.h
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/20.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizObject.h"

typedef enum QuestionType {
	QuestionTypeSingleSound = 0,
	QuestionTypeMultiSound,
	QuestionTypeSingleNotation,
	QuestionTypeMultiNotation,
}QuestionType;

@interface QuizSimpleQuestion : NSObject {
	QuestionType questionType;
	QuizObject *rightAnswer;
	NSMutableArray *answers;
}

@property (nonatomic) QuestionType questionType;
@property (nonatomic, retain) QuizObject *rightAnswer;
@property (nonatomic, retain) NSMutableArray *answers;

-(id)init;
-(id)initWithQuestionType: (QuestionType)theQuestionType;
-(id)initWithQuestionType: (QuestionType)theQuestionType
		 andRightAnswer: (QuizObject *)theRightAnswer 
			   andAnswers: (NSMutableArray *)theAnswers;

-(void)addAnswer: (QuizObject *)anAnswer;
-(BOOL)isAnswerRight: (QuizObject *)anAnswer;
-(BOOL)isWrongAnswer: (QuizObject *)anAnswer;

-(NSInteger)numOfAnswers;

-(NSInteger)indexOfRightAnswer;

-(void)unloadAllResources;

+(QuizSimpleQuestion *)quizQuestionWithQuestionType: (QuestionType)theQuestionType
							 andRightAnswer: (QuizObject *)theRightAnswer 
								   andAnswers: (NSMutableArray *)theAnswers;

@end
