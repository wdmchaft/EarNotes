//
//  GuideModeQuizViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/24.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "GuideModeQuizViewController.h"
#import "SimpleQuizView.h"
#import "QuizCreator.h"
#import "QuizChordCreator.h"
#import "QuizNoteCreator.h"
#import "QuizStrumCreator.h"
#import "QuizSimpleQuestion.h"
#import "QuizMultipleQuestion.h"
#import "Utils.h"
#import "SharedAppData.h"
#import "NewObjectViewController.h"
#import <QuartzCore/QuartzCore.h>

#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1

static NSInteger kPadding = 5.0f;
static float kHeightMultiplier = 0.35f; 
static NSString *kSoundImage = @"sound_image.png";

static float kTimerInterval = 0.1f;

static NSDate *countdownStart;
static NSTimer *timer;
static const float kDefaultQuizTime = 20.0;

static const NSInteger kMaxPointsPerQuestion = 5;

@implementation GuideModeQuizViewController

@synthesize quizCreator, currentQuestion, currentQuestionView, buttonQuestion, buttonsArray, lblCountdown, rightAnswersInARow, wrongAnswersInARow;
@synthesize star1, star2, star3, star4, star5, lblMultiplier;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	   andQuizCreator:(id)aQuizCreator {
	
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.quizCreator = aQuizCreator;
		self.currentQuestion = nil;
		self.currentQuestionView = nil;
		self.buttonsArray = nil;
		
		quizTime = kDefaultQuizTime;
		
		timeLeft = 0;
		isCurrentQuestionNew = NO;
		
		isCountdownPaused = TRUE;
		
		rightAnswersInARow = 0;
		wrongAnswersInARow = 0;
		
		multiplier = 1.0;
		/*
		 UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
		 [self addSubview:imageView];
		 [imageView release];
		 */
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blueColor];
	
	defFrame = self.view.frame;
	
	id user = [[SharedAppData sharedInstance] currentUser];
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Lv %2d", [user chordsGuideModeLevel]]
															   style:UIBarButtonItemStylePlain
															  target:nil
															  action:nil];
	
	//[button setEnabled:NO];
	
	self.navigationItem.rightBarButtonItem = button;
	
	[button release];
	
	self.title = [NSString stringWithFormat:@"%d/%d", [user chordsGuideModeExp], [user nextChordsGuideModeLevelExp]];
	
	[self nextQuestion];
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

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:YES];
	
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


-(void)playQuestionSoundAndStartCountdown {
	Sound *sound = [[self.currentQuestion rightAnswer] sound];
	if (currentQuestion.questionType == QuestionTypeSingleSound) {
		[sound play];
	} else {
		// TODO: Implementar para varios sons
	}
	
	//[self spinLayer:buttonQuestion.layer duration:1 direction:SPIN_CLOCK_WISE];
	
	//[self scaleUpAndDown:[[buttonsArray objectAtRandomIndex] layer] duration:1.0 scale:1.5];
	
	/*
	 [UIView animateWithDuration:0.5f 
	 animations:^{
	 [[buttonQuestion layer] setOpacity:0.0f];
	 }
	 completion:^(BOOL finished) {
	 [UIView animateWithDuration:0.5f 
	 animations:^{
	 [[buttonQuestion layer] setOpacity:1.0f];
	 }
	 completion:^(BOOL finished) {
	 ;
	 }];
	 }];
	 
	 */
	
	
	[NSTimer scheduledTimerWithTimeInterval:[sound duration] - 1.0f
									 target:self 
								   selector:@selector(startCountdown) 
								   userInfo:nil 
									repeats:NO];
}

