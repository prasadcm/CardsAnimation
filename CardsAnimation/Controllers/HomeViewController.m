//
//  HomeViewController.m
//  CardsAnimation
//
//  Created by Prasad CM on 13/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "HomeViewController.h"
#import "Cards.h"
#import "TripInfo.h"
#import "NSManagedObject+FetchEntity.h"
#import "DBManager.h"
#import "CARotatingLabel.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface HomeViewController ()
{
    CGFloat viewWidth;
    CGFloat viewHeight;
    
    BOOL needSwipe;
    BOOL firstViewAnimation;
    
    NSInteger nextViewIndex;
//    NSArray *picArray;
    int maxAngle;
}

@property (strong, nonatomic)NSMutableArray *deckViewArray;
@property (strong, nonatomic)CARotatingLabel *currentViewCountLabel;
@property (weak, nonatomic) IBOutlet UIView *cardsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *temparaturLbl;
@property (strong, nonatomic) UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLbl;
@property (weak, nonatomic) IBOutlet UILabel *daysToGoLbl;

@property (nonatomic,strong) TripInfo *tripInfo;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSManagedObjectContext *context = [DBManager sharedDBManager].managedObjectContext;
    self.tripInfo = (TripInfo *)[NSManagedObject entity:@"TripInfo" existsInContext:context];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.deckViewArray = [[NSMutableArray alloc]init];
    
    //Set YES to stop autoPlay of Animation
    needSwipe = YES;
    firstViewAnimation = YES;
    
    NSLog(@"%f",self.cardsContainerView.frame.size.width);
    NSLog(@"%f",self.cardsContainerView.frame.size.height);
    
    viewWidth = self.cardsContainerView.frame.size.width;
    viewHeight = self.cardsContainerView.frame.size.height;
    
    [self.cardsContainerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    [self createViews:[self.tripInfo.cards count]];
    
    //    [self animateFirstView:numberOfCards-1];
    //    [self animateView:self.deckViewArray.count-1];
    
    //Adding Card Count Label
    self.currentViewCountLabel = [[CARotatingLabel alloc]initWithFrame:CGRectMake(viewWidth*0.45, viewHeight*0.95, 15, 20)];
    [self.currentViewCountLabel setText:@"01" animated:NO];
    [self.currentViewCountLabel setAdjustsFontSizeToFitWidth:YES];
    [self.currentViewCountLabel setTextColor:[UIColor lightGrayColor]];
    [self.currentViewCountLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self.currentViewCountLabel setTextAlignment:NSTextAlignmentRight];
    self.currentViewCountLabel.transitionDuration = 0.75;
    [self.cardsContainerView addSubview:self.currentViewCountLabel];
    
    self.viewCountLabel = [[UILabel alloc]init];
    [self.viewCountLabel setFrame:CGRectMake(CGRectGetMaxX(self.currentViewCountLabel.frame)+3, self.currentViewCountLabel.frame.origin.y, 40, 20)];
    [self.viewCountLabel setText:[NSString stringWithFormat:@"of %02lu",[self.tripInfo.cards count]]];
    [self.viewCountLabel setAdjustsFontSizeToFitWidth:YES];
    [self.viewCountLabel setTextColor:[UIColor lightGrayColor]];
    [self.viewCountLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self.cardsContainerView addSubview:self.viewCountLabel];
    
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
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    needSwipe = YES;
}

-(void)createViews:(NSInteger)numberOfViews
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
        //        //To negate the angle value for even number of views
        //        if (i % 2)
        //        {
        //            maxAngle = -maxAngle;
        //        }
        //
        //        //Rotation
        //        double rads = DEGREES_TO_RADIANS(maxAngle);
        //        if (i!=numberOfViews-1) {
        //            CGAffineTransform transform = CGAffineTransformRotate(deckView.transform, rads);
        //            deckView.transform = transform;
        //        }
        
        [self.deckViewArray addObject:deckView];
        
        if (needSwipe) {
            //For Swipe Gesture
            [deckView setUserInteractionEnabled:YES];
            
            UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
            [deckView addGestureRecognizer:swipeRight];
        }
    }
    
    //    if (numberOfViews !=0) {
    //        [self.cardsContainerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[picArray objectAtIndex:0]]]];
    //    }
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
        NSLog(@"Right Swipe");
        
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
                                                                   [self.currentViewCountLabel setText:[NSString stringWithFormat:@"%02lu",[self.tripInfo.cards count]-currentIndex+1] animated:YES];
                                                                   
                                                               }];
                                          }];
                         
                     }];
}

-(void)animateView:(NSInteger)viewCount
{
    UIImageView *tempDeckView = [self.deckViewArray objectAtIndex:viewCount];
    NSInteger __block currentIndex = viewCount;
    nextViewIndex = currentIndex;
    
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
                                                  [self.currentViewCountLabel setText:[NSString stringWithFormat:@"%02lu",[self.tripInfo.cards count]-currentIndex+1] animated:YES];
                                                  
                                              }else if (currentIndex == 0)
                                              {
                                                  //Code for Recursive call, comment below code if recursive not needed
                                                  firstViewAnimation = YES;
                                                  if (!needSwipe) {
                                                      [self animateFirstView:[self.tripInfo.cards count]-1];
                                                  }
                                                  //Diring Swipe
                                                  [self.currentViewCountLabel setText:@"01" animated:YES];
                                              }
                                              
                                          }];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
