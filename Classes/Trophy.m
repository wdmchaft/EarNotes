//
//  Trophy.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/23.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "Trophy.h"
#import "SharedAppData.h"

@implementation Trophy

@synthesize name, description, points, ownsTrophy, selector;

-(id)init {
	return [self initWithName:nil andDescription:nil andPoints:0 andSelector:nil];
}

-(id)initWithName: (NSString *)aName 
   andDescription: (NSString *)aDescription 
		andPoints: (NSInteger)thePoints
	  andSelector: (NSString *)aSelector {
	if (self = [super init]) {
		self.name = aName;
		self.description = aDescription;
		self.points = thePoints;
		self.ownsTrophy = NO;
		self.selector = aSelector;
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	name = [[aDecoder decodeObjectForKey:@"name"] retain];
	description = [[aDecoder decodeObjectForKey:@"description"] retain];
	points = [aDecoder decodeIntForKey:@"points"];
	ownsTrophy = [aDecoder decodeBoolForKey:@"ownsTrophy"];
	selector = [[aDecoder decodeObjectForKey:@"selector"] retain];
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:description forKey:@"description"];
	[aCoder encodeInt:points forKey:@"points"];
	[aCoder encodeBool:ownsTrophy forKey:@"ownsTrophy"];
	[aCoder encodeObject:selector forKey:@"selector"];
}

+(Trophy *)trophyWithName: (NSString *)aName 
		   andDescription: (NSString *)aDescription 
				andPoints: (NSInteger)thePoints
			  andSelector: (NSString *)aSelector {
	Trophy *trophy = [[Trophy alloc] initWithName:aName 
								   andDescription:aDescription 
										andPoints:thePoints
									  andSelector:aSelector];
	
	return [trophy autorelease];
}

-(void)print {
	NSLog(@"Name: %@\nDescription: %@\nPoints: %d\nOwns Trophy: %@, Sel: %@",
		  self.name, self.description, self.points, (self.ownsTrophy == YES ? @"Yes" : @"No"), self.selector);
}

-(BOOL)check {
	// Verifica apenas se ainda não possuir o troféu
	if (!ownsTrophy) {
		SEL func = NSSelectorFromString(self.selector);
		
		// Chama função de vereficação de troféu
		if ([self respondsToSelector:func]) {
			[self performSelector:func];
		}
		
		return ownsTrophy ? YES : NO;
	} else {
		return NO;
	}
}

-(void)dealloc {
	[name release];
	[description release];
	[selector release];
	[super dealloc];
}

// *** IMPLEMENTAR A FUNÇÃO DE VEREFICAÇÃO DE CADA TROFÉU ***
/*
-(void)achievHours5 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] applicationOverallTimeSpent] >= 18000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievHours20 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] applicationOverallTimeSpent] >= 72000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievChordsLevel2 {
	if ([[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel] >= 2) {
		ownsTrophy = YES;
	}
}

-(void)achievChordsLevel10 {
	if ([[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievChordsLevel20 {
	if ([[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel] >= 20) {
		ownsTrophy = YES;
	}
}

-(void)achievChordsLevel30 {
	if ([[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel] >= 30) {
		ownsTrophy = YES;
	}
}
 */

-(void)achievHours1 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] applicationOverallTimeSpent] >= 3600.0) {
		ownsTrophy = YES;
	}
}

-(void)achievHours5 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] applicationOverallTimeSpent] >= 18000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievHours20 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] applicationOverallTimeSpent] >= 72000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeHours3 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] guideModeTimeSpent] >= 10800.0) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeHours10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] guideModeTimeSpent] >= 36000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievCustomModeHours3 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] customModeTimeSpent] >= 10800.0) {
		ownsTrophy = YES;
	}
}

-(void)achievCustomModeHours10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] customModeTimeSpent] >= 36000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeAnswers10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] guideModeNumberOfQuestionsAnswered] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeAnswers100 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] guideModeNumberOfQuestionsAnswered] >= 100) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeAnswers500 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] guideModeNumberOfQuestionsAnswered] >= 500) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeAnswers1500 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] guideModeNumberOfQuestionsAnswered] >= 1000) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsHours1 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeTimeSpent] >= 3600.0) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsHours5 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeTimeSpent] >= 18000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievChordsLevel2 {
	if ([[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel] >= 2) {
		ownsTrophy = YES;
	}
}

-(void)achievChordsLevel10 {
	if ([[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievChordsLevel20 {
	if ([[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel] >= 20) {
		ownsTrophy = YES;
	}
}

-(void)achievChordsLevel30 {
	if ([[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel] >= 30) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswers10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswers] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswers50 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswers] >= 50) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswers250 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswers] >= 250) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswers500 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswers] >= 500) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswers1000 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswers] >= 1000) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswersInRow5 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswersInRowRecord] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswersInRow10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswersInRowRecord] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswersInRow15 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswersInRowRecord] >= 15) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswersInRow20 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswersInRowRecord] >= 20) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeChordsRightAnswersInRow25 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] chordsGuideModeNumberOfRightAnswersInRowRecord] >= 25) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownChords1 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfKnownObjects] >= 1) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownChords5 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfKnownObjects] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownChords10 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfKnownObjects] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownChords15 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfKnownObjects] >= 15) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownChords30 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfKnownObjects] >= 30) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredChords1 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfMasteredObjects] >= 1) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredChords5 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfMasteredObjects] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredChords10 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfMasteredObjects] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredChords15 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfMasteredObjects] >= 15) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredChords30 {
	if ([[[[SharedAppData sharedInstance] currentUser] chordsGuideMode] numberOfMasteredObjects] >= 30) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesHours1 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeTimeSpent] >= 3600.0) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesHours5 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeTimeSpent] >= 18000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievNotesLevel2 {
	if ([[[SharedAppData sharedInstance] currentUser] notesGuideModeLevel] >= 2) {
		ownsTrophy = YES;
	}
}

