//
//  User.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/29.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "User.h"
#import "QuizObject.h"
#import "QuizChord.h"
#import "QuizStrum.h"
#import "QuizNote.h"
#import "Trophy.h"
#import "Utils.h"

const NSInteger MAX_USER_LEVEL = 50;
static const NSInteger kLevelExp[] = {
	0, 0, 5, 10, 20, 35, 55, 80, 110, 145, 185,							// Level 0 - 10
	230, 280, 335, 395, 460, 530, 605, 685, 770, 860,					// Level 11 - 20
	955, 1055, 1160, 1270, 1385, 1505, 1630, 1760, 1895, 2035,			// Level 21 - 30
	2180, 2330, 2485, 2645, 2810, 2980, 3155, 3335, 3520, 3710,			// Level 31	- 40
	3905, 4105, 4310, 4520, 4735, 4955, 5180, 5410, 5645, 5885, 6130	// Level 41 - 50
};

@implementation User

@synthesize username, password, autoLogin, guitarType, numericStats, trophies;
@synthesize chordsGuideMode, notesGuideMode, strummingGuideMode;
@synthesize chordsGuideModeExp, notesGuideModeExp, strummingGuideModeExp;
@synthesize chordsGuideModeLevel, notesGuideModeLevel, strummingGuideModeLevel;

-(id)initWithUsername: (NSString *)aUsername 
		  andPassword: (NSString *)aPassword 
		 andAutoLogin: (BOOL)isAutoLogin 
		andGuitarType: (NSInteger)theGuitarType {
	if (self = [super init]) {
		self.username = aUsername;
		self.password = aPassword;
		self.autoLogin = isAutoLogin;
		self.guitarType = theGuitarType;
		
		[self loadDefaultTrophies];
		[self loadDefaultObjects];
		[self loadDefaultStats];
		
		chordsGuideModeExp = 0;
		notesGuideModeExp = 0;
		strummingGuideModeExp = 0;
		chordsGuideModeLevel = 1;
		notesGuideModeLevel = 1;
		strummingGuideModeLevel = 1;
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	username = [[aDecoder decodeObjectForKey:@"username"] retain];
	password = [[aDecoder decodeObjectForKey:@"password"] retain];
	autoLogin = [aDecoder decodeBoolForKey:@"autoLogin"];
	guitarType = [aDecoder decodeIntForKey:@"guitarType"];
	
	trophies = [[aDecoder decodeObjectForKey:@"trophies"] retain];
	
	numericStats = [[aDecoder decodeObjectForKey:@"numericStats"] retain];
	
	chordsGuideMode = [[aDecoder decodeObjectForKey:@"chordsGuideMode"] retain];
	notesGuideMode = [[aDecoder decodeObjectForKey:@"notesGuideMode"] retain];
	strummingGuideMode = [[aDecoder decodeObjectForKey:@"strummingGuideMode"] retain];
	
	chordsGuideModeExp = [aDecoder decodeIntForKey:@"chordsGuideModeExp"];
	notesGuideModeExp = [aDecoder decodeIntForKey:@"notesGuideModeExp"];
	strummingGuideModeExp = [aDecoder decodeIntForKey:@"strummingGuideModeExp"];
	chordsGuideModeLevel = [aDecoder decodeIntForKey:@"chordsGuideModeLevel"];
	notesGuideModeLevel = [aDecoder decodeIntForKey:@"notesGuideModeLevel"];
	strummingGuideModeLevel = [aDecoder decodeIntForKey:@"strummingGuideModeLevel"];
	
	[self refreshLanguage];
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:username forKey:@"username"];
	[aCoder encodeObject:password forKey:@"password"];
	[aCoder encodeBool:autoLogin forKey:@"autoLogin"];
	[aCoder encodeInt:guitarType forKey:@"guitarType"];
	
	[aCoder encodeObject:trophies forKey:@"trophies"];
	
	[aCoder encodeObject:numericStats forKey:@"numericStats"];
	
	[aCoder encodeObject:chordsGuideMode forKey:@"chordsGuideMode"];
	[aCoder encodeObject:notesGuideMode forKey:@"notesGuideMode"];
	[aCoder encodeObject:strummingGuideMode forKey:@"strummingGuideMode"];
	
	[aCoder encodeInt:chordsGuideModeExp forKey:@"chordsGuideModeExp"];
	[aCoder encodeInt:notesGuideModeExp forKey:@"notesGuideModeExp"];
	[aCoder encodeInt:strummingGuideModeExp forKey:@"strummingGuideModeExp"];
	[aCoder encodeInt:chordsGuideModeLevel forKey:@"chordsGuideModeLevel"];
	[aCoder encodeInt:notesGuideModeLevel forKey:@"notesGuideModeLevel"];
	[aCoder encodeInt:strummingGuideModeLevel forKey:@"strummingGuideModeLevel"];
}

