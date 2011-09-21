//
//  MainMenuViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/07.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SettingsViewController.h"
#import "UsersViewController.h"
#import "TrophiesViewController.h"
#import "StatsViewController.h"
#import "SharedAppData.h"
#import "GuideModeQuizViewController.h"
#import "CustomModeViewController.h"
#import "QuizChordCreator.h"
#import "Timer.h"
#import <QuartzCore/QuartzCore.h>
#import "QuizStrumCreator.h"
#import "QuizNoteCreator.h"

typedef enum MainMenuSections {
	kGuideModeSection = 0,
	kCustomModeSection,
	kOthersSection,
	NUM_OF_SECTION
}MainMenuSections;


static const int numOfRowsForSection[] = {
	1, 1, 1
};

static const int kGuideModeChordsTag = 1001;
static const int kGuideModeNotesTag = 1002;
static const int kGuideModeStrummingTag = 1003;

static const int kCustomModeChordsTag = 2001;
static const int kCustomModeNotesTag = 2002;
static const int kCustomModeStrummingTag = 2003;

static const int kTrophiesTag = 3001;
static const int kStatsTag = 3002;

@implementation MainMenuViewController

@synthesize leftBarButton, rightBarButton;
@synthesize btnGuideModeChords, btnGuideModeStrumming, btnGuideModeNotes;
@synthesize btnCustomModeChords, btnCustomModeStrumming, btnCustomModeNotes;
@synthesize btnStats, btnTrophies;
@synthesize btnChordsLevel, btnNotesLevel, btnStrummingLevel;

@synthesize timer;

#pragma mark -
#pragma mark View lifecycle

