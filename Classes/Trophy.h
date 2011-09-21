//
//  Trophy.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/23.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trophy : NSObject <NSCoding> {
	NSString *name;
	NSString *description;
	NSInteger points;
	BOOL ownsTrophy;
	
	NSString *selector;
}

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *description;
@property(nonatomic,assign) NSInteger points;
@property(nonatomic,assign) BOOL ownsTrophy;
@property(nonatomic,copy) NSString *selector;

-(id)initWithName: (NSString *)aName 
   andDescription: (NSString *)aDescription 
		andPoints: (NSInteger)thePoints 
	  andSelector: (NSString *)aSelector;

+(Trophy *)trophyWithName: (NSString *)aName 
		   andDescription: (NSString *)aDescription 
				andPoints: (NSInteger)thePoints 
			  andSelector: (NSString *)aSelector;

-(BOOL)check;

-(void)print;

/*
-(void)achievHours5;
-(void)achievHours20;
-(void)achievChordsLevel2;
-(void)achievChordsLevel10;
-(void)achievChordsLevel20;
-(void)achievChordsLevel30;
*/

-(void)achievHours1;
-(void)achievHours5;
-(void)achievHours20;
-(void)achievGuideModeHours3;
-(void)achievGuideModeHours10;
-(void)achievCustomModeHours3;
-(void)achievCustomModeHours10;
-(void)achievGuideModeAnswers10;
-(void)achievGuideModeAnswers100;
-(void)achievGuideModeAnswers500;
-(void)achievGuideModeAnswers1500;
-(void)achievGuideModeChordsHours1;
-(void)achievGuideModeChordsHours5;
-(void)achievChordsLevel2;
-(void)achievChordsLevel10;
-(void)achievChordsLevel20;
-(void)achievChordsLevel30;
-(void)achievGuideModeChordsRightAnswers10;
-(void)achievGuideModeChordsRightAnswers50;
-(void)achievGuideModeChordsRightAnswers250;
-(void)achievGuideModeChordsRightAnswers500;
-(void)achievGuideModeChordsRightAnswers1000;
-(void)achievGuideModeChordsRightAnswersInRow5;
-(void)achievGuideModeChordsRightAnswersInRow10;
-(void)achievGuideModeChordsRightAnswersInRow15;
-(void)achievGuideModeChordsRightAnswersInRow20;
-(void)achievGuideModeChordsRightAnswersInRow25;
-(void)achievKnownChords1;
-(void)achievKnownChords5;
-(void)achievKnownChords10;
-(void)achievKnownChords15;
-(void)achievKnownChords30;
-(void)achievMasteredChords1;
-(void)achievMasteredChords5;
-(void)achievMasteredChords10;
-(void)achievMasteredChords15;
-(void)achievMasteredChords30;
-(void)achievGuideModeNotesHours1;
-(void)achievGuideModeNotesHours5;
-(void)achievNotesLevel2;
-(void)achievNotesLevel10;
-(void)achievNotesLevel20;
-(void)achievNotesLevel30;
-(void)achievGuideModeNotesRightAnswers10;
-(void)achievGuideModeNotesRightAnswers50;
-(void)achievGuideModeNotesRightAnswers250;
-(void)achievGuideModeNotesRightAnswers500;
-(void)achievGuideModeNotesRightAnswers1000;
-(void)achievGuideModeNotesRightAnswersInRow5;
-(void)achievGuideModeNotesRightAnswersInRow10;
-(void)achievGuideModeNotesRightAnswersInRow15;
-(void)achievGuideModeNotesRightAnswersInRow20;
-(void)achievGuideModeNotesRightAnswersInRow25;
-(void)achievKnownNotes1;
-(void)achievKnownNotes3;
-(void)achievKnownNotes5;
-(void)achievKnownNotes8;
-(void)achievKnownNotes12;
-(void)achievMasteredNotes1;
-(void)achievMasteredNotes3;
-(void)achievMasteredNotes5;
-(void)achievMasteredNotes8;
-(void)achievMasteredNotes12;
-(void)achievGuideModeStrummingHours1;
-(void)achievGuideModeStrummingHours5;
-(void)achievStrummingLevel2;
-(void)achievStrummingLevel10;
-(void)achievStrummingLevel20;
-(void)achievStrummingLevel30;
-(void)achievGuideModeStrummingRightAnswers10;
-(void)achievGuideModeStrummingRightAnswers50;
-(void)achievGuideModeStrummingRightAnswers250;
-(void)achievGuideModeStrummingRightAnswers500;
-(void)achievGuideModeStrummingRightAnswers1000;
-(void)achievGuideModeStrummingRightAnswersInRow5;
-(void)achievGuideModeStrummingRightAnswersInRow10;
-(void)achievGuideModeStrummingRightAnswersInRow15;
-(void)achievGuideModeStrummingRightAnswersInRow20;
-(void)achievGuideModeStrummingRightAnswersInRow25;
-(void)achievKnownStrumming1;
-(void)achievKnownStrumming3;
-(void)achievKnownStrumming5;
-(void)achievKnownStrumming8;
-(void)achievKnownStrumming12;
-(void)achievMasteredStrumming1;
-(void)achievMasteredStrumming3;
-(void)achievMasteredStrumming5;
-(void)achievMasteredStrumming8;
-(void)achievMasteredStrumming12;

@end