-(void)nextQuestion {	
	UIView *newView = nil;
	
	
	
	// Se a questão nao for nova, criar outra.
	if (isCurrentQuestionNew == NO) {
		if (self.currentQuestion != nil) {
			[currentQuestion release];
			currentQuestion = nil;
		}
		
		self.currentQuestion = [quizCreator nextSimpleQuestion];
	} else {
		isCurrentQuestionNew = NO;
	}
	
	
	if ([[currentQuestion rightAnswer] isQuestionNew]) {
		newView = [self createNewObjectView:[currentQuestion rightAnswer]];
		
		isCurrentQuestionNew = YES;
		
		[self enableAnswers];
	} else {
		newView = [self createQuizView:currentQuestion];
		/*
		 switch ([currentQuestion numOfAnswers]) {
		 case 2:	newView = [self createTwoButtonsView: currentQuestion];	break;
		 case 3:	newView = [self createThreeButtonsView: currentQuestion];	break;
		 case 4:	newView = [self createFourButtonsView: currentQuestion];	break;
		 case 5:	newView = [self createQuizView: currentQuestion];	break;
		 case 6:	newView = [self createSixButtonsView: currentQuestion];	break;
		 case 7:	newView = [self createSevenButtonsView: currentQuestion];	break;
		 case 8:	newView = [self createEightButtonsView: currentQuestion];	break;
		 default:	newView = [self createEightButtonsView: currentQuestion];	break;
		 }
		 */
		
		[self disableAnswers];
		
		self.lblCountdown.text = [NSString stringWithFormat:@"%2.1f", kDefaultQuizTime];
	}
	
	if (self.currentQuestion != nil) {
		[UIView transitionFromView:self.view 
							toView:newView 
						  duration:1.0 
		 //options:UIViewAnimationOptionTransitionFlipFromRight 
						   options:UIViewAnimationOptionTransitionCurlUp
						completion:nil];
	}
	
	self.view = newView;
	
	if (isCurrentQuestionNew == NO) {
		[NSTimer scheduledTimerWithTimeInterval:0.7f 
										 target:self 
									   selector:@selector(playQuestionSoundAndStartCountdown) 
									   userInfo:nil 
										repeats:NO];
	}
}

-(IBAction)buttonQuestionPressed: (id)sender {
	// Se tiver no menu 'novo objecto' passar para a proxima pergunta
	if (isCurrentQuestionNew) {
		[[currentQuestion rightAnswer] setIsQuestionNew:NO];
		
		[self nextQuestion];
	} else {
		[[[self.currentQuestion rightAnswer] sound] play];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches containsObject:[buttonsArray objectAtIndex:0]]) {
		NSLog(@"TRUE");
	} else {
		NSLog(@"FALSE");
	}
	
}

-(IBAction)buttonPressed: (id)sender {		
	if (isCurrentQuestionNew == NO) {
		[self stopCountdown];
		
		// Index do botao
		NSInteger index = [buttonsArray indexOfObject:sender]; 
		
		// Só tocar se for  uma pergunta para advinhar a notação
		if (self.currentQuestion.questionType == QuestionTypeSingleNotation || self.currentQuestion.questionType == QuestionTypeMultiNotation) {
			[[[self.currentQuestion.answers objectAtIndex:index] sound] play];
		}
		
		// Só valida nas perguntas de uma única resposta certa
		if (self.currentQuestion.questionType == QuestionTypeSingleSound || self.currentQuestion.questionType == QuestionTypeSingleNotation) {
			if ([self.currentQuestion isAnswerRight:[self.currentQuestion.answers objectAtIndex:index]]) {
				[self markButtonWithRightSymbol: sender];
				
				[self updateInternalData:YES];
			} else {
				// Mostrar a resposta correcta
				[self markButtonWithRightSymbol: [buttonsArray objectAtIndex:[self.currentQuestion indexOfRightAnswer]]];
				
				[self markButtonWithWrongSymbol: sender];
				
				[self updateInternalData:NO];
			}
			
			// Proxima pergunta
			[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextQuestion) userInfo:nil repeats:NO];
		} else {
			// TODO: Para multiplas opçoes
		}
	} else {
		[[[self.currentQuestion rightAnswer] sound] play];
	}
	
	/*[[[self view] subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
	 
	 self.currentQuestion = [quizCreator nextSimpleQuestion];
	 
	 [self createQuestionView];
	 [self createFourButtonsView: (QuizSimpleQuestion *)question];
	 */
	
}

