//
//  NumericStats.m
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/21.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "NumericStats.h"

@implementation NumericStats

@synthesize applicationOverallTimeSpent, guideModeTimeSpent, customModeTimeSpent;
@synthesize chordsGuideModeTimeSpent, notesGuideModeTimeSpent, strummingGuideModeTimeSpent;
@synthesize guideModeNumberOfQuestionsAnswered, customModeNumberOfQuestionsAnswered;
@synthesize chordsGuideModeNumberOfQuestionsAnswered, notesGuideModeNumberOfQuestionsAnswered, strummingGuideModeNumberOfQuestionsAnswered;
@synthesize chordsGuideModeNumberOfRightAnswers, notesGuideModeNumberOfRightAnswers, strummingGuideModeNumberOfRightAnswers;
@synthesize chordsGuideModeNumberOfWrongAnswers, notesGuideModeNumberOfWrongAnswers, strummingGuideModeNumberOfWrongAnswers;
@synthesize chordsGuideModeNumberOfRightAnswersInRowRecord, notesGuideModeNumberOfRightAnswersInRowRecord, strummingGuideModeNumberOfRightAnswersInRowRecord;
@synthesize chordsGuideModeNumberOfWrongAnswersInRowRecord, notesGuideModeNumberOfWrongAnswersInRowRecord, strummingGuideModeNumberOfWrongAnswersInRowRecord; 

-(id)init {
	if (self = [super init]) {
		applicationOverallTimeSpent = 0.0f;
		guideModeTimeSpent = 0.0f;
		customModeTimeSpent = 0.0f;
		chordsGuideModeTimeSpent = 0.0f;
		notesGuideModeTimeSpent = 0.0f;
		strummingGuideModeTimeSpent = 0.0f;
		
		guideModeNumberOfQuestionsAnswered = 0;
		customModeNumberOfQuestionsAnswered = 0;
		
		chordsGuideModeNumberOfQuestionsAnswered = 0;
		notesGuideModeNumberOfQuestionsAnswered = 0;
		strummingGuideModeNumberOfQuestionsAnswered = 0;
		
		chordsGuideModeNumberOfRightAnswers = 0;
		notesGuideModeNumberOfRightAnswers = 0;
		strummingGuideModeNumberOfRightAnswers = 0;
		
		chordsGuideModeNumberOfWrongAnswers = 0;
		notesGuideModeNumberOfWrongAnswers = 0;
		strummingGuideModeNumberOfWrongAnswers = 0;
		
		chordsGuideModeNumberOfRightAnswersInRowRecord = 0;
		notesGuideModeNumberOfRightAnswersInRowRecord = 0;
		strummingGuideModeNumberOfRightAnswersInRowRecord = 0;
		
		chordsGuideModeNumberOfWrongAnswersInRowRecord = 0;
		notesGuideModeNumberOfWrongAnswersInRowRecord = 0;
		strummingGuideModeNumberOfWrongAnswersInRowRecord = 0; 		
	}
	
	return self;
}