/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 self.timer = [[Timer alloc] init];
 
 self.timer = t;
 
 [t release];
 }
 
 return self;
 }
 */

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (timer == nil) {
		Timer *t = [[Timer alloc] init];
		
		self.timer = t;
		
		[t release];
	}
	
	self.title = @"iEarNotes";
	isUserLoggedIn = FALSE;
	
	[self setupNavigationBar];
	
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]]; 
	//UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guitar.png"]]; 
	
	self.tableView.backgroundView = imgView;
	[imgView release];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	//self.tableView.separatorColor = [UIColor grayColor];
	self.tableView.rowHeight = 110.0;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.scrollEnabled = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	
	// Desactiva todos os botoes menos o do Utilizadores
	if (isUserLoggedIn == FALSE) {
		if (![[[SharedAppData sharedInstance] currentUser] autoLogin]) {
			[self showCustomAlert];
		} else {
			isUserLoggedIn = TRUE;
		}
		
		[self disableAll];
	}
	
	[self enableAll];
	//[[SharedAppData sharedInstance] saveData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSTimeInterval i = [timer start];
	if (i > 0.0) {
		NumericStats *stats = [[[SharedAppData sharedInstance] currentUser] numericStats];
		
		[stats addTimeToApplicationOverall:i];
	}
		
	[btnChordsLevel setTitle:[NSString stringWithFormat:@"%d", [[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel]] forState:UIControlStateNormal];
	[btnNotesLevel setTitle:[NSString stringWithFormat:@"%d", [[[SharedAppData sharedInstance] currentUser] notesGuideModeLevel]] forState:UIControlStateNormal];
	[btnStrummingLevel setTitle:[NSString stringWithFormat:@"%d", [[[SharedAppData sharedInstance] currentUser] strummingGuideModeLevel]] forState:UIControlStateNormal];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



#pragma mark -
#pragma mark Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *containerView = nil;
	UILabel *label = nil;
	
	if (section == kGuideModeSection || section == kCustomModeSection) {
		containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 30.0)];
		containerView.backgroundColor = [UIColor clearColor];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, 320.0, 30.0)];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(0, 1);
		label.font = [UIFont boldSystemFontOfSize:22.0];
		label.backgroundColor = [UIColor clearColor];
		
		if (section == kGuideModeSection) {
			label.text = [NSString stringWithString:NSLocalizedString(@"Guide mode", @"")];
		} else {
			label.text = [NSString stringWithString:NSLocalizedString(@"Custom mode", @"")];
		}
		
		
		[containerView addSubview:label];
		[label release];
		
		//tableView.tableHeaderView = containerView;
	} else {
		containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
		containerView.backgroundColor = [UIColor clearColor];
	}
	
	
	return [containerView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == kGuideModeSection || section == kCustomModeSection) {
		return 40.0f;
	} else {
		return 10.0f;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUM_OF_SECTION;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return numOfRowsForSection[section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier10 = @"Cell10";
	static NSString *CellIdentifier20 = @"Cell20";
	static NSString *CellIdentifier30 = @"Cell30";
    
    UITableViewCell *cell = nil;
	
	float padding = 30.0;
	float borderPadding = 20.0;
	float yOffset = 5.0f;
	float width = 74.0;//(320.0f - ((borderPadding * 2.0) + (padding * 2.0f))) / 3.0;
	float labelWidth = floor(width + padding);
	float labelYOffset = 40.0f;
	
	//UIImage *image = [UIImage imageNamed:@"button_orange_square.png"];
	UIImage *backgroundImage =  [UIImage imageNamed:@"button74.png"];//[image stretchableImageWithLeftCapWidth:40.0 topCapHeight:10.0];
	UIColor *backgroundColor = [UIColor clearColor];
	
	float buttonAlpha = 1.0f;
	
	if (indexPath.section == kGuideModeSection) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier10];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier30] autorelease];
			cell.backgroundColor = [UIColor clearColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			for (int i = 0; i < 3; i++) {
				UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(borderPadding + (i * padding) + (i * width), yOffset, width, width)];
				[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
				[button setBackgroundColor: backgroundColor];
				[button setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
				[button setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
				[button setAlpha:buttonAlpha];
				[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
				
				
				[cell.contentView addSubview:button];
				
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((padding - borderPadding) + (labelWidth * i) - 5.0, labelYOffset, labelWidth, labelWidth)];  
				label.lineBreakMode = UILineBreakModeWordWrap; 
				label.numberOfLines = 0;  
				label.textAlignment = UITextAlignmentCenter;
				label.textColor = [UIColor whiteColor];
				label.shadowColor = [UIColor blackColor];
				label.shadowOffset = CGSizeMake(0, 1);
				label.font = [UIFont boldSystemFontOfSize:15.0];
				label.backgroundColor = [UIColor clearColor];
				label.alpha = buttonAlpha;
				
				UIButton *buttonLevel = [[UIButton alloc] initWithFrame:CGRectMake(button.frame.origin.x + (button.frame.size.width * 0.8), button.frame.origin.y - 8, 26, 20)];
				[buttonLevel setBackgroundImage:[UIImage imageNamed:@"mini_button.png"] forState:UIControlStateNormal];
				[buttonLevel setBackgroundColor: [UIColor clearColor]];
				[buttonLevel setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
				[buttonLevel setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
				buttonLevel.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
				[buttonLevel setUserInteractionEnabled:NO];
				[buttonLevel setAlpha:1.0];
				
				if (i == 0) {
					[button setImage:[UIImage imageNamed:@"chords_button.png"] forState:UIControlStateNormal];
					//[button setImage:[UIImage imageFromImageNamed:@"button_orange_square.png" andOverlayImageNamed:@"chords_button.png"] forState:UIControlStateNormal];
					self.btnGuideModeChords = button;
					self.btnChordsLevel = buttonLevel;
					[btnChordsLevel setTitle:[NSString stringWithFormat:@"%d", [[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel]] forState:UIControlStateNormal];
					label.text = [NSString stringWithString:NSLocalizedString(@"Chords", @"")]; 
				} else if (i == 1) {
					[button setImage:[UIImage imageNamed:@"notes_button.png"] forState:UIControlStateNormal];
					self.btnGuideModeNotes = button;
					self.btnNotesLevel = buttonLevel;
					[btnNotesLevel setTitle:[NSString stringWithFormat:@"%d", [[[SharedAppData sharedInstance] currentUser] notesGuideModeLevel]] forState:UIControlStateNormal];
					label.text = [NSString stringWithString:NSLocalizedString(@"Notes", @"")]; 
				} else {
					[button setImage:[UIImage imageNamed:@"strumming_button.png"] forState:UIControlStateNormal];
					self.btnGuideModeStrumming = button;
					label.text = [NSString stringWithString:NSLocalizedString(@"Strummingrpatterns", @"")]; 
					self.btnStrummingLevel = buttonLevel;
					[btnStrummingLevel setTitle:[NSString stringWithFormat:@"%d", [[[SharedAppData sharedInstance] currentUser] strummingGuideModeLevel]] forState:UIControlStateNormal];
					label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y + 5.0f, labelWidth, labelWidth);
				}
				
				[cell.contentView addSubview:label];
				[label release];
				[button release];
				
				[cell.contentView addSubview:buttonLevel];
				[buttonLevel release];
			}
		}
	} else if (indexPath.section == kCustomModeSection) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier20];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier30] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.backgroundColor = [UIColor clearColor];
			
			for (int i = 0; i < 3; i++) {
				UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(borderPadding + (i * padding) + (i * width), yOffset, width, width)];
				
				[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
				[button setBackgroundColor: backgroundColor];
				[button setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
				[button setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
				[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
				
				[cell.contentView addSubview:button];
				
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((padding - borderPadding) + (labelWidth * i) - 5.0, labelYOffset, labelWidth, labelWidth)];  
				label.lineBreakMode = UILineBreakModeWordWrap; 
				label.numberOfLines = 0;  
				label.textAlignment = UITextAlignmentCenter;
				label.textColor = [UIColor whiteColor];
				label.shadowColor = [UIColor blackColor];
				label.shadowOffset = CGSizeMake(0, 1);
				label.font = [UIFont boldSystemFontOfSize:15.0];
				label.backgroundColor = [UIColor clearColor];
				
				if (i == 0) {
					[button setImage:[UIImage imageNamed:@"chords_button.png"] forState:UIControlStateNormal];
					self.btnCustomModeChords = button;
					label.text = [NSString stringWithString:NSLocalizedString(@"Chords", @"")]; 
				} else if (i == 1) {
					[button setImage:[UIImage imageNamed:@"notes_button.png"] forState:UIControlStateNormal];
					self.btnCustomModeNotes = button;
					label.text = [NSString stringWithString:NSLocalizedString(@"Notes", @"")]; 
				} else {
					[button setImage:[UIImage imageNamed:@"strumming_button.png"] forState:UIControlStateNormal];
					self.btnCustomModeStrumming = button;
					label.text = [NSString stringWithString:NSLocalizedString(@"Strummingrpatterns", @"")]; 
					label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y + 3.0f, labelWidth, labelWidth);
				}
				
				
				[cell.contentView addSubview:label];
				[label release];
				[button release];
			}
		}
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier30];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier30] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.backgroundColor = [UIColor clearColor];
			
			padding = (320.0 - (width * 2.0)) / 3.0f;
			labelWidth = floor(width + padding);
			labelYOffset = 25.0f;
			
			for (int i = 0; i < 2; i++) {
				UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(((i + 1) * padding) + (i * width), yOffset, width, width)];
				
				[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
				[button setBackgroundColor: backgroundColor];
				[button setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
				[button setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
				[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
				
				[cell.contentView addSubview:button];
				
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i == 0 ? (padding / 2.0) : 160.0f, labelYOffset, labelWidth, labelWidth)];  
				label.textAlignment = UITextAlignmentCenter;
				label.textColor = [UIColor whiteColor];
				label.shadowColor = [UIColor blackColor];
				label.shadowOffset = CGSizeMake(0, 1);
				label.font = [UIFont boldSystemFontOfSize:15.0];
				label.backgroundColor = [UIColor clearColor];
				
				if (i == 0) {
					[button setImage:[UIImage imageNamed:@"trophies_button.png"] forState:UIControlStateNormal];
					self.btnTrophies = button;
					label.text = [NSString stringWithString:NSLocalizedString(@"Trophies", @"")]; 
				} else {
					[button setImage:[UIImage imageNamed:@"stats_button.png"] forState:UIControlStateNormal];
					self.btnStats = button;
					label.text = [NSString stringWithString:NSLocalizedString(@"Stats", @"")]; 
				}
				
				
				[cell.contentView addSubview:label];
				[label release];
				[button release];
			}
		}
	}
	
	
	
	return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}

