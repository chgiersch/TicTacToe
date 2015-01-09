//
//  PlayViewController.m
//  TicTacToe
//
//  Created by Chris Giersch on 1/8/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *a1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *a2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *a3ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *b1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *b2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *b3ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *c1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *c2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *c3ImageView;

@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;

@property NSArray *imagesArray;
@property BOOL isXPlayersTurn;
@property NSMutableSet *playerXSet;
@property NSMutableSet *playerYSet;

@property NSMutableSet *winningIndexCombinations;
@property NSSet *win1;
@property NSSet *win2;
@property NSSet *win3;
@property NSSet *win4;
@property NSSet *win5;
@property NSSet *win6;
@property NSSet *win7;
@property NSSet *win8;

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create array of all ImageView objects
    self.imagesArray = [[NSArray alloc] initWithObjects:self.a1ImageView, self.a2ImageView, self.a3ImageView, self.b1ImageView, self.b2ImageView, self.b3ImageView, self.c1ImageView, self.c2ImageView, self.c3ImageView, nil];
    // Set first player to X
    self.isXPlayersTurn = TRUE;

    // Set up winning combinations of ImageView.index sets
    self.win1 = [self.win1 initWithObjects:@1, @2, @3, nil];
    [self.win2 initWithObjects:@4, @5, @6, nil];
    [self.win3 initWithObjects:@7, @8, @9, nil];
    [self.win4 initWithObjects:@1, @4, @7, nil];
    [self.win5 initWithObjects:@2, @5, @8, nil];
    [self.win6 initWithObjects:@3, @6, @9, nil];
    [self.win7 initWithObjects:@1, @5, @9, nil];
    [self.win8 initWithObjects:@3, @5, @7, nil];
    [self.winningIndexCombinations initWithObjects: self.win2, self.win3, self.win4, self.win5, self.win6, self.win7, self.win8, nil];
    self.playerXSet = [[NSMutableSet alloc] init];
    self.playerYSet = [[NSMutableSet alloc] init];
}


// Sets that imageView's image to X or an O depending on the current player
- (IBAction)onImageViewTapped:(UITapGestureRecognizer *)gesture
{
    // Get touch point
    CGPoint touchPoint = [gesture locationInView:self.view];
    // Get the image touched
    UIImageView *imageViewTouched = [self findImageViewUsingPoint:touchPoint];
    //Set the image to X or O depending on which player's turn
    if (self.isXPlayersTurn)
    {
        imageViewTouched.image = [UIImage imageNamed:@"X"];

        self.isXPlayersTurn = FALSE;
    }
    else
    {
        imageViewTouched.image = [UIImage imageNamed:@"O"];
        self.isXPlayersTurn = TRUE;
    }

    // Check to see if a player has won the game
    if ([self hasPlayerWonGame]) {
        self.gameOverLabel.text = [self playerWon];
    }
}


// Finds the imageView that was tapped
- (UIImageView *)findImageViewUsingPoint:(CGPoint)point
{
    //UIImageView *identifier = [UIImageView new];
    for (UIImageView *imageView in self.imagesArray)
    {
        if (CGRectContainsPoint(imageView.frame, point))
        {
            //identifier = imageView;
            return imageView;
        }
    }
    return nil;
}

- (BOOL)hasPlayerWonGame
{
    for (NSArray *array in self.winningIndexCombinations)
    {
        if ([self isThreeInARowEqual: array[0] :array[1] :array[2]])
        {
            return TRUE;
        }
    }
    return FALSE;
}

- (BOOL)isThreeInARowEqual:(NSNumber *)one :(NSNumber *)two :(NSNumber *)three
{
    UIImageView *imageView1 = (UIImageView *)[self.view viewWithTag:one.intValue];
    UIImageView *imageView2 = (UIImageView *)[self.view viewWithTag:two.intValue];
    UIImageView *imageView3 = (UIImageView *)[self.view viewWithTag:three.intValue];
    if (imageView1.image  == imageView2.image && imageView2.image == imageView3.image)
    {
        return TRUE;
    }
    return FALSE;
}

- (NSString *)playerWon
{

    return @"Player __ wins!";
}












@end
