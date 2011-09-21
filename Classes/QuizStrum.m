//
//  QuizStrum.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/24.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "QuizStrum.h"


@implementation QuizStrum

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
							 load:NO];
}

-(id)initWithObjectId: (NSString *)theObjectId 
		 andImagePath: (NSString *)theImagePath 
		 andSoundPath: (NSString *)theSoundPath 
				 load: (BOOL)loadFlag {
	if (self = [super initWithObjectId:theObjectId andImagePath:theImagePath andSoundPath:theSoundPath load:loadFlag]) {
		
	}
	
	return self;
}

+(NSMutableArray *)loadDefaultStrummingPatterns {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultStrumming" ofType:@"plist"];
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	NSMutableArray *objectsArray = [[NSMutableArray alloc] init];
	
	NSEnumerator *enumetaror = [dict keyEnumerator];
	
	id key;
	id obj;
	while ((key = [enumetaror nextObject])) {
		NSDictionary *tmp = [dict objectForKey:key];
		
		obj = [[QuizStrum alloc] initWithObjectId:[tmp objectForKey:@"id"] 
									 andImagePath:[tmp objectForKey:@"imagePath"] 
									 andSoundPath:[tmp objectForKey:@"soundPath"] 
											 load:NO];
		
		[objectsArray addObject:obj];
		[obj release];
	}
	
	[dict release];
	
	return [objectsArray autorelease];
}

@end
