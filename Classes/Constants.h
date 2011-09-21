//
//  Constants.h
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/21.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DATA_ID {
	// Naturals
	chordAMaj, chordBMaj, chordCMaj, chordDMaj, chordEMaj, chordFMaj, chordGMaj,
	chordAMin, chordBMin, chordCMin, chordDMin, chordEMin, chordFMin, chordGMin,
	chordAAug, chordBAug, chordCAug, chordDAug, chordEAug, chordFAug, chordGAug,
	chordADim, chordBDim, chordCDim, chordDDim, chordEDim, chordFDim, chordGDim,
	
	// Sharps
	chordASharpMaj, chordCSharpMaj, chordDSharpMaj, chordFSharpMaj, chordGSharpMaj,
	chordASharpMin, chordCSharpMin, chordDSharpMin, chordFSharpMin, chordGSharpMin,
	chordASharpAug, chordCSharpAug, chordDSharpAug, chordFSharpAug, chordGSharpAug,
	chordASharpDim, chordCSharpDim, chordDSharpDim, chordFSharpDim, chordGSharpDim
	
	// TODO: Flats
}DataId;

typedef enum QUESTION_TYPE {
	GUESS_SOUND_FROM_TEXT = 0x00000001, 
	GUESS_TEXT_FROM_SOUND = 0x00000002, 
	GUESS_SOUND_FROM_SOUND = 0x00000004, 
	GUESS_TEXT_FROM_TEXT = 0x00000008
}QQuestionType;

typedef enum QUIZ_TYPE {
	QUIZ_TYPE_CHORDS,
	QUIZ_TYPE_NOTES,
	QUIZ_TYPE_STRUMMING
}QuizType;

extern NSString * const MyFirstConstant;

@interface Constants : NSObject {

}

@end
