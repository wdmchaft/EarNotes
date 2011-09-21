//
//  CMQuizViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/09.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "CMQuizViewController.h"
#import "SharedAppData.h"
#import "QuizCreator.h"
#import "QuizStrumCreator.h"
#import "QuizStrum.h"

static NSString *kSoundImage = @"sound_image.png";

static float kButtonUnselectedAlpha = 0.3f;

@implementation CMQuizViewController

@synthesize quizCreator, currentQuestion, buttonQuestion, buttonsArray, timer, buttonTimer;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
 andCustomQuizCreator:(id)aQuizCreator {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.quizCreator = aQuizCreator;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (timer == nil) {
		Timer *t = [[Timer alloc] init];
		
		self.timer = t;
		
		[t release];
		
		[self.timer start];
	}
	
	self.title = @"Quiz";
	self.view.backgroundColor = [UIColor blueColor];
	
	[self nextQuestion: nil];
}


-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	NSTimeInterval i = [timer start];
	if (i > 0.0) {
		NumericStats *stats = [[[SharedAppData sharedInstance] currentUser] numericStats];
		
		[stats addTimeToCustomMode:i];
		
		if (currentQuestion != nil) {
			[[currentQuestion rightAnswer] stop];
		}
	}
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)playSound: (NSTimer *)theTimer {
	[[self.currentQuestion rightAnswer] play];
}

-(void)nextQuestion: (NSTimer *)theTimer {	
	UIView *newView = nil;
	
	self.currentQuestion = [quizCreator nextSimpleQuestion];
	
	if ([[currentQuestion rightAnswer] isKindOfClass:[QuizStrum class]]) {
		// Quiz diferente
		if (currentQuestion.questionType == QuestionTypeSingleSound || currentQuestion.questionType == QuestionTypeMultiSound) {
			newView = [self createStrummingQuizView:currentQuestion];
		} else {
			newView = [self createQuizView:currentQuestion];
		}
	} else {
		newView = [self createQuizView:currentQuestion];
	}
	
	if (self.currentQuestion != nil) {
		[UIView transitionFromView:self.view 
							toView:newView 
						  duration:1.0 
						   options:UIViewAnimationOptionTransitionCurlUp
						completion:nil];
	}
	
	self.view = newView;
	
	acceptEvents = YES;
	
	[NSTimer scheduledTimerWithTimeInterval:0.7f 
									 target:self 
								   selector:@selector(playSound:) 
								   userInfo:nil 
									repeats:NO];
}

-(IBAction)buttonQuestionPressed: (id)sender {
	if (currentQuestion.questionType == QuestionTypeSingleSound || currentQuestion.questionType == QuestionTypeMultiSound) {
		[[self.currentQuestion rightAnswer] play];
	}
}