-(IBAction)barButtonPressed: (id)sender {
	NSLog(@"barButtonPressed() from sender '%@'", sender);
	
	if ([sender isEqual:self.leftBarButton]) {
		UIViewController *targetViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
		
		[self.navigationController pushViewController:targetViewController animated:TRUE];
		
		[targetViewController release];
	} else if ([sender isEqual:self.rightBarButton]) {
		UIViewController *targetViewController = [[UsersViewController alloc] initWithNibName:@"UsersViewController" bundle:nil];
		
		[self.navigationController pushViewController:targetViewController animated:TRUE];
		
		[targetViewController release];
	}
}

-(void)buttonPressed: (id)sender {
	NSLog(@"buttonPressed() from sender '%@'", sender);
	
	id viewController = nil;
	
	if ([sender isEqual:self.btnGuideModeChords]) {
		viewController = [[GuideModeQuizViewController alloc] initWithNibName:@"GuideModeQuizViewController" 
																	   bundle:nil 
															   andQuizCreator:[[[QuizChordCreator alloc] init] autorelease]];
	} else if ([sender isEqual:self.btnGuideModeNotes]) {
		viewController = [[GuideModeQuizViewController alloc] initWithNibName:@"GuideModeQuizViewController" 
																	   bundle:nil 
															   andQuizCreator:[[[QuizNoteCreator alloc] init] autorelease]];
	} else if ([sender isEqual:self.btnGuideModeStrumming]) {
		viewController = [[GuideModeQuizViewController alloc] initWithNibName:@"GuideModeQuizViewController"
																	   bundle:nil 
															   andQuizCreator:[[[QuizStrumCreator alloc] init] autorelease]];
	} else if ([sender isEqual:self.btnCustomModeChords]) {
		viewController = [[CustomModeViewController alloc] initWithNibName:@"CustomModeViewController" bundle:nil andQuizObjectType:0];
	} else if ([sender isEqual:self.btnCustomModeNotes]) {
		viewController = [[CustomModeViewController alloc] initWithNibName:@"CustomModeViewController" bundle:nil andQuizObjectType:1];
	} else if ([sender isEqual:self.btnCustomModeStrumming]) {
		viewController = [[CustomModeViewController alloc] initWithNibName:@"CustomModeViewController" bundle:nil andQuizObjectType:2];
	} else if ([sender isEqual:self.btnStats]) {
		viewController = [[StatsViewController alloc] initWithNibName:@"StatsViewController" 
															   bundle:[NSBundle mainBundle]];
		
	} else if ([sender isEqual:self.btnTrophies]) {
		viewController = [[TrophiesViewController alloc] initWithNibName:@"TrophiesViewController" 
																  bundle:[NSBundle mainBundle]];
	}
	
	if (viewController != nil) {
		[self.navigationController pushViewController:viewController animated:TRUE];
		
		[viewController release];
	}
	
}