-(void)enableAnswers {
	/*
	 for (id obj in buttonsArray) {
	 [obj setEnabled:YES];
	 }
	 */
}

-(void)disableAnswers {
	/*
	 for (id obj in buttonsArray) {
	 [obj setEnabled:NO];
	 }
	 */
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

-(void)updateInternalData: (BOOL)wasAnswersRight {
	// TODO: Incrementar counters
	// TODO: Niveis de dificuldade
	// TODO: Verificar trofeus
	id user = [[SharedAppData sharedInstance] currentUser];
	
	id rightAnswer = [currentQuestion rightAnswer];
	
	// Calcular pontos ganhos
	NSInteger points = 0;
	
	if (timeLeft >= 17.0) {
		points = 3;
	} else if (timeLeft >= 15.0) {
		points = 2;
	} else {
		points = 1;
	}
	
	
	// Normalizar
	points = points < 1 ? 1 : points;
	
	id stats = [user numericStats];
	
	// Incrementar counters
	if (wasAnswersRight) {
		// Multiplicar pelo factor estrela
		points *= multiplier;
		
		wrongAnswersInARow = 0;
		rightAnswersInARow++;
		
		switch (rightAnswersInARow) {
			case 0: multiplier = 1.0f;	break;
			case 1: multiplier = 1.0f;	break;
			case 2: multiplier = 1.5f;	break;
			case 3: multiplier = 1.5f;	break;
			case 4: multiplier = 2.0f;	break;
			case 5: multiplier = 2.0f;	break;
			case 6: multiplier = 2.5f;	break;
			case 7: multiplier = 2.5f;	break;
			case 8: multiplier = 3.0f;	break;
			case 9: multiplier = 3.0f;	break;
			case 10: multiplier = 5.0f;	break;
			default:	multiplier = 1.0f;	break;
		}
		
		UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(star1.frame.origin.x, star1.frame.origin.y, star1.frame.size.width, star1.frame.size.height)];
		newImageView.image = [UIImage imageNamed:@"star_half_full.png"];
		newImageView.layer.opacity = 0.0;
		
		[self.view addSubview:newImageView];
		
		if (rightAnswersInARow == 1) {
			[UIView animateWithDuration:1.f 
							 animations:^{
								 newImageView.layer.opacity = 1.0;
							 }
							 completion:^(BOOL finished) {
								 self.star1 = newImageView;
								 
								 [newImageView release];
							 }];
		} 
		
		
		// Update de stats
		if ([stats chordsGuideModeNumberOfRightAnswersInRowRecord] < rightAnswersInARow) {
			[stats setChordsGuideModeNumberOfRightAnswersInRowRecord:rightAnswersInARow];
		}
		
		[rightAnswer incRightAnswers];
		
		if ([quizCreator isKindOfClass:[QuizChordCreator class]]) {
			if ([[user chordsGuideMode] isFromLearningArray:rightAnswer] && ([rightAnswer rightAnswersInARow] >= 10)) {
				[[user chordsGuideMode] upgradeObject:rightAnswer];
			}
			
			if ([[user chordsGuideMode] isFromKnownArray:rightAnswer] && ([rightAnswer rightAnswersInARow] >= 20)) {
				[[user chordsGuideMode] upgradeObject:rightAnswer];
			}
		} else if ([quizCreator isKindOfClass:[QuizNoteCreator class]]) {
			
		}
		
		
		// Update de stats
		[stats incChordsGuideModeNumberOfRightAnswers];
		
		// Se aumentar de nivel, mostrar ao utilizador
		if ([user addExpToChordsGuideMode:points]) {
			//[Utils alert:[NSString stringWithFormat:@"Level UP!\r\r%d", [user chordsGuideModeLevel]]];
			
			// TODO: animaçao a dizer ke aumentou de nível
			
			self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Lv %2d", [user chordsGuideModeLevel]];
		}
		
		[quizCreator incDifficultyLevel];
	} else {
		rightAnswersInARow = 0;
		wrongAnswersInARow++;
		
		// Update de stats
		if ([stats chordsGuideModeNumberOfWrongAnswersInRowRecord] < wrongAnswersInARow) {
			[stats setChordsGuideModeNumberOfWrongAnswersInRowRecord:wrongAnswersInARow];
		}
		
		[rightAnswer incWrongAnswers];
		
		// Update de stats
		[[user numericStats] incChordsGuideModeNumberOfWrongAnswers];
		
		[quizCreator decDifficultyLevel];
		
		points = 0;
		multiplier = 1.0f;
	}
	
	self.lblMultiplier.text = [NSString stringWithFormat:@"x %.1f", multiplier];
	
	NSString *s = [NSString stringWithFormat:@"%d/%d", [user chordsGuideModeExp], [user nextChordsGuideModeLevelExp]];
	
	self.title = s;
	
	[user print];
	
	// Verificar se ganhou algum troféu
	NSMutableArray *newTrophies = [user checkTrophies];
	
	if (newTrophies != nil) {
		[Utils alert:@"NOVO TROFÉU"];
	}
}

