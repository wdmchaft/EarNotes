//
//  QuizChord.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/24.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizObject.h"

@interface QuizChord : QuizObject {

}

-(id)initWithObjectId: (NSString *)theObjectId;
-(id)initWithObjectId: (NSString *)theObjectId 
		 andImagePath: (NSString *)theImagePath 
		 andSoundPath: (NSString *)theSoundPath;
-(id)initWithObjectId: (NSString *)theObjectId 
		 andImagePath: (NSString *)theImagePath 
		 andSoundPath: (NSString *)theSoundPath 
				 load: (BOOL)loadFlag;

-(void)loadImage;

+(NSMutableArray *)loadDefaultChords;

@end
