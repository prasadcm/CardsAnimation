//
//  HomeViewController.m
//  CardsAnimation
//
//  Created by Prasad CM on 13/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "HomeViewController.h"
#import "Cards.h"
#import "TripInfo+CardsAnimation.h"
#import "CACommon.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

typedef void(^CALabelPreTransitionBlock)(UILabel* labelToEnter);
typedef void(^CALabelTransitionBlock)(UILabel* labelToExit, UILabel* labelToEnter);

@interface HomeViewController ()
{
    CGFloat viewWidth;
    CGFloat viewHeight;
    
    NSInteger nextViewIndex;
    
    int maxAngle;
    BOOL needSwipe;
    BOOL firstViewAnimation;
}

//Outlets
@property (weak, nonatomic) IBOutlet UIView *cardsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *temparaturLbl;
@property (weak, nonatomic) IBOutlet UILabel *countryLbl;
@property (weak, nonatomic) IBOutlet UILabel *daysToGoLbl;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImgView;

@property (strong, nonatomic) UILabel *viewCountLabel;
@property (strong, nonatomic)NSMutableArray *deckViewArray;

//Rotating animation objects
@property (strong, nonatomic) UIView *animationView;
@property (strong, nonatomic) NSArray *animateLblArray;
@property (strong, nonatomic) UILabel *currentLbl;
@property (assign, nonatomic) NSUInteger currentLblIndex;
@property (assign, nonatomic) NSTimeInterval transitionDuration;
@property (copy, nonatomic) CALabelPreTransitionBlock preTransitionBlock;
@property (copy, nonatomic) CALabelTransitionBlock transitionBlock;

//Model Object
@property (nonatomic,strong) TripInfo *tripInfo;

@end

@implementation HomeViewController

#pragma mark - View Controller Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tripInfo = [TripInfo tripInfo];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.deckViewArray = [[NSMutableArray alloc]init];
    
    //Set needSwipe to NO for autoPlay card animation
    needSwipe = YES;
    firstViewAnimation = YES;
    
    SONLog(@"%f",self.cardsContainerView.frame.size.width);
    SONLog(@"%f",self.cardsContainerView.frame.size.height);
    
    viewWidth = self.cardsContainerView.frame.size.width;
    viewHeight = self.cardsContainerView.frame.size.height;
    
    [self.cardsContainerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    [self createDeckViews:[self.tripInfo.cards count]];
    
    [self createCardCounter];
    
    if (!needSwipe) {
        [self animateFirstView:[self.tripInfo.cards count]-1];
    }
    
    [self.countryLbl setText:[NSString stringWithFormat:@"%@ now",self.tripInfo.location]];
    [self.countryLbl setAdjustsFontSizeToFitWidth:YES];
    
    NSString *temperature = [NSString stringWithFormat:@"%d%@", [self.tripInfo.temperature intValue], @"\u00B0"];
    [self.temparaturLbl setText:temperature];
    [self.temparaturLbl setAdjustsFontSizeToFitWidth:YES];
    
    [self.daysToGoLbl setText:[NSString stringWithFormat:@"%@",self.tripInfo.daysToGo]];
    [self.daysToGoLbl setAdjustsFontSizeToFitWidth:YES];
    
    [self updateWeatherInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    needSwipe = YES;
}

#pragma mark - Card Deck Methods

-(void)createDeckViews:(NSInteger)numberOfViews
{
    
    if (numberOfViews < 1) {
        return;
    }
    
    int initialDeckViewX = viewWidth*0.02;
    int initialDeckViewY = viewHeight*0.05;
    
    maxAngle = 3;
    maxAngle = maxAngle/numberOfViews;
    
    [self.deckViewArray removeAllObjects];
    
    for (int i=0; i<numberOfViews; i++)
    {
        UIImageView *deckView = [[UIImageView alloc]init];
        [deckView setFrame:CGRectMake(initialDeckViewX, initialDeckViewY, viewWidth*0.935, viewHeight*0.88)];
        
        initialDeckViewX += 15/numberOfViews;
        initialDeckViewY += 15/numberOfViews;
        
        Cards *card = self.tripInfo.cards[numberOfViews - i - 1];
        UIImage *cardImage = [UIImage imageWithContentsOfFile:card.cardUrl];
        [deckView setImage:cardImage];
        
        [self.cardsContainerView addSubview:deckView];
        
        
        if (i!=numberOfViews-1)
        {
            [self rotateViewWithAngle:maxAngle forView:deckView anIndex:i];
        }
        
        [self.deckViewArray addObject:deckView];
        
        if (needSwipe) {
            //For Swipe Gesture
            [deckView setUserInteractionEnabled:YES];
            
            UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
            [deckView addGestureRecognizer:swipeRight];
        }
    }
}

-(void)rotateViewWithAngle:(float)angle forView:(UIImageView *)view anIndex:(NSInteger)index
{
    int _angle = angle;
    //To negate the angle value for even number of views
    if (_angle % 2)
    {
        _angle = -_angle;
    }
    
    //Rotation
    double rads = DEGREES_TO_RADIANS(_angle);
    CGAffineTransform transform = CGAffineTransformRotate(view.transform, rads);
    view.transform = transform;
}

//For Swipe Gesture
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        SONLog(@"Right Swipe");
        
        if (firstViewAnimation == YES) {
            [self animateFirstView:[self.tripInfo.cards count]-1];
            firstViewAnimation = NO;
        }else
        {
            [self animateView:nextViewIndex];
        }
    }
}

