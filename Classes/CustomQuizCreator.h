//
//  CustomQuizCreator.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/09.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizSimpleQuestion.h"
#import "QuizMultipleQuestion.h"
#import "QuizObject.h"

@interface CustomQuizCreator : NSObject {
	NSMutableArray *array;
	
	QuizObject *lastQuizObject;
}

@property(nonatomic, retain) NSMutableArray *array;
@property(nonatomic, retain) QuizObject *lastQuizObject;

-(id)initWithArray: (NSMutableArray *)theArray;


-(QuizSimpleQuestion *)nextSimpleQuestion;
-(QuizMultipleQuestion *)nextMultipleQuestion;


@end