- (void)dealloc {
	[lblCountdown release];
	[quizCreator release];
	[currentQuestion release];
	[buttonQuestion release];
	[buttonsArray release];
	[star1 release];
    [super dealloc];
}


-(void)countdownTicker {
	NSTimeInterval tmptimeleft = [countdownStart timeIntervalSinceNow];
	
	lblCountdown.text = [NSString stringWithFormat:@"%2.1f", tmptimeleft <= 0 ? 0 : tmptimeleft];
	
	if (tmptimeleft < -1) {
		// Terminar o timer
		[self stopCountdown];
		
		// TODO: Time's over
	} else {
		timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval 
												 target:self 
											   selector:@selector(countdownTicker) 
											   userInfo:nil 
												repeats:NO];
	}
}

-(void)startCountdown {
	[self enableAnswers];
	
	isCountdownPaused = NO;
	
	countdownStart =  [[NSDate alloc] initWithTimeIntervalSinceNow:quizTime];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.0f 
											 target:self 
										   selector:@selector(countdownTicker) 
										   userInfo:nil 
											repeats:NO];
}

-(void)pauseCountdown {
	isCountdownPaused = YES;
	
	// Guardar o tempo passado
	if (countdownStart != nil) {
		timeLeft = [countdownStart timeIntervalSinceNow];
		
		[countdownStart release];
		countdownStart = nil;
	}
	
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
	
	self.lblCountdown.text = [NSString stringWithFormat:@"%2.1f", timeLeft <= 0 ? 0 : timeLeft];
}

-(void)unpauseCountdown {
	isCountdownPaused = NO;
	
	countdownStart = [[NSDate alloc] initWithTimeIntervalSinceNow:timeLeft];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.0f 
											 target:self 
										   selector:@selector(countdownTicker) 
										   userInfo:nil 
											repeats:NO];	
}

-(void)stopCountdown {
	// Guardar o tempo passado
	if (countdownStart != nil) {
		timeLeft = [countdownStart timeIntervalSinceNow];
		
		[countdownStart release];
		countdownStart = nil;
	}
	
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
}


// BUTTONS IMPLEMENTATION