-(IBAction)buttonPressed: (id)sender {
	// Apenas processar eventos se a flag for 1
	if (acceptEvents) {
		// Index do botao
		NSInteger index = [buttonsArray indexOfObject:sender]; 
		
		// Só valida nas perguntas de uma única resposta certa
		if (self.currentQuestion.questionType == QuestionTypeSingleSound) {
			if ([self.currentQuestion isAnswerRight:[self.currentQuestion.answers objectAtIndex:index]]) {
				[self markButtonWithRightSymbol: sender];
				
				[NSTimer scheduledTimerWithTimeInterval:2.0f 
												 target:self 
											   selector:@selector(nextQuestion:) 
											   userInfo:nil 
												repeats:NO];
			} else {
				// Mostrar a resposta correcta
				[self markButtonWithRightSymbol: [buttonsArray objectAtIndex:[self.currentQuestion indexOfRightAnswer]]];
				
				[self markButtonWithWrongSymbol: sender];
				
				[NSTimer scheduledTimerWithTimeInterval:2.0f 
												 target:self 
											   selector:@selector(nextQuestion:) 
											   userInfo:nil 
												repeats:NO];
			}
			
			acceptEvents = NO;
		} else if (self.currentQuestion.questionType == QuestionTypeSingleNotation) {
			if (buttonTimer != nil) {
				if (lastButton != nil) {
					if ([lastButton isEqual:sender]) {
						NSTimeInterval interval = [buttonTimer span];
						
						// Verificar se foi 'double-tap'
						if (interval >= 0.0f && interval <= 0.5) {
							if ([self.currentQuestion isAnswerRight:[self.currentQuestion.answers objectAtIndex:index]]) {
								acceptEvents = NO;
								
								[self markButtonWithRightSymbol: sender];
								
								lastButton = nil;
								
								[NSTimer scheduledTimerWithTimeInterval:2.0f 
																 target:self 
															   selector:@selector(nextQuestion:) 
															   userInfo:nil 
																repeats:NO];
								
								return;
							} else {
								acceptEvents = NO;
								
								// Mostrar a resposta correcta
								[self markButtonWithRightSymbol: [buttonsArray objectAtIndex:[self.currentQuestion indexOfRightAnswer]]];
								
								[self markButtonWithWrongSymbol: sender];
								
								lastButton = nil;
								
								[NSTimer scheduledTimerWithTimeInterval:2.0f 
																 target:self 
															   selector:@selector(nextQuestion:) 
															   userInfo:nil 
																repeats:NO];
								
								return;
							}
						} 
					}
					// Parar todos os sons antes de tocar o novo
					for (id obj in self.currentQuestion.answers) {
						[(QuizObject *)obj stop];
					}
					
					[[self.currentQuestion.answers objectAtIndex:index] play];
					
					// Começar o timer para detectar se o próximo 'tap' foi 'single' ou 'double'
					[buttonTimer start];
				} else {
					// Parar todos os sons antes de tocar o novo
					for (id obj in self.currentQuestion.answers) {
						[(QuizObject *)obj stop];
					}
					
					[[self.currentQuestion.answers objectAtIndex:index] play];
					
					// Começar o timer para detectar se o próximo 'tap' foi 'single' ou 'double'
					[buttonTimer start];
				}
				
			} else {
				Timer *t = [[Timer alloc] init];
				
				self.buttonTimer = t;
				
				[t release];
				
				// Parar todos os sons antes de tocar o novo
				for (id obj in self.currentQuestion.answers) {
					[(QuizObject *)obj stop];
				}
				
				[[self.currentQuestion.answers objectAtIndex:index] play];
				
				// Começar o timer para detectar se o próximo 'tap' foi 'single' ou 'double'
				[buttonTimer start];
			}
			
			lastButton = sender;
		} else {
			// TODO: Para multiplas opçoes
		}
	} else {
		[[self.currentQuestion rightAnswer] play];
	}
	
	
	/*[[[self view] subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
	 
	 self.currentQuestion = [quizCreator nextSimpleQuestion];
	 
	 [self createQuestionView];
	 [self createFourButtonsView: (QuizSimpleQuestion *)question];
	 */
	
}

-(IBAction)strummingButtonPressed: (id)sender {
	// Index do botao
	if ([sender alpha] < 1.0f) {
		[sender setAlpha:1.0f];
	} else {
		[sender setAlpha:kButtonUnselectedAlpha];
	}
	
}

