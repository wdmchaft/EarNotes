//
//  SettingsViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/23.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "SettingsViewController.h"
#import "SharedAppData.h"
#import "User.h"
#import "GuitarTypeViewController.h"
#import "Utils.h"


enum Sections {
    kAutoLoginSection = 0,
    kLoginSection,
    kGuitarSoundSection,
    kResetSection,
    NUM_SECTIONS
};

static NSInteger sectionRowsNumber[NUM_SECTIONS] = {
	1, 2, 1, 1
};

// for tagging our embedded controls for removal at cell recycle time
#define kViewTag				1

@implementation SettingsViewController

@synthesize switchAutoLogin, textFieldUsername, textFieldPassword, labelGuitar;

#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }
 return self;
 }
 */


#pragma mark -
#pragma mark View lifecycle


 - (void)viewDidLoad {
 [super viewDidLoad];
 
	 self.title = NSLocalizedString(@"Settings", @"");
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 }
 


 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUM_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return sectionRowsNumber[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == kLoginSection) {
		return [NSString stringWithString:NSLocalizedString(@"Account information", @"")];
	}
	
	// FIXME: Pode causar erro
	return nil;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = nil;
	
	SharedAppData *sharedAppData = [SharedAppData sharedInstance];
	
	if (indexPath.section == kAutoLoginSection) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		} 
		
		cell.textLabel.text = NSLocalizedString(@"Auto-login", @"");
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		switchAutoLogin = [self switchAutoLogin];
		[cell.contentView addSubview:switchAutoLogin];
	} else if (indexPath.section == kLoginSection) {
		if ([indexPath row] == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			} 
			
			cell.textLabel.text = NSLocalizedString(@"Name", @"");
			cell.textLabel.textAlignment = UITextAlignmentLeft;
			cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
			UITextField *textField = [self textFieldUsername];
			[cell.contentView addSubview:textField];
			
		} else {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
			cell.textLabel.text = NSLocalizedString(@"Password", @"");
			cell.textLabel.textAlignment = UITextAlignmentLeft;
			cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
			UITextField *textField = [self textFieldPassword];
			[cell.contentView addSubview:textField];
			
		}
		
	} else if (indexPath.section == kGuitarSoundSection) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		/*
		UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,260,40)];
		leftLabel.text = NSLocalizedString(@"Guitar type", @"");
		leftLabel.font = [UIFont boldSystemFontOfSize:14];
		[cell.contentView addSubview:leftLabel];
		[leftLabel release];
		*/
		
		cell.textLabel.text = NSLocalizedString(@"Guitar type", @"");
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		
		UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(160,6,110,30)];
		if ([sharedAppData numOfUsers] > 0) {
			rightLabel.text = [[sharedAppData currentUser] guitarTypeAsString];
		} else {
			rightLabel.text = [User guitarTypeToString:GuitarTypeAccoustic];
		}

		rightLabel.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
		rightLabel.textAlignment = UITextAlignmentRight;
		rightLabel.font = [UIFont systemFontOfSize:14];
		[cell.contentView addSubview:rightLabel];
		[rightLabel release];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	} else if (indexPath.section == kResetSection) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor blackColor];
			cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
			cell.textLabel.highlightedTextColor = [UIColor blackColor];
		}
		
		cell.textLabel.text = NSLocalizedString(@"Reset data", @"");
	} else {
		return nil;
	}
    
    // Configure the cell...
    
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
	
	if (indexPath.section == kResetSection) {
		[self dialogOKCancelAction];
	} else if (indexPath.section == kGuitarSoundSection) {
		UIViewController *viewController = [[GuitarTypeViewController alloc] 
											initWithNibName:@"GuitarTypeViewController" bundle:nil];
		
		[self.navigationController pushViewController:viewController animated:YES];
		
		[viewController release];
	}
	
	[tableView reloadData];
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