-(UIView *)createQuizView: (QuizSimpleQuestion *)question {
	UIView *view = [[UIView alloc] initWithFrame:defFrame];
	[view setBackgroundColor:[UIColor colorWithRed:0.23 green:0.49 blue:0.94 alpha:1.0]];
	/*
	 UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guitar.png"]];
	 [imgView setFrame: CGRectMake(imgView.frame.origin.x, imgView.frame.origin.x - 20.0f, imgView.frame.size.width, imgView.frame.size.height)];
	 [view addSubview:imgView];
	 [imgView release];
	 */
	
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
	
	// Countdown label
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(floor(buttonBox.origin.x), floor(buttonBox.origin.y + buttonBox.size.height), floor(buttonBox.size.width), 30.0)];  
	label.font = [UIFont  boldSystemFontOfSize: 30];   
	label.backgroundColor = [UIColor clearColor];  
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	self.lblCountdown = label;
	[view addSubview:label];
	[label release];
	
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
			
			[button setBackgroundImage:[[question.answers objectAtIndex:i] image] 
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
	
	// Adicionar as estrelas
	[self addHorizontalEmptyStarsToView:view];
	
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

-(void)addHorizontalEmptyStarsToView: (UIView *)theView {
	//[self addVerticalEmptyStarsToView:theView];
	//return;
	
	float width = 32;
	float padding = 3.0;
	float x = ([[UIScreen mainScreen] applicationFrame].size.width - ((width * 5) + (padding * 4))) / 2;
	float y = 5.0f;
	
	CGRect frame = CGRectMake(x, y, width, width);
	
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
	
	if (rightAnswersInARow == 0) {
		imgView.image = [UIImage imageNamed:@"star_empty.png"];
	} else if (rightAnswersInARow == 1) {
		imgView.image = [UIImage imageNamed:@"star_half_full.png"];
	} else if (rightAnswersInARow >= 2) {
		imgView.image = [UIImage imageNamed:@"star_full.png"];
	}
	
	self.star1 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	
	frame.origin.x += width + padding;
	
	imgView = [[UIImageView alloc] initWithFrame:frame];
	
	if (rightAnswersInARow <= 2) {
		imgView.image = [UIImage imageNamed:@"star_empty.png"];
	} else if (rightAnswersInARow == 3) {
		imgView.image = [UIImage imageNamed:@"star_half_full.png"];
	} else if (rightAnswersInARow >= 4) {
		imgView.image = [UIImage imageNamed:@"star_full.png"];
	}
	
	self.star2 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	
	frame.origin.x += width + padding;
	
	imgView = [[UIImageView alloc] initWithFrame:frame];
	
	if (rightAnswersInARow <= 4) {
		imgView.image = [UIImage imageNamed:@"star_empty.png"];
	} else if (rightAnswersInARow == 5) {
		imgView.image = [UIImage imageNamed:@"star_half_full.png"];
	} else if (rightAnswersInARow >= 6) {
		imgView.image = [UIImage imageNamed:@"star_full.png"];
	}
	
	self.star3 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	frame.origin.x += width + padding;
	
	imgView = [[UIImageView alloc] initWithFrame:frame];
	
	if (rightAnswersInARow <= 6) {
		imgView.image = [UIImage imageNamed:@"star_empty.png"];
	} else if (rightAnswersInARow == 7) {
		imgView.image = [UIImage imageNamed:@"star_half_full.png"];
	} else if (rightAnswersInARow >= 8) {
		imgView.image = [UIImage imageNamed:@"star_full.png"];
	}
	
	self.star4 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	frame.origin.x += width + padding;
	
	imgView = [[UIImageView alloc] initWithFrame:frame];
	
	if (rightAnswersInARow <= 8) {
		imgView.image = [UIImage imageNamed:@"star_empty.png"];
	} else if (rightAnswersInARow == 9) {
		imgView.image = [UIImage imageNamed:@"star_half_full.png"];
	} else if (rightAnswersInARow >= 10) {
		imgView.image = [UIImage imageNamed:@"star_full.png"];
	}
	
	self.star5 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	frame.origin.x += width + padding;
	
	if (self.lblMultiplier == nil) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 7.0, frame.origin.y-4.0f, 70.0, 40.0)];
		label.font = [UIFont  boldSystemFontOfSize: 22]; 
		label.backgroundColor = [UIColor clearColor];  
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		label.text = [NSString stringWithString:@"x 1.0"];
		
		self.lblMultiplier = label;
		
		[theView addSubview:label];
		
		[label release];
		label = nil;
		
	} else {
		[theView addSubview:self.lblMultiplier];
	}
	
	
}