-(IBAction)strummingOkButtonPressed: (id)sender {
	char str[8];
	
	// Parar o som de tocar
	[[[currentQuestion rightAnswer] sound] stop];
	
	const char *rightAnswerString = [[[currentQuestion rightAnswer] objectId] cStringUsingEncoding:NSASCIIStringEncoding];
	
	BOOL isAnswerRight = TRUE;
	for (int i = 0; i < 8; i++) {
		// Se alpha for melhor que 1.0 é pk o botao não esta seleccionado
		if ([[buttonsArray objectAtIndex:i] alpha] < 1.0) {
			str[i] = ' ';
		} else {
			// Sequencia é sempre DUDUDUDU logo multiplos de 2 são Downstrokes
			if (i % 2 == 0) {
				str[i] = 'D'; 
			} else {
				str[i] = 'U';
			}
		}
		
		// Marcar as respostas correctas e erradas
		if (rightAnswerString[i] == str[i]) {
			[self markButtonWithRightSymbol:[buttonsArray objectAtIndex:i]];
		} else {
			[self markButtonWithWrongSymbol:[buttonsArray objectAtIndex:i]];
			isAnswerRight = FALSE;
		}
	}
	
	[NSTimer scheduledTimerWithTimeInterval:2.0f 
									 target:self 
								   selector:@selector(nextQuestion:) 
								   userInfo:nil 
									repeats:NO];
}

-(void)markButtonWithRightSymbol: (UIButton *)button {
	CGRect box = [button frame];
	
	box.origin.x += box.size.width * 0.35;
	box.origin.y -= box.size.height * 0.25;
	box.size.width = box.size.height = box.size.width * 0.5;
	
	UIImageView *imgView = [[UIImageView alloc] initWithFrame: box];
	
	[imgView setImage:[UIImage imageNamed:@"yes.png"]];
	
	[self.view addSubview:imgView];
	
	[imgView release];
}

-(void)markButtonWithWrongSymbol: (UIButton *)button {
	CGRect box = [button frame];
	
	box.origin.x += box.size.width * 0.35;
	box.origin.y -= box.size.height * 0.25;
	box.size.width = box.size.height = box.size.width * 0.5;
	
	UIImageView *imgView = [[UIImageView alloc] initWithFrame: box];
	
	[imgView setImage:[UIImage imageNamed:@"no.png"]];
	
	[self.view addSubview:imgView];
	
	[imgView release];
}

