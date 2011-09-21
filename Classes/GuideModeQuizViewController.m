//
//  GuideModeQuizViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/24.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "GuideModeQuizViewController.h"
#import "QuizCreator.h"
#import "QuizChordCreator.h"
#import "QuizNoteCreator.h"
#import "QuizStrumCreator.h"
#import "QuizSimpleQuestion.h"
#import "QuizMultipleQuestion.h"
#import "Utils.h"
#import "SharedAppData.h"
#import <QuartzCore/QuartzCore.h>
#import "Sound.h"

#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1

static float kButtonUnselectedAlpha = 0.3f;

static NSInteger kPadding = 5.0f;
static float kHeightMultiplier = 0.35f; 
static NSString *kSoundImage = @"sound_image.png";

static float kTimerInterval = 0.1f;

static NSDate *countdownStart;
static NSTimer *countdownTimer;
static const float kDefaultQuizTime = 20.0;

static const NSInteger kMaxPointsPerQuestion = 5;

@implementation GuideModeQuizViewController

@synthesize quizCreator, currentQuestion, currentQuestionView, buttonQuestion, buttonsArray, lblCountdown, rightAnswersInARow, wrongAnswersInARow;
@synthesize star1, star2, star3, star4, star5, lblMultiplier;
@synthesize timer, buttonTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
	   andQuizCreator:(id)aQuizCreator {
	
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.quizCreator = aQuizCreator;
		self.currentQuestion = nil;
		self.currentQuestionView = nil;
		self.buttonsArray = nil;
		self.buttonTimer = nil;
		
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
		
		acceptEvents = YES;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Começar o timer para contar o tempo passado a treinar
	if (timer == nil) {
		Timer *t = [[Timer alloc] init];
		
		self.timer = t;
		
		[t release];
		
		[self.timer start];
	}
	
	self.view.backgroundColor = [UIColor blueColor];
	
	defFrame = self.view.frame;
	
	NSInteger userLever = 0;
	
	// Level do utilizador nas respectivas areas
	if ([quizCreator isKindOfClass:[QuizChordCreator class]]) {
		userLever = [[[SharedAppData sharedInstance] currentUser] chordsGuideModeLevel];
	} else if ([quizCreator isKindOfClass:[QuizNoteCreator class]]) {
		userLever = [[[SharedAppData sharedInstance] currentUser] notesGuideModeLevel];
	} else {
		userLever = [[[SharedAppData sharedInstance] currentUser] strummingGuideModeLevel];
	}
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Lv %2d", userLever]
															   style:UIBarButtonItemStylePlain
															  target:nil
															  action:nil];
	
	//[button setEnabled:NO];
	
	self.navigationItem.rightBarButtonItem = button;
	
	[button release];
	
	// Mostra o titulo
	[self refreshTitle];
	
	// Nova pergunta
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
	[super viewDidDisappear:animated];
	
	if (countdownTimer != nil) {
		[countdownTimer invalidate];
		countdownTimer = nil;
	}
	
	NSTimeInterval i = [timer start];
	if (i > 0.0) {
		NumericStats *stats = [[[SharedAppData sharedInstance] currentUser] numericStats];
		
		// Adiciona tempo ao guide mode
		[stats addTimeToGuideMode:i];
		
		// Adiciona tempo aos respectivos contadores
		if ([quizCreator isKindOfClass:[QuizChordCreator class]]) {
			[stats addTimeToChordsGuideMode:i];
		} else if ([quizCreator isKindOfClass:[QuizNoteCreator class]]) {
			[stats addTimeToNotesGuideMide:i];
		} else if ([quizCreator isKindOfClass:[QuizStrumCreator class]]) {
			[stats addTimeToStrummingGuideMide:i];
			
			// Parar o som se tiver a tocar
			if (currentQuestion != nil) {
				[[[currentQuestion rightAnswer] sound] stop];
			}
		}
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


-(void)playQuestionSoundAndStartCountdown {
	Sound *sound = [[self.currentQuestion rightAnswer] sound];
	
	NSTimeInterval durationTillCountdownStart = 0.0;
	
	if (currentQuestion.questionType == QuestionTypeSingleSound) {
		[sound play];
		durationTillCountdownStart = [sound duration];
	} else if (currentQuestion.questionType == QuestionTypeSingleNotation) {
		// No caso de notação
		durationTillCountdownStart = ([sound duration] * 0.5f) * [currentQuestion numOfAnswers];
	} else {
		durationTillCountdownStart = [sound duration];
	}

	
	self.lblCountdown.text = [NSString stringWithFormat:@"%2.1f", kDefaultQuizTime];
	
	[NSTimer scheduledTimerWithTimeInterval:durationTillCountdownStart - 1.0f
									 target:self 
								   selector:@selector(startCountdown) 
								   userInfo:nil 
									repeats:NO];
	
	// Aceitar eventos (tipo, botoes, etc...)
	acceptEvents = YES;
}

-(void)nextQuestion {	
	UIView *newView = nil;
	
	// lastButton ja nao existe porque vai ser criada uma nova view
	if (lastButton != nil) {
		[lastButton release];
		lastButton = nil;
	}
	
	// Se a questão nao for nova, criar outra.
	if (isCurrentQuestionNew == NO) {
		if (self.currentQuestion != nil) {
			// Desalocar a memoria das imagens e sons
			[currentQuestion unloadAllResources];
			
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
		if ([quizCreator isKindOfClass:[QuizStrumCreator class]]) {
			// Quiz diferente
			if (currentQuestion.questionType == QuestionTypeSingleSound || currentQuestion.questionType == QuestionTypeMultiSound) {
				newView = [self createStrummingQuizView:currentQuestion];
			} else {
				newView = [self createQuizView:currentQuestion];
			}
		} else {
			newView = [self createQuizView:currentQuestion];
		}
		
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
	
	// Aceitar eventos tipo butões e isso a partir de agora
	acceptEvents = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(IBAction)buttonQuestionPressed: (id)sender {
	// Se tiver no menu 'novo objecto' passar para a proxima pergunta
	if (isCurrentQuestionNew) {
		[[currentQuestion rightAnswer] stop];
		
		[[currentQuestion rightAnswer] setIsQuestionNew:NO];
		
		acceptEvents = NO;
		
		[self nextQuestion];
	} else {
		[[self.currentQuestion rightAnswer] play];
	}
}

-(IBAction)buttonPressed: (id)sender {
	// Apenas processar eventos se a flag for 1
	if (acceptEvents) {
		if (isCurrentQuestionNew == NO) {
			// Index do botao
			NSInteger index = [buttonsArray indexOfObject:sender]; 
			
			// Só valida nas perguntas de uma única resposta certa
			if (self.currentQuestion.questionType == QuestionTypeSingleSound) {
				[self stopCountdown];
				
				if ([self.currentQuestion isAnswerRight:[self.currentQuestion.answers objectAtIndex:index]]) {
					[self markButtonWithRightSymbol: sender];
					
					[(QuizObject *)[currentQuestion.answers objectAtIndex:index] stop];
					
					[self processAnswer:YES];
				} else {
					// Mostrar a resposta correcta
					[self markButtonWithRightSymbol: [buttonsArray objectAtIndex:[self.currentQuestion indexOfRightAnswer]]];
					
					[self markButtonWithWrongSymbol: sender];
					
					[(QuizObject *)[currentQuestion.answers objectAtIndex:index] stop];
					
					[self processAnswer:NO];
				}
				
				acceptEvents = NO;
			} else if (self.currentQuestion.questionType == QuestionTypeSingleNotation) {
				if (buttonTimer != nil) {
					if (lastButton != nil) {
						if ([lastButton isEqual:sender]) {
							NSTimeInterval interval = [buttonTimer span];
							
							// Verificar se foi 'double-tap'
							if (interval >= 0.0f && interval <= 0.5) {
								[self stopCountdown];
								
								if ([self.currentQuestion isAnswerRight:[self.currentQuestion.answers objectAtIndex:index]]) {
									acceptEvents = NO;
									
									[self markButtonWithRightSymbol: sender];
									
									[(QuizObject *)[currentQuestion.answers objectAtIndex:index] stop];
									
									[self processAnswer:YES];
									
									lastButton = nil;
									
									return;
								} else {
									acceptEvents = NO;
									
									// Mostrar a resposta correcta
									[self markButtonWithRightSymbol: [buttonsArray objectAtIndex:[self.currentQuestion indexOfRightAnswer]]];
									
									[self markButtonWithWrongSymbol: sender];
									
									[(QuizObject *)[currentQuestion.answers objectAtIndex:index] stop];
									
									[self processAnswer:NO];
									
									lastButton = nil;
									
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
	
	[self stopCountdown];
	
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
	
	[self processAnswer:isAnswerRight];
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

-(void)processAnswer: (BOOL)wasAnswersRight {
	NSTimeInterval secondsReservedToAnimation = 0.0f;
	
	id user = [[SharedAppData sharedInstance] currentUser];
	
	id rightAnswer = [currentQuestion rightAnswer];
	
	float points = 0.0;
	
	// Coeficientes (sistema de pontuação) consoante o progresso do utilizador em relação ao objecto
	const float kDefaultCoef = 1.0f;
	const float kKnownCoef = 1.1;
	const float kLearningCoef = 1.2f;
	
	// Calcular os pontos base
	if (timeLeft >= 18.5) {
		points = 3.0;
	} else if (timeLeft >= 16.0) {
		points = 2.5;
	} else if (timeLeft >= 13.0) {
		points = 2.0;
	} else if (timeLeft >= 10.0) {
		points = 1.5;
	} else if (timeLeft >= 5.0) {
		points = 1.2;
	} else {
		points = 1.0;
	}
	
	points += [currentQuestion numOfAnswers] * 0.2;
	
	// Multiplicar por um coeficiente consoante o grau de dificuldade
	switch ([quizCreator difficultyLevel]) {
		case DifficultyLevelVeryEasy:	points *= 1.05;	break;
		case DifficultyLevelEasy:		points *= 1.1;	break;
		case DifficultyLevelNormal:		points *= 1.3;	break;
		case DifficultyLevelHard:		points *= 1.5;	break;
		case DifficultyLevelVeryHard:	points *= 1.7;	break;
		default:	points *= 1.05;	break;
			break;
	}	
	
	id stats = [user numericStats];
	
	// Incrementar counters
	if (wasAnswersRight) {
		[rightAnswer incRightAnswers];
		
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
			default:	multiplier = 5.0f;	break;
		}
		
		// TODO: Implementar a estrela, ANIMAÇÃO
		//UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(star1.frame.origin.x, star1.frame.origin.y, star1.frame.size.width, star1.frame.size.height)];
		//newImageView.image = [UIImage imageNamed:@"star_half_full.png"];
		//newImageView.layer.opacity = 0.0;
		
		//[self.view addSubview:newImageView];
		
		QuizObjectsArrays *objectsArray = nil;
		
		// Update de stats consoante o tipo de objecto
		if ([quizCreator isKindOfClass:[QuizChordCreator class]]) {
			// Update de stats
			if ([stats chordsGuideModeNumberOfRightAnswersInRowRecord] < rightAnswersInARow) {
				[stats setChordsGuideModeNumberOfRightAnswersInRowRecord:rightAnswersInARow];
			}
			
			objectsArray = [user chordsGuideMode];
			
			// Aumentar o numero de respostas certas
			[stats incChordsGuideModeNumberOfRightAnswers];
			
			// Multiplicar por um coeficiente consoante o progresso do utilizador em relação ao objecto
			if ([objectsArray isFromLearningArray:rightAnswer]) {
				points *= kLearningCoef;
			} else if ([objectsArray isFromKnownArray:rightAnswer]) {
				points *= kKnownCoef;
			} else {
				points *= kDefaultCoef;
			}
			
			// Se aumentar de nivel, mostrar ao utilizador
			if ([user addExpToChordsGuideMode:(int)(points + 0.5)]) {
				// TODO: animaçao a dizer ke aumentou de nível
				
				self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Lv %2d", [user chordsGuideModeLevel]];
			}
		} else if ([quizCreator isKindOfClass:[QuizNoteCreator class]]) {
			objectsArray = [user notesGuideMode];
			
			// Aumentar o numero de respostas certas
			[stats incNotesGuideModeNumberOfRightAnswers];
			
			// Multiplicar por um coeficiente consoante o progresso do utilizador em relação ao objecto
			if ([objectsArray isFromLearningArray:rightAnswer]) {
				points *= kLearningCoef;
			} else if ([objectsArray isFromKnownArray:rightAnswer]) {
				points *= kKnownCoef;
			} else {
				points *= kDefaultCoef;
			}
			
			// Se aumentar de nivel, mostrar ao utilizador
			if ([user addExpToNotesGuideMode:(int)(points + 0.5)]) {
				// TODO: animaçao a dizer ke aumentou de nível
				
				self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Lv %2d", [user notesGuideModeLevel]];
			}
		} else {
			objectsArray = [user strummingGuideMode];
			
			// Aumentar o numero de respostas certas
			[stats incStrummingGuideModeNumberOfRightAnswers];
			
			// Multiplicar por um coeficiente consoante o progresso do utilizador em relação ao objecto
			if ([objectsArray isFromLearningArray:rightAnswer]) {
				points *= kLearningCoef;
			} else if ([objectsArray isFromKnownArray:rightAnswer]) {
				points *= kKnownCoef;
			} else {
				points *= kDefaultCoef;
			}
			
			// Se aumentar de nivel, mostrar ao utilizador
			if ([user addExpToStrummingGuideMode:(int)(points + 0.5)]) {
				// TODO: animaçao a dizer ke aumentou de nível
				
				self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Lv %2d", [user strummingGuideModeLevel]];
			}
		}
		
		// Upgrade do objecto (para a fila de objestos aprendidos) se o user acertou 10 vezes sem falhar
		if ([objectsArray isFromLearningArray:rightAnswer] && ([rightAnswer rightAnswersInARow] >= 10)) {
			[objectsArray upgradeObject:rightAnswer];
		}
		
		// Upgrade do objecto (para a fila de objectos dominados) se o user acertou 20 vezes sem falhar
		if ([objectsArray isFromKnownArray:rightAnswer] && ([rightAnswer rightAnswersInARow] >= 20)) {
			[objectsArray upgradeObject:rightAnswer];
		}
		
		[quizCreator incDifficultyLevel];
	} else {
		[rightAnswer incWrongAnswers];
		
		rightAnswersInARow = 0;
		wrongAnswersInARow++;
		
		points = 0.0;
		multiplier = 1.0f;
		
		// Update de stats consoante o tipo de objecto
		if ([quizCreator isKindOfClass:[QuizChordCreator class]]) {
			// Update de stats
			if ([stats chordsGuideModeNumberOfWrongAnswersInRowRecord] < wrongAnswersInARow) {
				[stats setChordsGuideModeNumberOfWrongAnswersInRowRecord:wrongAnswersInARow];
			}
			
			[stats incChordsGuideModeNumberOfWrongAnswers];
		} else if ([quizCreator isKindOfClass:[QuizNoteCreator class]]) {
			// Update de stats
			if ([stats notesGuideModeNumberOfWrongAnswersInRowRecord] < wrongAnswersInARow) {
				[stats setNotesGuideModeNumberOfWrongAnswersInRowRecord:wrongAnswersInARow];
			}
			
			[stats incNotesGuideModeNumberOfWrongAnswers];
		} else {
			// Update de stats
			if ([stats strummingGuideModeNumberOfWrongAnswersInRowRecord] < wrongAnswersInARow) {
				[stats setStrummingGuideModeNumberOfWrongAnswersInRowRecord:wrongAnswersInARow];
			}
			
			[stats incStrummingGuideModeNumberOfWrongAnswers];
		}
		
		[quizCreator decDifficultyLevel];
	}
	
	// Multiplier
	self.lblMultiplier.text = [NSString stringWithFormat:@"x %.1f", multiplier];
	
	[self refreshTitle];
	
	// Mostrar os pontos ganhos
	if (points > 0.0) {
		secondsReservedToAnimation += 2.5;
		
		[self showPointsGained:(int)(points + 0.5) duration:2.5f];
	}
	
	// Verificar se ganhou algum troféu
	NSMutableArray *newTrophies = [user checkTrophies];
	
	/*
	 // Só para questoes de DEBUG
	 newTrophies = [NSMutableArray array];
	 [newTrophies addObject:[[user trophies] objectAtIndex:0.0f]];
	 */
	
	if (newTrophies != nil) {
		NSTimeInterval singleTrophyAnimationDuration = 6.0f;
		
		// So mostrar os novos trofeus depois da animação dos pontos terminar
		[NSTimer scheduledTimerWithTimeInterval:secondsReservedToAnimation
										 target:self 
									   selector:@selector(showNewTrophies:) 
									   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
												 newTrophies, 
												 @"Trophies", 
												 [NSNumber numberWithDouble:[newTrophies count] * singleTrophyAnimationDuration], 
												 @"TotalSeconds", 
												 nil] 
										repeats:NO];
		
		// Adicionar o tempo de animação dos novos troféus
		secondsReservedToAnimation += ([newTrophies count] * singleTrophyAnimationDuration);
		
		[NSTimer scheduledTimerWithTimeInterval:secondsReservedToAnimation target:self selector:@selector(nextQuestion) userInfo:nil repeats:NO];
	} else {
		[NSTimer scheduledTimerWithTimeInterval:secondsReservedToAnimation target:self selector:@selector(nextQuestion) userInfo:nil repeats:NO];
	}
}

-(void)refreshTitle {
	NSString *s = nil;
	
	id user = [[SharedAppData sharedInstance] currentUser];
	
	// Renovar o titulo
	if ([quizCreator isKindOfClass:[QuizChordCreator class]]) {
		s = [NSString stringWithFormat:@"%d/%d", [user chordsGuideModeExp], [user nextChordsGuideModeLevelExp]];
	} else if ([quizCreator isKindOfClass:[QuizNoteCreator class]]) {
		s = [NSString stringWithFormat:@"%d/%d", [user notesGuideModeExp], [user nextNotesGuideModeLevelExp]];
	} else {
		s = [NSString stringWithFormat:@"%d/%d", [user strummingGuideModeExp], [user nextStrummingGuideModeLevelExp]];
	}
	
	self.title = s;
}

- (void)dealloc {
	[lblCountdown release];
	[quizCreator release];
	[currentQuestion release];
	[buttonQuestion release];
	[buttonsArray release];
	[star1 release];
	[star2 release];
	[star3 release];
	[star4 release];
	[star5 release];
	
	[timer release];
	[buttonTimer release];
	
	[super dealloc];
}


-(void)countdownTicker {
	NSTimeInterval tmptimeleft = [countdownStart timeIntervalSinceNow];
	
	if (tmptimeleft < -1) {
		// Terminar o timer
		[self stopCountdown];
		
		// TODO: Time's over
	} else {
		lblCountdown.text = [NSString stringWithFormat:@"%2.1f", tmptimeleft <= 0 ? 0 : tmptimeleft];
		
		countdownTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval 
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
	
	countdownTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f 
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
	
	if (countdownTimer != nil) {
		[countdownTimer invalidate];
		countdownTimer = nil;
	}
	
	//self.lblCountdown.text = [NSString stringWithFormat:@"%2.1f", timeLeft <= 0 ? 0 : timeLeft];
}

-(void)unpauseCountdown {
	isCountdownPaused = NO;
	
	countdownStart = [[NSDate alloc] initWithTimeIntervalSinceNow:timeLeft];
	
	countdownTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f 
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
	
	if (countdownTimer != nil) {
		[countdownTimer invalidate];
		countdownTimer = nil;
	}
}


// BUTTONS IMPLEMENTATION

-(UIView *)createStrummingQuizView: (QuizSimpleQuestion *)question {
	UIView *view = [[UIView alloc] initWithFrame:defFrame];
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
			
			// Aumentar o speed consoante o grau de dificuldade
			switch ([quizCreator difficultyLevel]) {
				case DifficultyLevelVeryEasy:	[[q sound] setPitch:0.9];	break;
				case DifficultyLevelEasy:		[[q sound] setPitch:0.95];	break;
				case DifficultyLevelNormal:		[[q sound] setPitch:1.0];	break;
				case DifficultyLevelHard:		[[q sound] setPitch:1.05];	break;
				case DifficultyLevelVeryHard:	[[q sound] setPitch:1.1];	break;
				default:	[[q sound] setPitch:1.0];	break;
					break;
			}
			
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
	
	// Countdown label
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(floor(buttonBox.origin.x), floor(buttonBox.origin.y + buttonBox.size.height), floor(buttonBox.size.width), 30.0)];  
	label.font = [UIFont  boldSystemFontOfSize: 30];   
	label.backgroundColor = [UIColor clearColor];  
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	self.lblCountdown = label;
	[view addSubview:label];
	[label release];
	
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
	
	UIImage *image = [UIImage imageNamed:@"button74_shadow.png"];
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
	
	// Adicionar as estrelas
	[self addHorizontalEmptyStarsToView:view];
	
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
			
			[button setBackgroundImage:[UIImage imageNamed:@"button_orange_square.png"] 
							  forState:UIControlStateNormal];
			[button setImage:[[question.answers objectAtIndex:i] image] 
							  forState:UIControlStateNormal];
		} else {
			// Como a pergunta consiste numa imagem, carregar apenas os sons das respostas
			[[question.answers objectAtIndex:i] loadSound];
			
			[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"sound_%d.png", i + 1]] 
							  forState:UIControlStateNormal];
		}
		
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[button setBackgroundColor: [UIColor clearColor]];
		
		[buttonsArray addObject:button];
		
		NSLog(@"Origin: (%.2f, %.2f) - Dimensions: (%.2f, %.2f)", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
		[view addSubview:button];
		
		[button release];
	}
	
	if (question.questionType == QuestionTypeSingleNotation) {
		label = [[UILabel alloc] initWithFrame:CGRectMake(floor(view.frame.origin.x), floor(view.frame.size.height - 70.0f), floor(view.frame.size.width), 30.0)];  
		label.font = [UIFont  boldSystemFontOfSize: 14]; 
		label.lineBreakMode = UILineBreakModeWordWrap; 
		label.numberOfLines = 0;  
		label.backgroundColor = [UIColor clearColor];  
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		label.text = [NSString stringWithString:NSLocalizedString(@"-Multiple sounds explanation-", @"")];
		[view addSubview:label];
		[label release];
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
	zeroY = 170.0f;
	
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

-(void)showNewTrophies: (NSTimer *)theTimer {
	NSMutableArray *trophies = [[[theTimer userInfo]objectForKey:@"Trophies"] retain];
	
	// Para não crashar a app se trophies não conter nenhum trofeu ('impossivel' de acontecer)
	if (trophies == nil) {
		return;
	}
	
	double seconds = [[[theTimer userInfo] objectForKey:@"TotalSeconds"] doubleValue] / [trophies count]; 
	
	for (int i = 0; i < [trophies count]; i++) {
		[NSTimer scheduledTimerWithTimeInterval:i * seconds 
										 target:self 
									   selector:@selector(showNewTrophy:) 
									   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[trophies objectAtIndex:0], @"Trophy", [NSNumber numberWithDouble:seconds], @"Seconds", nil] 
										repeats:NO];
	}
	
	[trophies release];
}

-(void)showNewTrophy: (NSTimer *)theTimer {
	Trophy *trophy = [[theTimer userInfo]objectForKey:@"Trophy"];
	NSTimeInterval seconds = [[[theTimer userInfo]objectForKey:@"Seconds"] doubleValue];
	
	float yOffset = 50.0;
	
	UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 200.f, 320.0f, 100.0f)];
	container.backgroundColor = [UIColor clearColor];
	
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trophy_background.png"]];
	[imgView setFrame:CGRectMake(imgView.frame.origin.x, yOffset + imgView.frame.origin.x, imgView.frame.size.width, imgView.frame.size.height)];
	[container addSubview:imgView];
	[imgView release];
	
	imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trophyImage.png"]];
	imgView.frame = CGRectMake(7.0, yOffset + 10.0, 40.0, 40.0);
	[container addSubview:imgView];
	[imgView release];
	
	UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, yOffset + 10.0, 200, 20)];  
	lblName.font = [UIFont  boldSystemFontOfSize: 16];   
	lblName.backgroundColor = [UIColor clearColor];  
	lblName.text = [trophy name];  
	[container addSubview:lblName];
	[lblName release];
	
	UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(50, yOffset + 13.0, 190,60)];  
	lblDesc.font = [UIFont  systemFontOfSize: 12];  
	lblDesc.lineBreakMode = UILineBreakModeWordWrap; 
	lblDesc.textColor = [UIColor grayColor];
	lblDesc.numberOfLines = 0;  
	lblDesc.backgroundColor = [UIColor clearColor];  
	lblDesc.text = [trophy description];  
	[container addSubview:lblDesc];
	[lblDesc release];
	
	UILabel *lblPoints = [[UILabel alloc] initWithFrame:CGRectMake(230, yOffset + 25.0, 90, 20)];  
	lblPoints.font = [UIFont  boldSystemFontOfSize: 20];   
	lblPoints.backgroundColor = [UIColor clearColor];  
	lblPoints.textAlignment = UITextAlignmentLeft;
	lblPoints.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
	lblPoints.text = [NSString stringWithFormat:@"%2d pts", [trophy points]];  
	[container addSubview:lblPoints];
	[lblPoints release];
	
	UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, yOffset - 40, 320.0f, 85.0f)];
	lblMsg.font = [UIFont  boldSystemFontOfSize: 40];
	lblMsg.lineBreakMode = UILineBreakModeWordWrap;
	lblMsg.numberOfLines = 0;
	lblMsg.backgroundColor = [UIColor clearColor];  
	lblMsg.textAlignment = UITextAlignmentCenter;
	lblMsg.textColor = [UIColor whiteColor];
	//lblMsg.shadowColor = [UIColor grayColor];
	//lblMsg.shadowOffset = CGSizeMake(0, 1);
	lblMsg.text = [NSString stringWithString:@"Ganhou um\rnovo Troféu!"];
	[lblMsg setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
	[[lblMsg layer] setOpacity:0.0f];
	[self.view addSubview:lblMsg];
	[lblMsg release];
	
	[container.layer setOpacity:0.0f];
	
	[self.view addSubview:container];
	
	[container setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];
	[[container layer] setPosition: CGPointMake(160.0f, 360.0)];
	
	[UIView animateWithDuration:seconds * (0.7 / 5.0)
					 animations:^{
						 [[container layer] setPosition:CGPointMake(160.0f, 100.0)];
						 [[container layer] setOpacity:1.0f];
						 [container setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
						 [lblMsg setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
						 [[lblMsg layer] setOpacity:1.0f];
						 
						 [[star1 layer] setOpacity:0.0];
						 [[star2 layer] setOpacity:0.0];
						 [[star3 layer] setOpacity:0.0];
						 [[star4 layer] setOpacity:0.0];
						 [[star5 layer] setOpacity:0.0];
						 [[lblMultiplier layer] setOpacity:0.0];
						 [[buttonQuestion layer] setOpacity:0.0];
						 [[lblCountdown layer] setOpacity:0.0];
					 }
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:seconds * (3.0 / 5.0) 
										  animations:^{
											  [[container layer] setOpacity:0.9f];
											  [[lblMsg layer] setOpacity:0.9f];
										  }
										  completion:^(BOOL finished) {
											  [UIView animateWithDuration:seconds * (1.0 / 5.0)
															   animations:^{
																   [[container layer] setOpacity:0.0f];
																   [container setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];
																   
																   [[lblMsg layer] setOpacity:0.0f];
																   [lblMsg setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
																   
																   [[star1 layer] setOpacity:1.0];
																   [[star2 layer] setOpacity:1.0];
																   [[star3 layer] setOpacity:1.0];
																   [[star4 layer] setOpacity:1.0];
																   [[star5 layer] setOpacity:1.0];
																   [[lblMultiplier layer] setOpacity:1.0];
																   [[buttonQuestion layer] setOpacity:1.0];
																   [[lblCountdown layer] setOpacity:1.0];
																   
																   [lblMsg removeFromSuperview];
															   }
															   completion:^(BOOL finished) {
															   }];
										  }];
					 }];
}

-(void)showPointsGained: (NSInteger)points duration:(NSTimeInterval)seconds {
	UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0f, 320.0f, 100.0f)];
	container.backgroundColor = [UIColor clearColor];
	
	UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 60.0)];  
	lblName.font = [UIFont  boldSystemFontOfSize: 60];
	lblName.textColor = [UIColor whiteColor];
	lblName.backgroundColor = [UIColor clearColor];  
	lblName.text = [NSString stringWithFormat:@"+%d", points];  
	lblName.textAlignment = UITextAlignmentLeft;
	[container addSubview:lblName];
	[lblName release];
	
	[container.layer setOpacity:0.0f];
	
	[self.view addSubview:container];
	
	[container setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];
	[[container layer] setPosition: CGPointMake(167.0f, 100.0)];
	[UIView animateWithDuration:seconds * (1.0 / 5.0)
					 animations:^{
						 [[container layer] setPosition:CGPointMake(167.0f, 100.0)];
						 [[container layer] setOpacity:1.0f];
						 [container setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
					 }
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:seconds * (3.0 / 5.0) 
										  animations:^{
											  [[container layer] setOpacity:0.9f];
										  }
										  completion:^(BOOL finished) {
											  [UIView animateWithDuration:seconds * (1.0 / 5.0)
															   animations:^{
																   [[container layer] setOpacity:0.0f];
																   [container setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];
															   }
															   completion:^(BOOL finished) {
																   if (container != nil) {
																	   [container removeFromSuperview];
																	   [container release];
																   }	  
															   }];
										  }];
					 }];
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
	
	if ([quizCreator isKindOfClass:[QuizChordCreator class]]) {
		label.text = [NSString stringWithString:NSLocalizedString(@"New chord", @"")];
	} else if ([quizCreator isKindOfClass:[QuizNoteCreator class]]) {
		label.text = [NSString stringWithString:NSLocalizedString(@"New note", @"")];
	} else {
		label.text = [NSString stringWithString:NSLocalizedString(@"New pattern", @"")];
	}

	
	[view addSubview:label];
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(floor(view.frame.origin.x), floor(view.frame.size.height - 100.0f), floor(view.frame.size.width), 40.0)];  
	label.font = [UIFont  boldSystemFontOfSize: 18]; 
	label.lineBreakMode = UILineBreakModeWordWrap; 
	label.numberOfLines = 0;  
	label.backgroundColor = [UIColor clearColor];  
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	
	if ([quizCreator isKindOfClass:[QuizChordCreator class]]) {
		label.text = [NSString stringWithString:NSLocalizedString(@"-Chord return to previous screen explanation-", @"")];
	} else if ([quizCreator isKindOfClass:[QuizNoteCreator class]]) {
		label.text = [NSString stringWithString:NSLocalizedString(@"-Note return to previous screen explanation-", @"")];
	} else {
		label.text = [NSString stringWithString:NSLocalizedString(@"-Pattern return to previous screen explanation-", @"")];
	}
	
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