-(void)setupNavigationBar {
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] 
														  style:UIBarButtonItemStylePlain 
														 target:self 
														 action:@selector(barButtonPressed:)];
	
	self.rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_users.png"] 
														   style:UIBarButtonItemStylePlain 
														  target:self 
														  action:@selector(barButtonPressed:)];
	
	self.navigationItem.leftBarButtonItem = leftBarButton;
	self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (IBAction)showCustomAlert
{
	NSString* s =[NSString stringWithFormat:@"%@", [[[SharedAppData sharedInstance] currentUser] username]];
	CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:s];
	alert.delegate = self;
	[alert show];
	[alert release];
}
- (void) CustomAlertView:(CustomAlertView *)alert wasDismissedWithValue:(NSString *)value
{
	NSLog(@"%@", [NSString stringWithFormat:@"'%@' was entered", value]);
	
	if ([[[SharedAppData sharedInstance] currentUser] isPasswordCorrect:value]) {
		isUserLoggedIn = TRUE;
		[self enableAll];
		
		UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Autenticação realizada com sucesso!" 
														   message:nil
														  delegate:self 
												 cancelButtonTitle:@"OK" 
												 otherButtonTitles:nil];
		[newAlert show];
		[newAlert release];
	} else {
		isUserLoggedIn = FALSE;
		[self disableAll];
		
		UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Palavra-chave errada." 
														   message:@"Deseja inserir novamente a palavra-chave?"
														  delegate:self 
												 cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
												 otherButtonTitles:@"Sim", nil];
		[newAlert setTag:2000];
		[newAlert show];
		[newAlert release];
	}
	
}
- (void) customAlertViewWasCancelled:(CustomAlertView *)alert
{
	NSLog(@"%@", NSLocalizedString(@"User cancelled alert", @"User cancelled alert"));
	//feedbackLabel.text = NSLocalizedString(@"User cancelled alert", @"User cancelled alert");
	
	UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Alerta" 
													   message:@"Não pode aceder a nenhuma funcionalidade, além do menu de utilizadores, se não estiver autenticado.\rDeseja se autenticar?" 
													  delegate:self 
											 cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
											 otherButtonTitles:@"Sim", nil];
	[newAlert setTag:1000];
	[newAlert show];
	[newAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 1000) {
		// Se pressionar OK, mostrar outra vez o ecra de login
		if (buttonIndex == 1) {
			[self showCustomAlert];
		} else {
			[self disableAll];
		}
		
	} else if (alertView.tag == 2000) {
		if (buttonIndex == 1) {
			[self showCustomAlert];
		} else {
			[self disableAll];
		}
		
	}
}

