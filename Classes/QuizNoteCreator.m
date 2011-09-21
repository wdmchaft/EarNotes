//
//  QuizNoteCreator.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/25.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "QuizNoteCreator.h"
#import "SharedAppData.h"
#import "QuizObjectsArrays.h"
#import "NSMutableArray+Random.h"
#import "Utils.h"

struct Range {
	NSInteger min;
	NSInteger max;
};
typedef struct Range Range;

struct DataArraysChoiceProbability {
	Range mastered;
	Range known;
	Range learning;
	Range unknown;
};
typedef struct DataArraysChoiceProbability DataArraysChoiceProbability;

// Probabilidade das perguntas escolhidas consoante o modo de dificuldade
// E.g.: {0, 60} probabilidade de 61% de sair uma da fila 'mastered'
static const DataArraysChoiceProbability VeryEasyProbability = {
	{0, 60}, {61, 80}, {81, 100}, {0, 0}
};
static const DataArraysChoiceProbability EasyProbability = {
	{0, 30}, {31, 60}, {61, 100}, {0, 0}
};
static const DataArraysChoiceProbability NormalProbability = {
	{0, 10}, {11, 40}, {41, 100}, {0, 0}
};
static const DataArraysChoiceProbability HardProbability = {
	{0, 5}, {6, 20}, {21, 99}, {100, 100}
};
static const DataArraysChoiceProbability VeryHardProbability = {
	{0, 1}, {2, 10}, {11, 95}, {96, 100}
};
@implementation QuizNoteCreator

