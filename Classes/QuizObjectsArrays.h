//
//  QuizObjectsArrays.h
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/22.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ARRAY_NAME {
	ArrayNameMastered = 0,
	ArrayNameKnown,
	ArrayNameLearning,
	ArrayNameUnknown,
	ArrayNameInvalid
}ArrayName;

@interface QuizObjectsArrays : NSObject <NSCoding> {
	NSMutableArray *mastered;
	NSMutableArray *known;
	NSMutableArray *learning;
	NSMutableArray *unknown;
}

@property (nonatomic, retain) NSMutableArray *mastered;
@property (nonatomic, retain) NSMutableArray *known;
@property (nonatomic, retain) NSMutableArray *learning;
@property (nonatomic, retain) NSMutableArray *unknown;

-(NSInteger)numberOfMasteredObjects;
-(NSInteger)numberOfKnownObjects;
-(NSInteger)numberOfLeaningObjects;
-(NSInteger)numberOfUnknownObjects;

// Move o objecto para a fila superior, ou seja:
// 'unknown' para 'learning', 'learning' para 'known', 'known' para 'mastered'
-(void)upgradeObject: (id)object;

// Move o objecto para a fila inferior, ou seja:
// 'mastered' para 'known', 'known' para 'learning', 'learning' para 'unknown'
-(void)downgradeObject: (id)object;

-(ArrayName)getObjectArrayName: (id)object;

-(BOOL)isFromMasteredArray: (id)object;
-(BOOL)isFromKnownArray: (id)object;
-(BOOL)isFromLearningArray: (id)object;
-(BOOL)isFromUnknownArray: (id)object;

@end