-(void)enableAll {
	[leftBarButton setEnabled:YES];
	[rightBarButton setEnabled:YES];
	
	[btnGuideModeChords setEnabled:YES];
	[btnGuideModeStrumming setEnabled:YES];
	[btnGuideModeNotes setEnabled:YES];
	[btnCustomModeChords setEnabled:YES];
	[btnCustomModeStrumming setEnabled:YES];
	[btnCustomModeNotes setEnabled:YES];
	[btnStats setEnabled:YES];
	[btnTrophies setEnabled:YES];
	
	[btnChordsLevel setEnabled:YES];
	[btnNotesLevel setEnabled:YES];
	[btnStrummingLevel setEnabled:YES];
}

-(void)disableAll {
	[leftBarButton setEnabled:NO];
	[rightBarButton setEnabled:YES];
	
	[btnGuideModeChords setEnabled:NO];
	[btnGuideModeStrumming setEnabled:NO];
	[btnGuideModeNotes setEnabled:NO];
	[btnCustomModeChords setEnabled:NO];
	[btnCustomModeStrumming setEnabled:NO];
	[btnCustomModeNotes setEnabled:NO];
	[btnStats setEnabled:NO];
	[btnTrophies setEnabled:NO];
	
	[btnChordsLevel setEnabled:NO];
	[btnNotesLevel setEnabled:NO];
	[btnStrummingLevel setEnabled:NO];
}

- (void)dealloc {
	[leftBarButton release];
	[rightBarButton release];
	
	[btnGuideModeChords release];
	[btnGuideModeStrumming release];
	[btnGuideModeNotes release];
	[btnCustomModeChords release];
	[btnCustomModeStrumming release];
	[btnCustomModeNotes release];
	[btnStats release];
	[btnTrophies release];
	
	[btnChordsLevel release];
	[btnNotesLevel release];
	[btnStrummingLevel release];
	
	[timer release];
	
	[super dealloc];
}


@end