-(void)animateFirstView:(NSInteger)viewCount
{
    //write code to do the first view animation
    UIImageView *tempDeckView = [self.deckViewArray objectAtIndex:viewCount];
    NSInteger __block currentIndex = viewCount;
    
    [self setText:[NSString stringWithFormat:@"%02lu",[self.tripInfo.cards count]-currentIndex+1] animated:YES];
    
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options: UIViewAnimationOptionTransitionNone
                     animations:^{
                         [tempDeckView setFrame:CGRectMake(viewWidth*0.5, 22,viewWidth*0.935, viewHeight*0.88)];
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options: UIViewAnimationOptionTransitionNone
                                          animations:^{
                                              
                                              [tempDeckView setFrame:CGRectMake(-viewWidth*0.9, viewHeight*0.05,viewWidth*0.935, viewHeight*0.88)];
                                          }completion:^(BOOL finished){
                                              [self.cardsContainerView sendSubviewToBack:tempDeckView];
                                              
                                              [UIView animateWithDuration:0.4
                                                                    delay:0.0
                                                                  options: UIViewAnimationOptionTransitionNone
                                                               animations:^{
                                                                   [tempDeckView setFrame:CGRectMake(viewWidth*0.02, viewHeight*0.05, viewWidth*0.935, viewHeight*0.88)];
                                                               }
                                                               completion:^(BOOL finished){
                                                                   if (currentIndex > 0 )
                                                                   {
                                                                       NSInteger nextViewCount = currentIndex -1;
                                                                       nextViewIndex = currentIndex-1;
                                                                       if (!needSwipe) {
                                                                           [self animateView:nextViewCount];
                                                                       }
                                                                   }
                                                                   
                                                               }];
                                          }];
                         
                     }];
}

-(void)animateView:(NSInteger)viewCount
{
    UIImageView *tempDeckView = [self.deckViewArray objectAtIndex:viewCount];
    NSInteger __block currentIndex = viewCount;
    nextViewIndex = currentIndex;
    
    if (currentIndex > 0 )
    {
        [self setText:[NSString stringWithFormat:@"%02lu",[self.tripInfo.cards count]-currentIndex+1] animated:YES];
    } else if(currentIndex == 0) {
        [self setText:@"01" animated:YES];
    }
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options: UIViewAnimationOptionTransitionNone
                     animations:^{
                         [tempDeckView setFrame:CGRectMake(viewWidth*0.95, viewHeight*0.05,viewWidth*0.935, viewHeight*0.88)];
                     }
                     completion:^(BOOL finished){
                         
                         [self.cardsContainerView sendSubviewToBack:tempDeckView];
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options: UIViewAnimationOptionTransitionNone
                                          animations:^{
                                              [tempDeckView setFrame:CGRectMake(viewWidth*0.02, viewHeight*0.05, viewWidth*0.935, viewHeight*0.88)];
                                          }completion:^(BOOL finished){
                                              
                                              if (currentIndex > 0 ) {
                                                  NSInteger nextViewCount = currentIndex -1;
                                                  nextViewIndex = currentIndex-1;
                                                  
                                                  if (!needSwipe) {
                                                      [self animateView:nextViewCount];
                                                  }
                                                  
                                              }else if (currentIndex == 0)
                                              {
                                                  //Code for Recursive call
                                                  firstViewAnimation = YES;
                                                  if (!needSwipe) {
                                                      [self animateFirstView:[self.tripInfo.cards count]-1];
                                                  }
                                              }
                                              
                                          }];
                     }];
}

#pragma mark - Weather info methods