+(NSString *)guitarTypeToString: (GuitarType)theGuitarType {
	if (theGuitarType = GuitarTypeAccoustic) {
		return NSLocalizedString(@"Accoustic", @"");
	} else {
		return NSLocalizedString(@"Classical", @"");
	}
}

-(NSString *)guitarTypeAsString {
	if (guitarType = GuitarTypeAccoustic) {
		return NSLocalizedString(@"Accoustic", @"");
	} else {
		return NSLocalizedString(@"Classical", @"");
	}
}

+(User *)userWithUsername: (NSString *)aUsername 
			  andPassword: (NSString *)aPassword 
			 andAutoLogin: (BOOL)isAutoLogin 
			andGuitarType: (NSInteger)theGuitarType {
	
	User *user = [[User alloc] initWithUsername:aUsername
									andPassword:aPassword 
								   andAutoLogin:isAutoLogin 
								  andGuitarType:theGuitarType];
	
	return [user autorelease];
}

+(User *)createDefaultUser {
	User *user = [[User alloc] initWithUsername:@"user" 
									andPassword:@"user" 
								   andAutoLogin:NO 
								  andGuitarType:GuitarTypeAccoustic];
	
	return [user autorelease];
}

-(void)refreshLanguage {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultTrophies" ofType:@"plist"];
	
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	
	NSString *nameKey = nil;
	NSString *descriptionKey = nil;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = [languages objectAtIndex:0];
	
	// Verificar a lingua para carregar as strings correctas
	if ([currentLanguage isEqualToString:@"en"]) {
		nameKey = @"nameEn";
		descriptionKey = @"descriptionEn";
	} else {
		nameKey = @"name";
		descriptionKey = @"description";
	}
	
	
	for (int i = 0; i < [dict count]; i++) {
		NSDictionary *tmp = [dict objectForKey:[NSString stringWithFormat:@"%03d", i + 1]];
		
		[[self.trophies objectAtIndex:i] setName:[tmp objectForKey:nameKey]];
		[[self.trophies objectAtIndex:i] setDescription:[tmp objectForKey:descriptionKey]];
	}
	
	[dict release];
}

-(void)loadDefaultTrophies {
	NSMutableArray *trophiesArray = [[NSMutableArray alloc] init];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultTrophies" ofType:@"plist"];
	
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	/*
	NSEnumerator *enumetaror = [dict keyEnumerator];
	
	id key;
	while ((key = [enumetaror nextObject])) {
		NSDictionary *tmp = [dict objectForKey:key];
		
		[trophiesArray addObject:[Trophy trophyWithName:[tmp objectForKey:@"name"] 
										 andDescription:[tmp objectForKey:@"description"]
											  andPoints:[[tmp objectForKey:@"points"] intValue] 
											andSelector:[tmp objectForKey:@"selector"]]];
		
	}
	 */
	
	NSString *nameKey = nil;
	NSString *descriptionKey = nil;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = [languages objectAtIndex:0];
	
	// Verificar a lingua para carregar as strings correctas
	if ([currentLanguage isEqualToString:@"en"]) {
		nameKey = @"nameEn";
		descriptionKey = @"descriptionEn";
	} else {
		nameKey = @"name";
		descriptionKey = @"description";
	}

	
	for (int i = 0; i < [dict count]; i++) {
		NSDictionary *tmp = [dict objectForKey:[NSString stringWithFormat:@"%03d", i + 1]];
		
		[trophiesArray addObject:[Trophy trophyWithName:[tmp objectForKey:nameKey] 
										 andDescription:[tmp objectForKey:descriptionKey]
											  andPoints:[[tmp objectForKey:@"points"] intValue] 
											andSelector:[tmp objectForKey:@"selector"]]];
	}
	
	[self setTrophies:trophiesArray];
	
	[trophiesArray release];
	[dict release];
}