-(void)achievNotesLevel10 {
	if ([[[SharedAppData sharedInstance] currentUser] notesGuideModeLevel] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievNotesLevel20 {
	if ([[[SharedAppData sharedInstance] currentUser] notesGuideModeLevel] >= 20) {
		ownsTrophy = YES;
	}
}

-(void)achievNotesLevel30 {
	if ([[[SharedAppData sharedInstance] currentUser] notesGuideModeLevel] >= 30) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswers10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswers] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswers50 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswers] >= 50) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswers250 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswers] >= 250) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswers500 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswers] >= 500) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswers1000 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswers] >= 1000) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswersInRow5 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswersInRowRecord] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswersInRow10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswersInRowRecord] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswersInRow15 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswersInRowRecord] >= 15) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswersInRow20 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswersInRowRecord] >= 20) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeNotesRightAnswersInRow25 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] notesGuideModeNumberOfRightAnswersInRowRecord] >= 25) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownNotes1 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfKnownObjects] >= 1) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownNotes3 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfKnownObjects] >= 3) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownNotes5 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfKnownObjects] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownNotes8 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfKnownObjects] >= 8) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownNotes12 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfKnownObjects] >= 12) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredNotes1 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfMasteredObjects] >= 1) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredNotes3 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfMasteredObjects] >= 3) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredNotes5 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfMasteredObjects] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredNotes8 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfMasteredObjects] >= 8) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredNotes12 {
	if ([[[[SharedAppData sharedInstance] currentUser] notesGuideMode] numberOfMasteredObjects] >= 12) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingHours1 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeTimeSpent] >= 3600.0) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingHours5 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeTimeSpent] >= 18000.0) {
		ownsTrophy = YES;
	}
}

-(void)achievStrummingLevel2 {
	if ([[[SharedAppData sharedInstance] currentUser] strummingGuideModeLevel] >= 2) {
		ownsTrophy = YES;
	}
}

-(void)achievStrummingLevel10 {
	if ([[[SharedAppData sharedInstance] currentUser] strummingGuideModeLevel] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievStrummingLevel20 {
	if ([[[SharedAppData sharedInstance] currentUser] strummingGuideModeLevel] >= 20) {
		ownsTrophy = YES;
	}
}

-(void)achievStrummingLevel30 {
	if ([[[SharedAppData sharedInstance] currentUser] strummingGuideModeLevel] >= 30) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswers10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswers] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswers50 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswers] >= 50) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswers250 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswers] >= 250) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswers500 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswers] >= 500) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswers1000 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswers] >= 1000) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswersInRow5 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswersInRowRecord] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswersInRow10 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswersInRowRecord] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswersInRow15 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswersInRowRecord] >= 15) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswersInRow20 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswersInRowRecord] >= 10) {
		ownsTrophy = YES;
	}
}

-(void)achievGuideModeStrummingRightAnswersInRow25 {
	if ([[[[SharedAppData sharedInstance] currentUser] numericStats] strummingGuideModeNumberOfRightAnswersInRowRecord] >= 25) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownStrumming1 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfKnownObjects] >= 1) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownStrumming3 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfKnownObjects] >= 3) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownStrumming5 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfKnownObjects] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownStrumming8 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfKnownObjects] >= 8) {
		ownsTrophy = YES;
	}
}

-(void)achievKnownStrumming12 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfKnownObjects] >= 12) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredStrumming1 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfMasteredObjects] >= 1) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredStrumming3 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfMasteredObjects] >= 3) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredStrumming5 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfMasteredObjects] >= 5) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredStrumming8 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfMasteredObjects] >= 8) {
		ownsTrophy = YES;
	}
}

-(void)achievMasteredStrumming12 {
	if ([[[[SharedAppData sharedInstance] currentUser] strummingGuideMode] numberOfMasteredObjects] >= 12) {
		ownsTrophy = YES;
	}
}


@end