-(void)addVerticalEmptyStarsToView: (UIView *)theView {
	float width = 32;
	float padding = 3.0;
	float x = 282.0;
	float y = 5.0f;
	
	CGRect frame = CGRectMake(x, y, width, width);
	
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
	
	imgView.image = [UIImage imageNamed:@"star_empty.png"];
	self.star1 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	
	frame.origin.y += width + padding;
	
	imgView = [[UIImageView alloc] initWithFrame:frame];
	imgView.image = [UIImage imageNamed:@"star_empty.png"];
	
	self.star2 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	
	frame.origin.y += width + padding;
	
	imgView = [[UIImageView alloc] initWithFrame:frame];
	imgView.image = [UIImage imageNamed:@"star_empty.png"];
	
	self.star3 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	frame.origin.y += width + padding;
	
	imgView = [[UIImageView alloc] initWithFrame:frame];
	imgView.image = [UIImage imageNamed:@"star_empty.png"];
	
	self.star4 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	frame.origin.y += width + padding;
	
	imgView = [[UIImageView alloc] initWithFrame:frame];
	
	imgView.image = [UIImage imageNamed:@"star_empty.png"];
	
	self.star5 = imgView;
	
	[theView addSubview:imgView];
	
	[imgView release];
	imgView = nil;
	
	frame.origin.y += width + padding;
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x - 7.0, frame.origin.y-4.0f, 50.0, 40.0)];
	label.font = [UIFont  boldSystemFontOfSize: 24]; 
	label.backgroundColor = [UIColor clearColor];  
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.text = [NSString stringWithString:@"x 1"];
	
	self.lblMultiplier = label;
	
	[theView addSubview:label];
	
	[label release];
	
	
}