-(id)initWithCoder: (NSCoder *)coder {
	applicationOverallTimeSpent = [coder decodeDoubleForKey:@"applicationOverallTimeSpent"];
	guideModeTimeSpent = [coder decodeDoubleForKey:@"guideModeTimeSpent"];
	customModeTimeSpent = [coder decodeDoubleForKey:@"customModeTimeSpent"];
	
	chordsGuideModeTimeSpent = [coder decodeDoubleForKey:@"chordsGuideModeTimeSpent"];
	notesGuideModeTimeSpent = [coder decodeDoubleForKey:@"notesGuideModeTimeSpent"];
	strummingGuideModeTimeSpent = [coder decodeDoubleForKey:@"strummingGuideModeTimeSpent"];
	
	guideModeNumberOfQuestionsAnswered = [coder decodeIntForKey:@"guideModeNumberOfQuestionsAnswered"];
	customModeNumberOfQuestionsAnswered = [coder decodeIntForKey:@"customModeNumberOfQuestionsAnswered"];
	
	chordsGuideModeNumberOfQuestionsAnswered = [coder decodeIntForKey:@"chordsGuideModeNumberOfQuestionsAnswered"];
	notesGuideModeNumberOfQuestionsAnswered = [coder decodeIntForKey:@"notesGuideModeNumberOfQuestionsAnswered"];
	strummingGuideModeNumberOfQuestionsAnswered = [coder decodeIntForKey:@"strummingGuideModeNumberOfQuestionsAnswered"];
	
	chordsGuideModeNumberOfRightAnswers = [coder decodeIntForKey:@"chordsGuideModeNumberOfRightAnswers"];
	notesGuideModeNumberOfRightAnswers = [coder decodeIntForKey:@"notesGuideModeNumberOfRightAnswers"];
	strummingGuideModeNumberOfRightAnswers = [coder decodeIntForKey:@"strummingGuideModeNumberOfRightAnswers"];
	
	chordsGuideModeNumberOfWrongAnswers = [coder decodeIntForKey:@"chordsGuideModeNumberOfWrongAnswers"];
	notesGuideModeNumberOfWrongAnswers = [coder decodeIntForKey:@"notesGuideModeNumberOfWrongAnswers"];
	strummingGuideModeNumberOfWrongAnswers = [coder decodeIntForKey:@"strummingGuideModeNumberOfWrongAnswers"];
	
	chordsGuideModeNumberOfRightAnswersInRowRecord = [coder decodeIntForKey:@"chordsGuideModeNumberOfRightAnswersInRowRecord"];
	notesGuideModeNumberOfRightAnswersInRowRecord = [coder decodeIntForKey:@"notesGuideModeNumberOfRightAnswersInRowRecord"];
	strummingGuideModeNumberOfRightAnswersInRowRecord = [coder decodeIntForKey:@"strummingGuideModeNumberOfRightAnswersInRowRecord"];
	chordsGuideModeNumberOfWrongAnswersInRowRecord = [coder decodeIntForKey:@"chordsGuideModeNumberOfWrongAnswersInRowRecord"];
	notesGuideModeNumberOfWrongAnswersInRowRecord = [coder decodeIntForKey:@"notesGuideModeNumberOfWrongAnswersInRowRecord"];
	strummingGuideModeNumberOfWrongAnswersInRowRecord = [coder decodeIntForKey:@"strummingGuideModeNumberOfWrongAnswersInRowRecord"]; 	
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	[coder encodeDouble:applicationOverallTimeSpent forKey:@"applicationOverallTimeSpent"];
	[coder encodeDouble:guideModeTimeSpent forKey:@"guideModeTimeSpent"];
	[coder encodeDouble:customModeTimeSpent forKey:@"customModeTimeSpent"];
	[coder encodeDouble:chordsGuideModeTimeSpent forKey:@"chordsGuideModeTimeSpent"];
	[coder encodeDouble:notesGuideModeTimeSpent forKey:@"notesGuideModeTimeSpent"];
	[coder encodeDouble:strummingGuideModeTimeSpent forKey:@"strummingGuideModeTimeSpent"];
	
	[coder encodeInt:guideModeNumberOfQuestionsAnswered forKey:@"guideModeNumberOfQuestionsAnswered"];
	[coder encodeInt:customModeNumberOfQuestionsAnswered forKey:@"customModeNumberOfQuestionsAnswered"];
	
	[coder encodeInt:chordsGuideModeNumberOfQuestionsAnswered forKey:@"chordsGuideModeNumberOfQuestionsAnswered"];
	[coder encodeInt:notesGuideModeNumberOfQuestionsAnswered forKey:@"notesGuideModeNumberOfQuestionsAnswered"];
	[coder encodeInt:strummingGuideModeNumberOfQuestionsAnswered forKey:@"strummingGuideModeNumberOfQuestionsAnswered"];
	
	[coder encodeInt:chordsGuideModeNumberOfRightAnswers forKey:@"chordsGuideModeNumberOfRightAnswers"];
	[coder encodeInt:notesGuideModeNumberOfRightAnswers forKey:@"notesGuideModeNumberOfRightAnswers"];
	[coder encodeInt:strummingGuideModeNumberOfRightAnswers forKey:@"strummingGuideModeNumberOfRightAnswers"];
	
	[coder encodeInt:chordsGuideModeNumberOfWrongAnswers forKey:@"chordsGuideModeNumberOfWrongAnswers"];
	[coder encodeInt:notesGuideModeNumberOfWrongAnswers forKey:@"notesGuideModeNumberOfWrongAnswers"];
	[coder encodeInt:strummingGuideModeNumberOfWrongAnswers forKey:@"strummingGuideModeNumberOfWrongAnswers"];
	
	[coder encodeInt:chordsGuideModeNumberOfRightAnswersInRowRecord forKey:@"chordsGuideModeNumberOfRightAnswersInRowRecord"];
	[coder encodeInt:notesGuideModeNumberOfRightAnswersInRowRecord forKey:@"notesGuideModeNumberOfRightAnswersInRowRecord"];
	[coder encodeInt:strummingGuideModeNumberOfRightAnswersInRowRecord forKey:@"strummingGuideModeNumberOfRightAnswersInRowRecord"];
	[coder encodeInt:chordsGuideModeNumberOfWrongAnswersInRowRecord forKey:@"chordsGuideModeNumberOfWrongAnswersInRowRecord"];
	[coder encodeInt:notesGuideModeNumberOfWrongAnswersInRowRecord forKey:@"notesGuideModeNumberOfWrongAnswersInRowRecord"];
	[coder encodeInt:strummingGuideModeNumberOfWrongAnswersInRowRecord forKey:@"strummingGuideModeNumberOfWrongAnswersInRowRecord"];
}

