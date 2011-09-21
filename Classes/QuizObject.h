//
//  QuizObject.h
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/22.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "NumericStats.h"
#import "Sound.h"

@interface QuizObject : NSObject <NSCoding> {
	NSString *objectId;
	
	NSString *imagePath;
	UIImage *image;
	
	NSString *soundPath;
	Sound *sound;
	
	// Dados estatisticos
	NSInteger rightAnswers;
	NSInteger rightAnswersInARow;
	NSInteger rightAnswersInARowRecord;
	NSInteger wrongAnswers;
	NSInteger wrongAnswersInARow;
	NSInteger wrongAnswersInARowRecord;
	
	BOOL isQuestionNew;
}

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, copy) NSString *soundPath;
@property (nonatomic, retain) Sound *sound;

@property (readonly, nonatomic) NSInteger rightAnswers;
@property (readonly, nonatomic) NSInteger rightAnswersInARow;
@property (readonly, nonatomic) NSInteger rightAnswersInARowRecord;
@property (readonly, nonatomic) NSInteger wrongAnswers;
@property (readonly, nonatomic) NSInteger wrongAnswersInARow;
@property (readonly, nonatomic) NSInteger wrongAnswersInARowRecord;

@property (nonatomic, assign) BOOL isQuestionNew;

-(id)initWithObjectId: (NSString *)theObjectId;
-(id)initWithObjectId: (NSString *)theObjectId 
		 andImagePath: (NSString *)theImagePath 
		 andSoundPath: (NSString *)theSoundPath;
-(id)initWithObjectId: (NSString *)theObjectId 
		 andImagePath: (NSString *)theImagePath 
		 andSoundPath: (NSString *)theSoundPath 
				 load: (BOOL)loadFlag;

-(void)play;
-(void)stop;

-(void)loadImageAndSound;
-(void)loadImage;
-(void)loadSound;

-(void)unloadImageAndSound;

-(void)incRightAnswers;
-(void)incWrongAnswers;
-(void)resetCounters;

-(void)print;

+(QuizObject *)quizObjectWithAnswerId: (NSString *)theObjectId 
						 andImagePath: (NSString *)theImagePath 
						 andSoundPath: (NSString *)theSoundPath 
								 load: (BOOL)loadFlag;

@end