-(void)loadDefaultObjects {
	NSArray *stringArray = [[NSArray alloc] initWithObjects:@"defaultChords", @"defaultStrumming", @"defaultNotes", nil];
	
	for (int i = 0; i < [stringArray count]; i++) {
		NSString *path = [[NSBundle mainBundle] pathForResource:[stringArray objectAtIndex:i] ofType:@"plist"];
		
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
		NSMutableArray *objectsArray = [[NSMutableArray alloc] init];
		
		NSEnumerator *enumetaror = [dict keyEnumerator];
		
		id key;
		while ((key = [enumetaror nextObject])) {
			NSDictionary *tmp = [dict objectForKey:key];
			
			id obj = nil;
			switch (i) {
				case 0:	obj = [[QuizChord alloc] initWithObjectId:[tmp objectForKey:@"id"] 
											   andImagePath:[tmp objectForKey:@"imagePath"] 
											   andSoundPath:[tmp objectForKey:@"soundPath"] 
															 load:NO];
					break;
				case 1:	obj = [[QuizStrum alloc] initWithObjectId:[tmp objectForKey:@"id"] 
																	   andImagePath:[tmp objectForKey:@"imagePath"] 
																	   andSoundPath:[tmp objectForKey:@"soundPath"] 
																			   load:NO];
					break;
				case 2:	obj = [[QuizNote alloc] initWithObjectId:[tmp objectForKey:@"id"] 
																	  andImagePath:[tmp objectForKey:@"imagePath"] 
																	  andSoundPath:[tmp objectForKey:@"soundPath"] 
																			  load:NO];
					break;
				default:
					break;
			}
			
			[objectsArray addObject:obj];
			[obj release];
		}
		
		QuizObjectsArrays *objs = [[QuizObjectsArrays alloc] init];
		
		[objs setUnknown:objectsArray];
		
		[objectsArray release];
		objectsArray = nil;
		
		[dict release];
		dict = nil;
		
		switch (i) {
			case 0:	[self setChordsGuideMode:objs];		break;
			case 1:	[self setStrummingGuideMode:objs];	break;
			case 2:	[self setNotesGuideMode:objs];		break;
			default:
				break;
		}
		
		[objs release];
		[objectsArray release];
		[dict release];
	}
	
	[stringArray release];
}

-(void)loadDefaultStats {
	if (numericStats != nil) {
		[numericStats resetAll];
	} else {
		id stats = [[NumericStats alloc] init];
		
		self.numericStats = stats;
		
		[stats release];
	}
}

-(BOOL)addExpToChordsGuideMode: (NSInteger)points {
	int previousLevel = chordsGuideModeLevel;
	int nextLevel = 0;
	
	// Não adicionar EXP quando ja atingiu o maximo level
	if (previousLevel >= MAX_USER_LEVEL) {
		return NO;
	}
	
	chordsGuideModeExp += points;
	
	for (int i = MAX_USER_LEVEL; i >= 1; i--) {
		nextLevel = i;
		
		if (chordsGuideModeExp >= [self expForChordsLevel:i]) {
			break;
		}
	}
	
	if (nextLevel > previousLevel) {
		chordsGuideModeLevel = nextLevel;
		
		return YES;
	} else {
		return NO;
	}
}

-(BOOL)addExpToNotesGuideMode: (NSInteger)points {
	int previousLevel = notesGuideModeLevel;
	int nextLevel = 0;
	
	// Não adicionar EXP quando ja atingiu o maximo level
	if (previousLevel >= MAX_USER_LEVEL) {
		return NO;
	}
	
	notesGuideModeExp += points;
	
	for (int i = MAX_USER_LEVEL; i >= 1; i--) {
		nextLevel = i;
		
		if (notesGuideModeExp >= [self expForNotesLevel:i]) {
			break;
		}
	}
	
	if (nextLevel > previousLevel) {
		notesGuideModeLevel = nextLevel;
		
		return YES;
	} else {
		return NO;
	}
}

