//
//  QuizObject.m
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/22.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "QuizObject.h"

@implementation QuizObject

@synthesize objectId, imagePath, image, soundPath, sound;
@synthesize rightAnswers, rightAnswersInARow, rightAnswersInARowRecord; 
@synthesize wrongAnswers, wrongAnswersInARow, wrongAnswersInARowRecord;
@synthesize isQuestionNew;

-(id)initWithObjectId: (NSString *)theObjectId {
	return [self initWithObjectId:theObjectId 
					 andImagePath:nil 
					 andSoundPath:nil 
							 load:NO];
}

-(id)initWithObjectId: (NSString *)theObjectId 
		 andImagePath: (NSString *)theImagePath 
		 andSoundPath: (NSString *)theSoundPath {
	return [self initWithObjectId:theObjectId 
					 andImagePath:theImagePath 
					 andSoundPath:theSoundPath 
							 load:YES];
} 

-(id)initWithObjectId: (NSString *)theObjectId 
		 andImagePath: (NSString *)theImagePath 
		 andSoundPath: (NSString *)theSoundPath 
				 load: (BOOL)loadFlag {
	if (self = [super init]) {
		self.objectId = theObjectId;
		self.imagePath = theImagePath;
		self.soundPath = theSoundPath;
		self.isQuestionNew = YES;
		
		// Quando se cria um objecto novo este tem todos os contadores a 0
		[self resetCounters];
		
		if (loadFlag) {
			[self loadImageAndSound];
		}
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	objectId = [[aDecoder decodeObjectForKey:@"objectId"] retain];
	
	imagePath = [[aDecoder decodeObjectForKey:@"imagePath"] retain];
	image = nil;
	
	soundPath = [[aDecoder decodeObjectForKey:@"soundPath"] retain];
	sound = nil;

	rightAnswers = [(NSNumber *)[aDecoder decodeObjectForKey:@"rightAnswers"] intValue];
	rightAnswersInARow = [(NSNumber *)[aDecoder decodeObjectForKey:@"rightAnswersInARow"] intValue];
	rightAnswersInARowRecord = [(NSNumber *)[aDecoder decodeObjectForKey:@"rightAnswersInARowRecord"] intValue];
	wrongAnswers = [(NSNumber *)[aDecoder decodeObjectForKey:@"wrongAnswers"] intValue];
	wrongAnswersInARow = [(NSNumber *)[aDecoder decodeObjectForKey:@"wrongAnswersInARow"] intValue];
	wrongAnswersInARowRecord = [(NSNumber *)[aDecoder decodeObjectForKey:@"wrongAnswersInARowRecord"] intValue];	
	
	isQuestionNew = [aDecoder decodeIntForKey:@"isQuestionNew"];
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:objectId forKey:@"objectId"];
	
	[aCoder encodeObject:imagePath forKey:@"imagePath"];
	
	[aCoder encodeObject:soundPath forKey:@"soundPath"];
	
	// TODO: Implementar com encodeInt
	[aCoder encodeObject:[NSNumber numberWithInt:rightAnswers] forKey:@"rightAnswers"];
	[aCoder encodeObject:[NSNumber numberWithInt:rightAnswersInARow] forKey:@"rightAnswersInARow"];
	[aCoder encodeObject:[NSNumber numberWithInt:rightAnswersInARowRecord] forKey:@"rightAnswersInARowRecord"];
	[aCoder encodeObject:[NSNumber numberWithInt:wrongAnswers] forKey:@"wrongAnswers"];
	[aCoder encodeObject:[NSNumber numberWithInt:wrongAnswersInARow] forKey:@"wrongAnswersInARow"];
	[aCoder encodeObject:[NSNumber numberWithInt:wrongAnswersInARowRecord] forKey:@"wrongAnswersInARowRecord"];
	
	[aCoder encodeInt:isQuestionNew forKey:@"isQuestionNew"];
}

-(void)play {
	if (self.sound == nil) {
		[self loadSound];
	}
	
	[sound play];
}

-(void)stop {
	if (self.sound != nil) {
		[sound stop];
	}
}

-(void)loadImageAndSound {
	[self loadImage];
	[self loadSound];
}

-(void)loadImage {
	if (self.image == nil) {
		self.image = [UIImage imageNamed:self.imagePath];
	}
}

-(void)loadSound {
	if (self.sound == nil && self.soundPath != nil) {
		Sound *s = [[Sound alloc] initWithFile:RSRC(self.soundPath)];
		
		self.sound = s;
		
		[s release];
	}
}

-(void)unloadImageAndSound {
	[image release];
	image = nil;
	[sound release];
	sound = nil;
}

-(void)incRightAnswers {
	rightAnswers++;
	rightAnswersInARow++;
	
	// Reset do contador de respostas erradas de seguida e
	// verificar se é um novo record
	if (wrongAnswersInARow > wrongAnswersInARowRecord) {
		wrongAnswersInARowRecord = wrongAnswersInARow;
	} 
	
	wrongAnswersInARow = 0;
	self.isQuestionNew = NO;
}

-(void)incWrongAnswers {
	wrongAnswers++;
	wrongAnswersInARow++;
	
	// Reset do contador de respostas erradas de seguida e
	// verificar se é um novo record
	if (rightAnswersInARow > rightAnswersInARowRecord) {
		rightAnswersInARowRecord = rightAnswersInARow;
	} 
	
	rightAnswersInARow = 0;
	self.isQuestionNew = NO;
}

-(void)resetCounters {
	rightAnswers = rightAnswersInARow = rightAnswersInARowRecord = 0;
	wrongAnswers = wrongAnswersInARow = wrongAnswersInARowRecord = 0;
}

-(void)print {
	NSLog(@"ObjectID: %@\nImage Path: %@\nSound Path: %@",
		  objectId, imagePath, soundPath);
}

-(void)dealloc {
	[objectId release];
	[imagePath release];
	[image release];
	[soundPath release];
	[sound release];
	[super dealloc];
}

+(QuizObject *)quizObjectWithAnswerId: (NSString *)theObjectId 
						 andImagePath: (NSString *)theImagePath 
						 andSoundPath: (NSString *)theSoundPath 
								 load: (BOOL)loadFlag {
	QuizObject *q = [[QuizObject alloc] initWithObjectId:theObjectId 
											andImagePath:theImagePath 
											andSoundPath:theSoundPath 
													load:loadFlag];
	
	return [q autorelease];
}

@end

