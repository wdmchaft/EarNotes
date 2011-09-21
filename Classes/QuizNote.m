//
//  QuizNote.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/24.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "QuizNote.h"
#import "UIImage+Combine.h"

@implementation QuizNote

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

-(void)loadImage {
	if (self.image == nil) {
		//		self.image = [UIImage imageNamed:self.imagePath];
		UIImage *img = nil;
		
		NSArray *tokens = [self.imagePath componentsSeparatedByString:@"_"];
		
		if ([tokens count] > 0) {
			img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", (NSString *)[tokens objectAtIndex:0]]];
		} else {
			NSLog(@"Image %@ not loaded.", self.imagePath);
		}
		
		
		for (int i = 1; i < [tokens count]; i++) {
			UIImage *tmp = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", (NSString *)[tokens objectAtIndex:i]]];
			img = [UIImage imageFromImage:img andOverlayedImage:tmp];
		}
		
		self.image = img;
	}
}

+(NSMutableArray *)loadDefaultNotes {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultNotes" ofType:@"plist"];
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	NSMutableArray *objectsArray = [[NSMutableArray alloc] init];
	
	NSEnumerator *enumetaror = [dict keyEnumerator];
	
	id key;
	id obj;
	while ((key = [enumetaror nextObject])) {
		NSDictionary *tmp = [dict objectForKey:key];
		
		obj = [[QuizNote alloc] initWithObjectId:[tmp objectForKey:@"id"] 
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