- (void)switchAction:(id)sender
{
	[[[SharedAppData sharedInstance] currentUser] setAutoLogin:[sender isOn]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	
	if ([textField isEqual:textFieldUsername]) {
		if ([textField.text length] > 0) {
			[[[SharedAppData sharedInstance] currentUser] setUsername:textField.text];
		} else {
			[Utils alert:@"O tamanho do nome não pode ser zero."];
			
			[textField setText:[[[SharedAppData sharedInstance] currentUser] username]];
		}
	} else if([textField isEqual:textFieldPassword]) {
		if ([textField.text length] > 0) {
			[[[SharedAppData sharedInstance] currentUser] setPassword:textField.text];
		} else {
			[Utils alert:@"O tamanho da palavra-chave não pode ser zero."];
			
			[textField setText:[[[SharedAppData sharedInstance] currentUser] password]];
		}
	}
	
	return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		[[[SharedAppData sharedInstance] currentUser] reset];
	}
	else
	{
		//NSLog(@"cancel");
	}
}

- (void)dialogOKCancelAction
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"-Reset Warning Message-", @"")
															 delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Reset data", @"") otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

- (UISwitch *)switchAutoLogin{
	if (switchAutoLogin == nil) {
		CGRect frame = CGRectMake(198.0, 8.0, 94.0, 27.0);
        switchAutoLogin = [[UISwitch alloc] initWithFrame:frame];
        [switchAutoLogin addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        switchAutoLogin.backgroundColor = [UIColor clearColor];
		[switchAutoLogin setOn:[[[SharedAppData sharedInstance] currentUser] autoLogin]];
		
		[switchAutoLogin setAccessibilityLabel:NSLocalizedString(@"StandardSwitch", @"")];
		
		switchAutoLogin.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
		
	}
	
	return switchAutoLogin;
}

- (UITextField *)textFieldUsername {
	if (textFieldUsername == nil)
	{
		CGRect frame = CGRectMake(140,12,140,20);
		textFieldUsername = [[UITextField alloc] initWithFrame:frame];
		
		textFieldUsername.borderStyle = UITextBorderStyleNone;
		textFieldUsername.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
		textFieldUsername.font = [UIFont systemFontOfSize:17.0];
		textFieldUsername.text = [[[SharedAppData sharedInstance] currentUser] username];
		textFieldUsername.backgroundColor = [UIColor whiteColor];
		textFieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		textFieldUsername.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		textFieldUsername.returnKeyType = UIReturnKeyDone;
		
		textFieldUsername.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
		textFieldUsername.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
		
		textFieldUsername.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
		
		// Add an accessibility label that describes what the text field is for.
		[textFieldUsername setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	
	return textFieldUsername;
}


- (UITextField *)textFieldPassword {
	if (textFieldPassword == nil)
	{
		CGRect frame = CGRectMake(140,12,140,20);
		textFieldPassword = [[UITextField alloc] initWithFrame:frame];
		
		textFieldPassword.borderStyle = UITextBorderStyleNone;
		textFieldPassword.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
		textFieldPassword.font = [UIFont systemFontOfSize:17.0];
		textFieldPassword.text = [[[SharedAppData sharedInstance] currentUser] password];
		textFieldPassword.backgroundColor = [UIColor whiteColor];
		textFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		textFieldPassword.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		textFieldPassword.returnKeyType = UIReturnKeyDone;
		textFieldPassword.secureTextEntry = YES;
		
		textFieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
		textFieldPassword.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
		
		textFieldPassword.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
		
		// Add an accessibility label that describes what the text field is for.
		[textFieldPassword setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	
	return textFieldPassword;
}



- (void)dealloc {
	[switchAutoLogin release];
	switchAutoLogin = nil;
	[textFieldUsername release];
	textFieldUsername = nil;
	[textFieldPassword release];
	textFieldPassword = nil;
	[labelGuitar release];
	labelGuitar = nil;
    [super dealloc];
}


@end