- (void) updateWeatherInfo{
    //Setting Image According to Wether Value
    NSString *wetherImgStr = @"";
    switch ([self.tripInfo.weather intValue]) {
            
        case Summer:
            wetherImgStr = @"SunnyImage";
            break;
            
        case Winter:
            //TODO:
            break;
            
        case Rainy:
            //TODO:
            break;
            
        case Spring:
            //TODO:
            break;
            
        case Autumn:
            //TODO:
            break;
            
        default:
            break;
    }
    
    if (![wetherImgStr isEqualToString:@""]) {
        [self.weatherImgView setImage:[UIImage imageNamed:wetherImgStr]];
    }else{
        [self.weatherImgView setImage:nil];
    }
}

#pragma mark - Card counter rotation methods

-(void)createCardCounter
{
    //Adding card counter
    self.animationView = [[UIView alloc]init];
    [self.animationView setFrame:CGRectMake(viewWidth*0.45, viewHeight*0.95, 15, 20)];
    [self.animationView setBackgroundColor:[UIColor clearColor]];
    
    [self prepareTransition:self.animationView];
    [self setupEffect:0.3];
    [self setText:@"01" animated:NO];
    [self setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self setTextColor:[UIColor lightGrayColor]];
    
    [self.cardsContainerView addSubview:self.animationView];
    
    self.viewCountLabel = [[UILabel alloc]init];
    [self.viewCountLabel setFrame:CGRectMake(CGRectGetMaxX(self.animationView.frame)+3, self.animationView.frame.origin.y, 40, 20)];
    [self.viewCountLabel setText:[NSString stringWithFormat:@"of %02lu",[self.tripInfo.cards count]]];
    [self.viewCountLabel setAdjustsFontSizeToFitWidth:YES];
    [self.viewCountLabel setTextColor:[UIColor lightGrayColor]];
    [self.viewCountLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self.cardsContainerView addSubview:self.viewCountLabel];
}

-(void)prepareTransition:(UIView *)view
{
    //Preparing Transition
    CGFloat currentHeight = view.bounds.size.height;
    self.preTransitionBlock = ^(UILabel* labelToEnter) {
        
        CGRect frame = labelToEnter.frame;
        frame.origin.y = currentHeight;
        labelToEnter.frame = frame;
    };
    self.transitionBlock = ^(UILabel* labelToExit, UILabel* labelToEnter) {
        CGRect frame = labelToExit.frame;
        CGRect enterFrame = labelToEnter.frame;
        frame.origin.y = 0 - frame.size.height;
        enterFrame.origin.y = roundf((currentHeight / 2) - (enterFrame.size.height / 2));
        labelToExit.frame = frame;
        labelToEnter.frame = enterFrame;
    };
    
}

- (void)setupEffect:(NSTimeInterval)duration
{
    NSUInteger size = 2;
    NSMutableArray* labels = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < size; i++) {
        
        UILabel* label = [[UILabel alloc] initWithFrame:self.animationView.bounds];
        [self.animationView addSubview:label];
        
        label.backgroundColor = [UIColor clearColor];
        label.hidden = YES;
        label.numberOfLines = 0;
        [labels addObject:label];
    }
    
    self.currentLblIndex = 0;
    self.currentLbl = [labels objectAtIndex:0];
    self.animateLblArray = labels;
    
    self.currentLbl.hidden = NO;
    
    self.transitionDuration = duration;
}

- (void)setText:(NSString*)text animated:(BOOL)animated
{
    NSUInteger nextLabelIndex = (self.currentLblIndex + 1) % [self.animateLblArray count];
    UILabel* nextLabel = [self.animateLblArray objectAtIndex:nextLabelIndex];
    UILabel* previousLabel = self.currentLbl;
    
    nextLabel.text = text;
    nextLabel.alpha = 1;
    nextLabel.transform = CGAffineTransformIdentity;
    nextLabel.frame = self.animationView.bounds;
    
    self.currentLbl = nextLabel;
    self.currentLblIndex = nextLabelIndex;
    
    if (_preTransitionBlock != nil) {
        _preTransitionBlock(nextLabel);
    } else {
        nextLabel.alpha = 0;
    }
    
    nextLabel.hidden = NO;
    
    void (^changeBlock)() = ^() {
        if (_transitionBlock != nil) {
            _transitionBlock(previousLabel, nextLabel);
        } else {
            previousLabel.alpha = 0;
            nextLabel.alpha = 1;
        }
    };
    
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        if (finished) previousLabel.hidden = YES;
    };
    
    if (animated) {
        [UIView animateWithDuration:_transitionDuration animations:changeBlock completion:completionBlock];
    } else {
        changeBlock();
        completionBlock(YES);
    }
}

- (void)setFont:(UIFont*)font
{
    for (UILabel* label in self.animateLblArray) {
        label.font = font;
    }
}

- (void)setTextColor:(UIColor*)textColor
{
    for (UILabel* label in self.animateLblArray) {
        label.textColor = textColor;
    }
}

@end