-(BOOL)addExpToStrummingGuideMode: (NSInteger)points {
	int previousLevel = strummingGuideModeLevel;
	int nextLevel = 0;
	
	// Não adicionar EXP quando ja atingiu o maximo level
	if (previousLevel >= MAX_USER_LEVEL) {
		return NO;
	}
	
	strummingGuideModeExp += points;
	
	for (int i = MAX_USER_LEVEL; i >= 1; i--) {
		nextLevel = i;
		
		if (strummingGuideModeExp >= [self expForStrummingLevel:i]) {
			break;
		}
	}
	
	if (nextLevel > previousLevel) {
		strummingGuideModeLevel = nextLevel;
		
		return YES;
	} else {
		return NO;
	}
}

-(void)subExpToChordsGuideMode: (NSInteger)points {
	// Nao retirar pontos ao ponto de decrementar o level
	if (chordsGuideModeExp - points < kLevelExp[chordsGuideModeLevel]) {
		chordsGuideModeExp = kLevelExp[chordsGuideModeLevel];
	} else {
		chordsGuideModeExp -= points;
	}
}

-(void)subExpToNotesGuideMode: (NSInteger)points {
	// Nao retirar pontos ao ponto de decrementar o level
	if (notesGuideModeExp - points < kLevelExp[notesGuideModeLevel]) {
		notesGuideModeExp = kLevelExp[notesGuideModeLevel];
	} else {
		notesGuideModeExp -= points;
	}
}

-(void)subExpToStrummingGuideMode: (NSInteger)points {
	// Nao retirar pontos ao ponto de decrementar o level
	if (strummingGuideModeExp - points < kLevelExp[strummingGuideModeLevel]) {
		strummingGuideModeExp = kLevelExp[strummingGuideModeLevel];
	} else {
		strummingGuideModeExp -= points;
	}
}

-(NSInteger)nextChordsGuideModeLevelExp {
	if (chordsGuideModeLevel < MAX_USER_LEVEL) {
		return [self expForChordsLevel:chordsGuideModeLevel + 1];
	} else {
		return [self expForChordsLevel:MAX_USER_LEVEL];
	}
}

-(NSInteger)nextNotesGuideModeLevelExp {
	if (notesGuideModeLevel < MAX_USER_LEVEL) {
		return [self expForNotesLevel:notesGuideModeLevel + 1];
	} else {
		return [self expForNotesLevel:MAX_USER_LEVEL];
	}
}

-(NSInteger)nextStrummingGuideModeLevelExp {
	if (strummingGuideModeLevel < MAX_USER_LEVEL) {
		return [self expForStrummingLevel:strummingGuideModeLevel + 1];
	} else {
		return [self expForStrummingLevel:MAX_USER_LEVEL];
	}
}

-(NSInteger)expForChordsLevel: (NSInteger)level {
	return (3 * ((level * level) - level + 2) + 9);
}

-(NSInteger)expForNotesLevel: (NSInteger)level {
	return (3 * ((level * level) - level + 2) + 9);
}

-(NSInteger)expForStrummingLevel: (NSInteger)level {
	return (3 * ((level * level) - level + 2) + 9);
}

-(NSMutableArray *)checkTrophies {
	NSMutableArray *array = nil;
	
	for (int i = 0; i < [trophies count]; i++) {
		id obj = [trophies objectAtIndex:i];
		
		if ([(Trophy *)obj check]) {
			if (array == nil) {
				array = [[NSMutableArray alloc] init];
			}
			
			[array addObject:obj];
		}
	}
	
	return [array autorelease];
}

-(BOOL)isPasswordCorrect: (NSString *)aPassword {
	return [password isEqualToString:aPassword];
}

-(void)print {
	NSLog(@"Chords: %d\nNotes: %d\nStrumming: %d", chordsGuideModeExp, notesGuideModeExp, strummingGuideModeExp);
	
}

-(void)reset {	
	[self loadDefaultTrophies];
	[self loadDefaultObjects];
	[self loadDefaultStats];
	
	chordsGuideModeExp = 0;
	notesGuideModeExp = 0;
	strummingGuideModeExp = 0;
	chordsGuideModeLevel = 1;
	notesGuideModeLevel = 1;
	strummingGuideModeLevel = 1;
}

-(void)dealloc {
	[username release];
	[password release];
	[trophies release];
	[numericStats release];
	[chordsGuideMode release];
	[notesGuideMode release];
	[strummingGuideMode release];
	
	[super dealloc];
}

@end