-(QuizSimpleQuestion *)nextSimpleQuestion {
	QuizSimpleQuestion *question = [[QuizSimpleQuestion alloc] init];
	
	if (arc4random() % 101 >= 50) {
		[question setQuestionType:QuestionTypeSingleSound];
	} else {
		[question setQuestionType:QuestionTypeSingleNotation];
	}
	
	DataArraysChoiceProbability choiceProbability;
	
	int userNotesLevel = [[[SharedAppData sharedInstance] currentUser] notesGuideModeLevel];
	
	int maxNumOfQuestions = [self getMaxNumberOfQuestionsForLevel: userNotesLevel];
	
	// A probabilidade da escolha das perguntas varia com o grau de dificuldade
	if (difficultyLevel == DifficultyLevelVeryEasy) {
		choiceProbability = VeryEasyProbability;
		
		answersNum = 2;
	} else if (difficultyLevel == DifficultyLevelEasy) {
		choiceProbability = EasyProbability;
		
		int randNum = ((NSInteger)arc4random() % (maxNumOfQuestions - 1)) + 2; 
		
		answersNum = randNum <= 3 ? 2 : randNum;
	} else if (difficultyLevel == DifficultyLevelNormal) {
		choiceProbability = NormalProbability;
		
		int randNum = ((NSInteger)arc4random() % (maxNumOfQuestions - 1)) + 2; 
		
		answersNum = randNum;
	} else if (difficultyLevel == DifficultyLevelHard) {
		choiceProbability = HardProbability;
		
		int randNum = ((NSInteger)arc4random() % (maxNumOfQuestions - 1)) + 2; 
		
		answersNum = randNum <= 4 ? 4 : randNum;
	} else if (difficultyLevel == DifficultyLevelVeryHard) {
		choiceProbability = VeryHardProbability;
		
		int randNum = ((NSInteger)arc4random() % (maxNumOfQuestions - 1)) + 2; 
		
		answersNum = randNum <= 6 ? 6 : randNum;
	}
	
	// Normalizar
	answersNum = answersNum > maxNumOfQuestions ? maxNumOfQuestions : answersNum;
	answersNum = answersNum < 2 ? 2 : answersNum;
	
	QuizObjectsArrays *dataArrays = [[[SharedAppData sharedInstance] currentUser] notesGuideMode];
	
	NSMutableArray *answersArray = [[NSMutableArray alloc] init];
	
	// Escolher X perguntas ao acaso segundo as probabilidades
	for (NSInteger i = 0; i < answersNum; i++) {
		NSInteger randNum = (NSInteger)arc4random() % 101;
		
		id obj = nil;
		
		// Escolher prioritariamente da fila 'mastered' 
		if ((randNum >= choiceProbability.mastered.min) && (randNum <= choiceProbability.mastered.max)) {
			obj = [dataArrays.mastered randomObjectExceptAnyObjectFrom:answersArray];
			
			// Se não houver nenhum objecto possivel de ser escolhido da fila 'mastered'
			if (obj == nil) {
				// Escolher da fila 'known'
				obj = [dataArrays.known randomObjectExceptAnyObjectFrom:answersArray];
				
				// Se não houver nenhum objecto possivel de ser escolhido da fila 'known'
				if (obj == nil) {
					// Escolher da fila 'learning'
					obj = [dataArrays.learning randomObjectExceptAnyObjectFrom:answersArray];
					
					// Se não houver nenhum objecto possivel de ser escolhido da fila 'learning'
					if (obj == nil) {
						// Escolher da fila 'unknown' o primeiro e passa-lo para a fila 'learning'
						obj = [dataArrays.unknown dequeue];
						
						[dataArrays.learning enqueue:obj];
					}
				}
			}
		}
		// Escolher prioritariamente da fila 'known' 
		else if ((randNum >= choiceProbability.known.min) && (randNum <= choiceProbability.known.max)) {
			obj = [dataArrays.known randomObjectExceptAnyObjectFrom:answersArray];
			
			// Se não houver nenhum objecto possivel de ser escolhido da fila 'known'
			if (obj == nil) {
				// Escolher da fila 'learning'
				obj = [dataArrays.learning randomObjectExceptAnyObjectFrom:answersArray];
				
				// Se não houver nenhum objecto possivel de ser escolhido da fila 'learning'
				if (obj == nil) {
					// Escolher da fila 'unknown' o primeiro e passa-lo para a fila 'learning'
					obj = [dataArrays.unknown dequeue];
					
					[dataArrays.learning enqueue:obj];
				}
			}
		}
		// Escolher prioritariamente da fila 'learning' 
		else if ((randNum >= choiceProbability.learning.min) && (randNum <= choiceProbability.learning.max)) {
			obj = [dataArrays.learning randomObjectExceptAnyObjectFrom:answersArray];
			
			// Se não houver nenhum objecto possivel de ser escolhido da fila 'learning'
			if (obj == nil) {
				// Escolher da fila 'unknown' o primeiro e passa-lo para a fila 'learning'
				obj = [dataArrays.unknown dequeue];
				
				[dataArrays.learning enqueue:obj];
			}
		} else {
			// Só retirar objectos da fila 'unknown' se não houver objectos suficientes na fila 'learning'
			if ([dataArrays.learning count] < [self getMaxNumberOfLearningObjectsForLevel:userNotesLevel]) {
				// Escolher da fila 'unknown'
				obj = [dataArrays.unknown dequeue];
			}
			
			// Garantir que é escolhido um
			if (obj == nil) {
				// Escolher da fila 'learning'
				obj = [dataArrays.learning randomObjectExceptAnyObjectFrom:answersArray];
				
				// Se não houver nenhum objecto possivel de ser escolhido da fila 'known'
				if (obj == nil) {
					// Escolher da fila 'known'
					obj = [dataArrays.known randomObjectExceptAnyObjectFrom:answersArray];
					
					// Se não houver nenhum objecto possivel de ser escolhido da fila 'learning'
					if (obj == nil) {
						// Escolher da fila 'mastered'
						obj = [dataArrays.mastered randomObjectExceptAnyObjectFrom:answersArray];
					}
				}
			} else {
				[dataArrays.learning enqueue:obj];
			}
		}
		
		if (obj != nil) {
			[answersArray addObject:obj];
		} else {
			// Escolher da fila 'unknown' o primeiro e passa-lo para a fila 'learning'
			obj = [dataArrays.unknown dequeue];
			
			[dataArrays.learning enqueue:obj];
			
			if (obj = nil) {
				NSLog(@"Não vá o diabo tecê-las!"); // LOL é basico
				[question release];
				[answersArray release];
				
				[Utils alert:[NSString stringWithString:@"Ooops...isto não devia acontecer.\rNão há objectos de estudo suficientes.\rPor favor, envie este erro para horntachi@gmail.com."]]; 
				
				return nil;
			}
		}
	}

	// Baralhar as perguntas
	[answersArray shuffle];
	
	id rightAnswer = nil;
	
	// Não escolher a mesma pergunta anterior
	if (lastQuizObject != nil) {
		// Guardar a resposta correcta para não voltar a fazer uma pergunta sobre o mesmo objecto
		if (lastQuestionType == [question questionType]) {
			// Apenas modificar a resposta correcta que o tipo for igual
			rightAnswer = [answersArray randomObjectExceptObject:lastQuizObject];
		} else {
			rightAnswer = [answersArray objectAtRandomIndex];
		}
		
	}
	
	// No caso impossivel de haver só um objecto
	if (rightAnswer == nil) {
		rightAnswer = [answersArray objectAtRandomIndex];
	}
	
	[question setRightAnswer:rightAnswer];
	[question setAnswers:answersArray];
	
	[answersArray release];
	
	questionCounter++;
	
	self.lastQuizObject = [question rightAnswer];
	lastQuestionType = [question questionType];
	
	return [question autorelease];
	
}

-(QuizMultipleQuestion *)nextMultipleQuestion {
	return nil;
}

@end
