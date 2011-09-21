//
//  QuizSimpleQuestion.m
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/20.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "QuizSimpleQuestion.h"

@implementation QuizSimpleQuestion

@synthesize questionType, rightAnswer, answers;

-(id)init {
	return [self initWithQuestionType:QuestionTypeSingleSound 
				 andRightAnswer:nil
						   andAnswers:nil];
}

-(id)initWithQuestionType: (QuestionType)theQuestionType {
	return [self initWithQuestionType:theQuestionType 
				 andRightAnswer:nil
						   andAnswers:nil];
}

-(id)initWithQuestionType: (QuestionType)theQuestionType
	 andRightAnswer: (QuizObject *)theRightAnswer 
			   andAnswers: (NSMutableArray *)theAnswers {
	if (self = [super init]) {
		self.questionType = theQuestionType;
		self.rightAnswer = theRightAnswer;
		self.answers = theAnswers;
	}
	
	return self;
}

-(void)addAnswer: (QuizObject *)anAnswer {
	if (self.answers == nil) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		
		self.answers = array;
		
		[array release];
	}
	
	[answers addObject:anAnswer];
}

-(BOOL)isAnswerRight: (QuizObject *)anAnswer {
	if ([anAnswer isEqual:rightAnswer]) {
		return YES;
	} else {
		return NO;
	}
}

-(BOOL)isWrongAnswer: (QuizObject *)anAnswer {
	if ([anAnswer isEqual:rightAnswer]) {
		return YES;
	}
	
	for (QuizObject *q in answers) {
		if ([anAnswer isEqual:q] || [[anAnswer objectId] isEqual:[q objectId]]) {
			return YES;
		}
	}
	
	return NO;
}

-(NSInteger)indexOfRightAnswer {
	for (int i = 0; i < [answers count]; i++) {
		if ([self isAnswerRight:[answers objectAtIndex:i]]) {
			return i;
		}
	}
	
	NSLog(@"Nunca devia acontecer!!!");
	
	return 0;
}

-(NSInteger)numOfAnswers {
	if (answers != nil) {
		return [answers count];
	} else {
		return 0;
	}
}

-(void)unloadAllResources {
	for (id obj in answers) {
		[obj unloadImageAndSound];
	}
}

-(void) dealloc {
	[rightAnswer release];
	[answers release];
	[super dealloc];
}

+(QuizSimpleQuestion *)quizQuestionWithQuestionType: (QuestionType)theQuestionType
							   andRightAnswer: (QuizObject *)theRightAnswer 
										 andAnswers: (NSMutableArray *)theAnswers {
	QuizSimpleQuestion *q = [[QuizSimpleQuestion alloc] initWithQuestionType:theQuestionType 
														andRightAnswer:theRightAnswer 
																  andAnswers:theAnswers];
	return [q autorelease];
}

@end
