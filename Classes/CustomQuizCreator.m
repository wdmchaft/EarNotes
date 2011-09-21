//
//  CustomQuizCreator.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/09.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "CustomQuizCreator.h"
#import "NSMutableArray+Random.h"

@implementation CustomQuizCreator

@synthesize array, lastQuizObject;

-(id)initWithArray: (NSMutableArray *)theArray {
	if (self = [super init]) {
		self.array = theArray;
	}
	
	return self;
}

-(QuizSimpleQuestion *)nextSimpleQuestion {
	QuizSimpleQuestion *question = [[QuizSimpleQuestion alloc] init];
	
	NSInteger answersNum = 2;
	
	/* TODO: Manter comentado até o quiz de single notation estar implementado
	 if (arc4random() % 2 == 0) {
	 [quizCreator setQuestionType:QuestionTypeSingleSound];
	 } else {
	 [quizCreator setQuestionType:QuestionTypeSingleNotation];
	 }
	 */
	
	question.questionType = QuestionTypeSingleSound;
	
	// Verificar se ha pelo menos 2 objectos
	if ([array count] < 2) {
		[question release];
		return nil;
	}
	
	// Calcular o numero de respostas
	answersNum = ((NSInteger)arc4random() % ([array count] - 1)) + 2; 
	
	NSMutableArray *answersArray = [[NSMutableArray alloc] init];
	
	// Escolher X perguntas ao acaso segundo as probabilidades
	for (NSInteger i = 0; i < answersNum; i++) {
		id obj = nil;
		
		obj = [array randomObjectExceptAnyObjectFrom:answersArray];
		[answersArray addObject:obj];
	}
	
	// Baralhar as perguntas
	[answersArray shuffle];
	
	id rightAnswer = nil;
	
	// Não escolher a mesma pergunta anterior
	if (lastQuizObject != nil) {
		rightAnswer = [answersArray randomObjectExceptObject:lastQuizObject];
	}
	
	// No caso impossivel de haver só um objecto
	if (rightAnswer == nil) {
		rightAnswer = [answersArray objectAtRandomIndex];
	}
	
	[question setRightAnswer:rightAnswer];
	[question setAnswers:answersArray];
	
	[answersArray release];
	
	// Guardar a resposta correcta para não voltar a fazer uma pergunta sobre o mesmo objecto
	self.lastQuizObject = [question rightAnswer];
	
	return [question autorelease];
}

-(QuizMultipleQuestion *)nextMultipleQuestion {
	return nil;
}

-(void)dealloc {
	[array release];
	[lastQuizObject release];
	
	[super dealloc];
}

@end