-(UIView *)createStrummingQuizView: (QuizSimpleQuestion *)question {
	UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
	[view setBackgroundColor:[UIColor colorWithRed:0.23 green:0.49 blue:0.94 alpha:1.0]];
	
	float buttonWidth = 96.0f;
	
	CGRect buttonBox = CGRectMake((320.0f - buttonWidth) / 2.0f, 40.0f, buttonWidth, buttonWidth);
	
	UIButton *button = [[UIButton alloc] initWithFrame:buttonBox];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	// Pergunta é a resposta correcta
	QuizObject *q = [question rightAnswer];
	
	if (q != nil) {
		// Se a pergunta consistir num som então a pergunta é um som
		if (question.questionType == QuestionTypeSingleSound || question.questionType == QuestionTypeMultiSound) {
			// Como a pergunta consiste num som, carregar apena o som da pergunta
			[q loadSound];
			
			[[q sound] setLoop:YES];
			
			[button setBackgroundImage:[UIImage imageNamed:kSoundImage] 
							  forState:UIControlStateNormal];
			
			[button addTarget:self 
					   action:@selector(buttonQuestionPressed:) 
			 forControlEvents:UIControlEventTouchUpInside];
			
			[button setBackgroundColor: [UIColor clearColor]];
		} else {
			[button setTitle:[q objectId] forState:UIControlStateNormal];
			
			[button setUserInteractionEnabled:NO];
			[button setBackgroundColor: [UIColor whiteColor]];
		}
	}
	
	[view addSubview:button];
	
	// Apagar o botao da questão
	if (self.buttonQuestion != nil) {
		[buttonQuestion release];
		buttonQuestion = nil;
	}
	
	self.buttonQuestion = button;
	
	[button release];
	
	UILabel *labelMsg = [[UILabel alloc] initWithFrame:CGRectMake(0.0,170.0, 320, 70.0)];  
	labelMsg.font = [UIFont  boldSystemFontOfSize: 20]; 
	labelMsg.lineBreakMode = UILineBreakModeWordWrap;
	labelMsg.numberOfLines = 0;
	labelMsg.backgroundColor = [UIColor clearColor];  
	labelMsg.textAlignment = UITextAlignmentCenter;
	labelMsg.textColor = [UIColor whiteColor];
	labelMsg.text = [NSString stringWithString:NSLocalizedString(@"-Strumming quiz explanation-", @"")];
	[view addSubview:labelMsg];
	[labelMsg release];
	
	float confirmButtonWidth = 200.0;
	UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake((320.0 - confirmButtonWidth) / 2, 340.0, confirmButtonWidth, 50.0)];
	
	confirmButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[confirmButton setTitle:[NSString stringWithString:@"OK"] forState:UIControlStateNormal];	
	[confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:30.0];
	
	UIImage *image = [UIImage imageNamed:@"button_orange.png"];
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[confirmButton setBackgroundImage:newImage forState:UIControlStateNormal];
	
	[confirmButton addTarget:self action:@selector(strummingOkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	confirmButton.backgroundColor = [UIColor clearColor];
	
	[view addSubview:confirmButton];
	
	[confirmButton release];
	
	
	
	// Apagar os botoes se ja houver
	if (buttonsArray != nil) {
		[buttonsArray removeAllObjects];
		
		[buttonsArray release];
		buttonsArray = nil;
	} 
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	self.buttonsArray = array;
	
	[array release];
	
	NSArray *buttonsFrames = nil;
	if ([question questionType] == QuestionTypeSingleNotation || [question questionType] == QuestionTypeMultiNotation) {
		buttonsFrames = [self createButtonsFrames:[question numOfAnswers] padding:15.0];
	} else {
		buttonsFrames = [self createStrummingButtonsFrames:10.0f];
	}
	
	for (int i = 0; i < [buttonsFrames count]; i++) {
		UIButton *button = [[UIButton alloc] initWithFrame:[(NSValue *)[buttonsFrames objectAtIndex:i] CGRectValue]];
		
		button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		// Se a pergunta consistir num som então as respostas sao imagens
		if (question.questionType == QuestionTypeSingleSound || question.questionType == QuestionTypeMultiSound) {
			// Como a pergunta consiste num som, carregar apenas as imagens das respostas
			if (i % 2 == 0) {
				[button setBackgroundImage:[UIImage imageNamed:@"down.png"] 
								  forState:UIControlStateNormal];
				
				CGRect downButtonFrame = [button frame];
				
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(floor(downButtonFrame.origin.x), 
																		   floor(downButtonFrame.origin.y - downButtonFrame.size.height), 
																		   floor(downButtonFrame.size.width), 
																		   30.0)];  
				label.font = [UIFont  boldSystemFontOfSize: 30];   
				label.backgroundColor = [UIColor clearColor];  
				label.textAlignment = UITextAlignmentCenter;
				label.textColor = [UIColor whiteColor];
				label.text = [NSString stringWithFormat:@"%d", (i + 2) / 2];
				[view addSubview:label];
				[label release];
			} else {
				[button setBackgroundImage:[UIImage imageNamed:@"up.png"] 
								  forState:UIControlStateNormal];
				[button setAlpha:kButtonUnselectedAlpha];
			}
			
			[button addTarget:self action:@selector(strummingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		} else {
			// Como a pergunta consiste numa imagem, carregar apenas os sons das respostas
			[[question.answers objectAtIndex:i] loadSound];
			
			[button setBackgroundImage:[UIImage imageNamed:kSoundImage] 
							  forState:UIControlStateNormal];
			
			[button addTarget:self action:@selector(strummingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		[button setBackgroundColor: [UIColor clearColor]];
		
		[buttonsArray addObject:button];
		
		NSLog(@"Origin: (%.2f, %.2f) - Dimensions: (%.2f, %.2f)", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
		[view addSubview:button];
		
		[button release];
	}
	
	return [view autorelease];
}

-(NSArray*)createStrummingButtonsFrames: (float)thePadding {
	float borderPadding = 5.0f;
	float secondPadding = 0.0f;
	float width = (320.0f - ((borderPadding * 2.0) +  (thePadding * 3.0f) + (secondPadding *  4.0f))) / 8.0;
	float yOffset = 280.0;
	float addWidth = 2.0f;
	
	NSArray *array = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(borderPadding, yOffset, width + addWidth, width + addWidth)], 
					  [NSValue valueWithCGRect:CGRectMake(borderPadding + width + (secondPadding * 1.0), yOffset, width + addWidth, width + addWidth)],
					  [NSValue valueWithCGRect:CGRectMake(borderPadding + (width * 2.0) + (thePadding * 1.0) + (secondPadding * 1.0), yOffset, width + addWidth, width + addWidth)],
					  [NSValue valueWithCGRect:CGRectMake(borderPadding + (width * 3.0) + (thePadding * 1.0) + (secondPadding * 2.0), yOffset, width + addWidth, width + addWidth)],
					  [NSValue valueWithCGRect:CGRectMake(borderPadding + (width * 4.0) + (thePadding * 2.0) + (secondPadding * 2.0), yOffset, width + addWidth, width + addWidth)],
					  [NSValue valueWithCGRect:CGRectMake(borderPadding + (width * 5.0) + (thePadding * 2.0) + (secondPadding * 3.0), yOffset, width + addWidth, width + addWidth)],
					  [NSValue valueWithCGRect:CGRectMake(borderPadding + (width * 6.0) + (thePadding * 3.0) + (secondPadding * 3.0), yOffset, width + addWidth, width + addWidth)],
					  [NSValue valueWithCGRect:CGRectMake(borderPadding + (width * 7.0) + (thePadding * 3.0) + (secondPadding * 4.0), yOffset, width + addWidth, width + addWidth)],
					  nil];
	
	return [array autorelease];
}


-(UIView *)createQuizView: (QuizSimpleQuestion *)question {
	UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
	[view setBackgroundColor:[UIColor colorWithRed:0.23 green:0.49 blue:0.94 alpha:1.0]];
	
	float buttonWidth = 130.0f;
	
	CGRect buttonBox = CGRectMake((320.0f - buttonWidth) / 2.0f, 40.0f, buttonWidth, buttonWidth);
	
	UIButton *button = [[UIButton alloc] initWithFrame:buttonBox];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	// Pergunta é a resposta correcta
	QuizObject *q = [question rightAnswer];
	
	if (q != nil) {
		// Se a pergunta consistir num som então a pergunta é um som
		if (question.questionType == QuestionTypeSingleSound || question.questionType == QuestionTypeMultiSound) {
			// Como a pergunta consiste num som, carregar apena o som da pergunta
			[q loadSound];
			
			[button setBackgroundImage:[UIImage imageNamed:kSoundImage] 
							  forState:UIControlStateNormal];
			
			[button addTarget:self 
					   action:@selector(buttonQuestionPressed:) 
			 forControlEvents:UIControlEventTouchUpInside];
		} else {
			// Como a pergunta consiste numa imagem, carregar apenas a imagem da pergunta
			[q loadImage];
			
			[button setBackgroundImage:q.image 
							  forState:UIControlStateNormal];
			
			// Para ter a mesma aparência que uma label
			[button setUserInteractionEnabled:NO];
		}
	}
	
	[button setBackgroundColor: [UIColor clearColor]];
	
	[view addSubview:button];
	
	// Apagar o botao da questão
	if (self.buttonQuestion != nil) {
		[buttonQuestion release];
		buttonQuestion = nil;
	}
	
	self.buttonQuestion = button;
	
	[button release];
	
	// Apagar os botoes se ja houver
	if (buttonsArray != nil) {
		[buttonsArray removeAllObjects];
		
		[buttonsArray release];
		buttonsArray = nil;
	} 
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	self.buttonsArray = array;
	
	[array release];
	
	NSArray *buttonsFrames = [self createButtonsFrames:[question numOfAnswers] padding:15.0];
	for (int i = 0; i < [buttonsFrames count]; i++) {
		UIButton *button = [[UIButton alloc] initWithFrame:[(NSValue *)[buttonsFrames objectAtIndex:i] CGRectValue]];
		
		button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		// Se a pergunta consistir num som então as respostas sao imagens
		if (question.questionType == QuestionTypeSingleSound) {
			// Como a pergunta consiste num som, carregar apenas as imagens das respostas
			[[question.answers objectAtIndex:i] loadImage];
			
			[button setBackgroundImage:[UIImage imageNamed:@"button_orange_square.png"] 
							  forState:UIControlStateNormal];
			[button setImage:[[question.answers objectAtIndex:i] image] 
							  forState:UIControlStateNormal];
		} else {
			// Como a pergunta consiste numa imagem, carregar apenas os sons das respostas
			[[question.answers objectAtIndex:i] loadSound];
			
			[button setBackgroundImage:[UIImage imageNamed:kSoundImage] 
							  forState:UIControlStateNormal];
		}
		
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[button setBackgroundColor: [UIColor clearColor]];
		
		[buttonsArray addObject:button];
		
		NSLog(@"Origin: (%.2f, %.2f) - Dimensions: (%.2f, %.2f)", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
		[view addSubview:button];
		
		[button release];
	}
	
	return [view autorelease];
}

-(NSArray*)createButtonsFrames: (NSInteger)numOfButtons padding:(float)thePadding {
	float zeroX = 0.0, zeroY = 0.0, width = 0.0;
	NSArray *array = nil;
	
	const float screenWidth = 320.0;
	const float screenHeight = 240.0;
	
	zeroX = 0.0f;
	zeroY = 186.0f;
	
	if (numOfButtons == 2) {
		width = (screenHeight * (2.0 / 3.0)) - (thePadding * 2.0); 
		
		array = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(zeroX + thePadding, zeroY + (screenHeight * (1.0 / 6.0)) + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + (screenWidth / 2.0) + thePadding, zeroY + (screenHeight * (1.0 / 6.0)) + thePadding, width, width)],
				 nil];
	} else if (numOfButtons == 3) {
		width = (screenHeight / 2.0) - (thePadding * 2.0);  
		
		array = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(zeroX + 20.0 + thePadding, zeroY + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 180.0 + thePadding, zeroY + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 100.0 + thePadding, zeroY + 120.0 + thePadding, width, width)],
				 nil];
	} else if (numOfButtons == 4) {
		width = (screenHeight / 2.0) - (thePadding * 2.0);  
		
		array = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(zeroX + 20.0 + thePadding, zeroY + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 180.0 + thePadding, zeroY + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 20.0 + thePadding, zeroY + 120.0 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 180.0 + thePadding, zeroY + 120.0 + thePadding, width, width)],
				 nil];
	} else if (numOfButtons == 5) {
		width = (screenWidth / 3.0) - (thePadding * 2.0); 
		
		array = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(zeroX + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 106.7 + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 35.6 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 177.8 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 nil];
	} else if (numOfButtons == 6) {
		width = (screenWidth / 3.0) - (thePadding * 2.0); 
		
		array = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(zeroX + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 106.7 + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 106.7 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 nil];
	} else if (numOfButtons == 7) {
		width = (screenWidth / 3.0) - (thePadding * 2.0); 
		
		array = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(zeroX + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 106.7 + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 106.7 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 nil];
	} else {
		width = (screenWidth / 3.0) - (thePadding * 2.0); 
		
		array = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(zeroX + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 106.7 + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 13.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 106.7 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 [NSValue valueWithCGRect:CGRectMake(zeroX + 213.4 + thePadding, zeroY + 133.3 + thePadding, width, width)],
				 nil];
	}
	
	return [array autorelease];
}


- (void)dealloc {
	[quizCreator release];
	[currentQuestion release];
	[buttonQuestion release];
	[buttonsArray release];
	
    [super dealloc];
}


@end
