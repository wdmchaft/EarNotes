//
//  User.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/29.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumericStats.h"
#import "Trophy.h"
#import "QuizObjectsArrays.h"

extern const NSInteger MAX_USER_LEVEL;

typedef enum GuitarType {
	GuitarTypeAccoustic = 0,
	GuitarTypeClassical,
	NUM_GUITAR_TYPE
}GuitarType;

@class ModeData;

@interface User : NSObject <NSCoding> {
	NSString *username;
	NSString *password;
	bool autoLogin;
	
	NSInteger guitarType;
	
	NSMutableArray *trophies;
	
	NumericStats *numericStats;
	
	QuizObjectsArrays *chordsGuideMode;
	QuizObjectsArrays *notesGuideMode;
	QuizObjectsArrays *strummingGuideMode;
	
	NSInteger chordsGuideModeExp;
	NSInteger notesGuideModeExp;
	NSInteger strummingGuideModeExp;
	
	NSInteger chordsGuideModeLevel;
	NSInteger notesGuideModeLevel;
	NSInteger strummingGuideModeLevel;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) bool autoLogin;
@property (nonatomic, assign) NSInteger guitarType;

@property (nonatomic, retain) NSMutableArray *trophies;

@property (nonatomic, retain) NumericStats *numericStats;
@property (nonatomic, retain) QuizObjectsArrays *chordsGuideMode;
@property (nonatomic, retain) QuizObjectsArrays *notesGuideMode;
@property (nonatomic, retain) QuizObjectsArrays *strummingGuideMode;

@property (nonatomic, readonly) NSInteger chordsGuideModeExp;
@property (nonatomic, readonly) NSInteger notesGuideModeExp;
@property (nonatomic, readonly) NSInteger strummingGuideModeExp;

@property (nonatomic, readonly) NSInteger chordsGuideModeLevel;
@property (nonatomic, readonly) NSInteger notesGuideModeLevel;
@property (nonatomic, readonly) NSInteger strummingGuideModeLevel;

+(NSString *)guitarTypeToString: (GuitarType)theGuitarType;
-(NSString *)guitarTypeAsString;

+(User *)createDefaultUser;
+(User *)userWithUsername: (NSString *)aUsername 
			  andPassword: (NSString *)aPassword 
			 andAutoLogin: (BOOL)isAutoLogin 
			andGuitarType: (NSInteger)theGuitarType;

-(id)initWithUsername: (NSString *)aUsername 
		  andPassword: (NSString *)aPassword 
		 andAutoLogin: (BOOL)isAutoLogin 
		andGuitarType: (NSInteger)theGuitarType;

-(void)loadDefaultTrophies;
-(void)loadDefaultObjects;
-(void)loadDefaultStats;

-(BOOL)addExpToChordsGuideMode: (NSInteger)points;
-(BOOL)addExpToNotesGuideMode: (NSInteger)points;
-(BOOL)addExpToStrummingGuideMode: (NSInteger)points;

-(void)subExpToChordsGuideMode: (NSInteger)points;
-(void)subExpToNotesGuideMode: (NSInteger)points;
-(void)subExpToStrummingGuideMode: (NSInteger)points;

-(NSInteger)nextChordsGuideModeLevelExp;
-(NSInteger)nextNotesGuideModeLevelExp;
-(NSInteger)nextStrummingGuideModeLevelExp;

-(NSInteger)expForChordsLevel: (NSInteger)level;
-(NSInteger)expForNotesLevel: (NSInteger)level;
-(NSInteger)expForStrummingLevel: (NSInteger)level;

-(BOOL)isPasswordCorrect: (NSString *)aPassword;

-(void)print;

// Carrega as strings correctas
-(void)refreshLanguage;

-(NSMutableArray *)checkTrophies;

-(void)reset;

@end