-(void)addTimeToApplicationOverall: (double)time {
	applicationOverallTimeSpent += time < 0 ? -time : time;
}

-(void)addTimeToGuideMode: (double)time {
	guideModeTimeSpent += time < 0 ? -time : time;
}

-(void)addTimeToCustomMode: (double)time {
	customModeTimeSpent += time < 0 ? -time : time;
}

-(void)addTimeToChordsGuideMode: (double)time {
	chordsGuideModeTimeSpent += time < 0 ? -time : time;
}

-(void)addTimeToNotesGuideMide: (double)time {
	notesGuideModeTimeSpent += time < 0 ? -time : time;
}

-(void)addTimeToStrummingGuideMide: (double)time {
	strummingGuideModeTimeSpent += time < 0 ? -time : time;
}

-(void)incCustomModeNumberOfQuestionsAnswered {
	customModeNumberOfQuestionsAnswered++;
}

-(void)incChordsGuideModeNumberOfRightAnswers {
	chordsGuideModeNumberOfRightAnswers++;
	chordsGuideModeNumberOfQuestionsAnswered++;
	guideModeNumberOfQuestionsAnswered++;
}

-(void)incNotesGuideModeNumberOfRightAnswers {
	notesGuideModeNumberOfRightAnswers++;
	notesGuideModeNumberOfQuestionsAnswered++;
	guideModeNumberOfQuestionsAnswered++;
}

-(void)incStrummingGuideModeNumberOfRightAnswers {
	strummingGuideModeNumberOfRightAnswers++;
	strummingGuideModeNumberOfQuestionsAnswered++;
	guideModeNumberOfQuestionsAnswered++;
}

-(void)incChordsGuideModeNumberOfWrongAnswers {
	chordsGuideModeNumberOfWrongAnswers++;
	chordsGuideModeNumberOfQuestionsAnswered++;
	guideModeNumberOfQuestionsAnswered++;
}

-(void)incNotesGuideModeNumberOfWrongAnswers {
	notesGuideModeNumberOfWrongAnswers++;
	notesGuideModeNumberOfQuestionsAnswered++;
	guideModeNumberOfQuestionsAnswered++;
}

-(void)incStrummingGuideModeNumberOfWrongAnswers {
	strummingGuideModeNumberOfWrongAnswers++;
	strummingGuideModeNumberOfQuestionsAnswered++;
	guideModeNumberOfQuestionsAnswered++;
}

-(void)resetAll {
	applicationOverallTimeSpent = 0.0f;
	guideModeTimeSpent = 0.0f;
	customModeTimeSpent = 0.0f;
	chordsGuideModeTimeSpent = 0.0f;
	notesGuideModeTimeSpent = 0.0f;
	strummingGuideModeTimeSpent = 0.0f;
	
	guideModeNumberOfQuestionsAnswered = 0;
	customModeNumberOfQuestionsAnswered = 0;
	
	chordsGuideModeNumberOfQuestionsAnswered = 0;
	notesGuideModeNumberOfQuestionsAnswered = 0;
	strummingGuideModeNumberOfQuestionsAnswered = 0;
	
	chordsGuideModeNumberOfRightAnswers = 0;
	notesGuideModeNumberOfRightAnswers = 0;
	strummingGuideModeNumberOfRightAnswers = 0;
	
	chordsGuideModeNumberOfWrongAnswers = 0;
	notesGuideModeNumberOfWrongAnswers = 0;
	strummingGuideModeNumberOfWrongAnswers = 0;
	
	chordsGuideModeNumberOfRightAnswersInRowRecord = 0;
	notesGuideModeNumberOfRightAnswersInRowRecord = 0;
	strummingGuideModeNumberOfRightAnswersInRowRecord = 0;
	chordsGuideModeNumberOfWrongAnswersInRowRecord = 0;
	notesGuideModeNumberOfWrongAnswersInRowRecord = 0;
	strummingGuideModeNumberOfWrongAnswersInRowRecord = 0; 	
}

-(void)dealloc {
	[data release];
	[super dealloc];
}

@end