-(UIView *)createNewObjectView: (QuizObject *)object {
	UIView *view = [[UIView alloc] initWithFrame:defFrame];
	
	[view setBackgroundColor:[UIColor colorWithRed:0.23 green:0.49 blue:0.94 alpha:1.0]];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(floor(view.frame.origin.x), floor(view.frame.origin.y + 7.0f), floor(view.frame.size.width), 30.0)];  
	label.font = [UIFont  boldSystemFontOfSize: 30];   
	label.backgroundColor = [UIColor clearColor];  
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.text = [NSString stringWithString:@"Novo acorde!"];
	[view addSubview:label];
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(floor(view.frame.origin.x), floor(view.frame.size.height - 100.0f), floor(view.frame.size.width), 40.0)];  
	label.font = [UIFont  boldSystemFontOfSize: 18]; 
	label.lineBreakMode = UILineBreakModeWordWrap; 
	label.numberOfLines = 0;  
	label.backgroundColor = [UIColor clearColor];  
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.text = [NSString stringWithString:@"Para voltar ao questionário,\r tocar no acorde."];
	[view addSubview:label];
	[label release];
	
	CGRect frameBox = view.frame;
	frameBox.origin.y += 64;	// Acrescentar a altura da navigation bar e status bar
	frameBox.size.height -= 64;	// Status bar (20 px) + navigation bar (44 px) = 64 px
	
	CGRect buttonBox = CGRectMake(0.0f, 00.0f, (frameBox.size.height * kHeightMultiplier), (frameBox.size.height * kHeightMultiplier));
	buttonBox.origin.x = (frameBox.size.width  / 2) - (buttonBox.size.width / 2);
	buttonBox.origin.y = 50.0f;
	
	UIButton *button = [[UIButton alloc] initWithFrame:buttonBox];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[object loadImage];
	
	[button setBackgroundImage:object.image 
					  forState:UIControlStateNormal];
	
	[button addTarget:self action:@selector(buttonQuestionPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[button setBackgroundColor: [UIColor clearColor]];
	
	if (self.buttonQuestion != nil) {
		[buttonQuestion release];
		buttonQuestion = nil;
	}
	
	self.buttonQuestion = button;
	
	[view addSubview:button];
	
	[button release];
	button = nil;
	
	frameBox = view.frame;
	frameBox.origin.y += 44;	// Acrescentar a altura da navigation bar
	frameBox.size.height -= 64;	// Status bar (20 px) + navigation bar (44 px) = 64 px
	
	CGRect mainBox = CGRectMake(0.0f, (frameBox.size.height * kHeightMultiplier), 0.0f, 0.0f);
	mainBox.size.height = mainBox.size.width = frameBox.size.height - mainBox.origin.y > frameBox.size.width ? frameBox.size.width : (frameBox.size.height - mainBox.origin.y);
	mainBox.origin.x = (frameBox.size.width - mainBox.size.width) / 2;
	mainBox.origin.y -= 35.0f;
	
	CGSize box = CGSizeMake((mainBox.size.width / 2.0) - (kPadding * 2.0), (mainBox.size.width / 2.0) - (kPadding * 2.0));
	
	CGRect boxRect = CGRectMake(mainBox.origin.x + kPadding + (box.width / 2), mainBox.origin.y + (box.height / 2) + kPadding + (box.height / 2), box.width, box.height);
	
	button = [[UIButton alloc] initWithFrame:boxRect];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[object loadSound];
	
	[button setBackgroundImage:[UIImage imageNamed:kSoundImage] 
					  forState:UIControlStateNormal];
	
	
	[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[button setBackgroundColor: [UIColor clearColor]];
	
	[view addSubview:button];
	
	// Apagar os botoes se ja houver
	if (buttonsArray != nil) {
		[buttonsArray removeAllObjects];
		
		[buttonsArray release];
		buttonsArray = nil;
	} 
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	self.buttonsArray = array;
	
	[array release];
	
	[self.buttonsArray addObject:button];
	
	[button release];
	
	return [view autorelease];
}

- (void)spinLayer:(CALayer *)inLayer 
		 duration:(CFTimeInterval)inDuration
		direction:(int)direction
{
	CABasicAnimation* rotationAnimation;
	
	// Rotate about the z axis
	rotationAnimation = 
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	
	// Rotate 360 degress, in direction specified
	rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * direction];
	
	// Perform the rotation over this many seconds
	rotationAnimation.duration = inDuration;
	
	// Set the pacing of the animation
	rotationAnimation.timingFunction = 
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	// Add animation to the layer and make it so
	[inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)scaleUpAndDown:(CALayer *)inLayer 
			 duration:(CFTimeInterval)inDuration
				scale:(float)factor {
	
	CABasicAnimation* scaleUpAnimation;
	
	// Rotate about the z axis
	scaleUpAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	
	scaleUpAnimation.toValue = [NSNumber numberWithFloat:factor];
	scaleUpAnimation.duration = inDuration;
	scaleUpAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	scaleUpAnimation.fillMode = kCAFillModeForwards; 
	scaleUpAnimation.removedOnCompletion = NO;
	scaleUpAnimation.autoreverses = YES;
	//scaleUpAnimation.delegate = self;
	
	[layerForAnimation release];
	layerForAnimation = [inLayer retain];
	
	// Add animation to the layer and make it so
	[inLayer addAnimation:scaleUpAnimation forKey:@"scaleUpAnimation"];
	
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag 
{
	if (theAnimation == [layerForAnimation animationForKey:@"scaleUpAnimation"]) {
		CABasicAnimation* scaleDownAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		scaleDownAnimation.toValue = [NSNumber numberWithFloat:1.0];
		scaleDownAnimation.duration = 0.5;
		scaleDownAnimation.fillMode = kCAFillModeForwards; 
		scaleDownAnimation.removedOnCompletion = NO;
		[layerForAnimation addAnimation:scaleDownAnimation forKey:@"scaleDownAnimation"]; 
		[layerForAnimation release];
	}
}

@end
