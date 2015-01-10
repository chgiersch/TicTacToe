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

@property NSMutableSet *winningIndexCombinations;
@property NSSet *win1;
@property NSSet *win2;
@property NSSet *win3;
@property NSSet *win4;
@property NSSet *win5;
@property NSSet *win6;
@property NSSet *win7;
@property NSSet *win8;
@property NSMutableSet *playerXSet;
@property NSMutableSet *playerYSet;

@property NSArray *imagesArray;
@property BOOL isXPlayersTurn;
@property UIGestureRecognizer *gestureRecognizer;

@end


@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create set of all winning sets
    [self createWinningSets];
    // Create set to hold respective player move choices
    self.playerXSet = [[NSMutableSet alloc] init];
    self.playerYSet = [[NSMutableSet alloc] init];
    // Create array of all ImageView objects
    self.imagesArray = [[NSArray alloc] initWithObjects:self.a1ImageView, self.a2ImageView, self.a3ImageView, self.b1ImageView, self.b2ImageView, self.b3ImageView, self.c1ImageView, self.c2ImageView, self.c3ImageView, nil];

    // Set first player
    if ([self isCurrentPlayerX]) {
        self.isXPlayersTurn = TRUE;
    }
    else
    {
        self.isXPlayersTurn = FALSE;
    }
    [self setCurrentPlayerLabel];
}


// Sets that imageView's image to X or an O depending on the current player
- (IBAction)onImageViewTapped:(UITapGestureRecognizer *)gesture
{
    self.gestureRecognizer = gesture;
    // Get touch point
    CGPoint touchPoint = [gesture locationInView:self.view];
    // Get the image touched
    UIImageView *imageViewTouched = [self findImageViewUsingPoint:touchPoint];

    if (imageViewTouched != nil && imageViewTouched.image == nil) {
        // Change image to X or O
        imageViewTouched.image = [UIImage imageNamed:self.currentPlayer];

        if (![self isCurrentPlayerX])
        {
            // Player X turn
            [self.playerXSet addObject: [NSString stringWithFormat:@"%ld", (long)imageViewTouched.tag]];
            if([self hasPlayerWonGame:self.playerXSet])
            {
                self.gameOverLabel.text = @"Player X won!!!";
                gesture.enabled = FALSE;
            };
        }
        else
        {
            // Player Y turn
            [self.playerYSet addObject: [NSString stringWithFormat:@"%ld", (long)imageViewTouched.tag]];
            if([self hasPlayerWonGame:self.playerYSet])
            {
                self.gameOverLabel.text = @"Player O won!!!";
                gesture.enabled = FALSE;
            };
            [self hasPlayerWonGame:self.playerYSet];
        }
        [self switchCurrentPlayer];

        //Check for a tie
        [self checkFotTie];

        
    }
}
- (IBAction)onResetButtonPressed:(UIButton *)sender
{

    // Clear board (clear all image views)
    for (UIImageView *imageView in self.imagesArray)
    {
        imageView.image = nil;
    }
    // Disable gestures so no more plays can be made
    self.gestureRecognizer.enabled = TRUE;
    // Clear player sets
    [self.playerXSet removeAllObjects];
    [self.playerYSet removeAllObjects];
}

// Finds the imageView that was tapped
- (UIImageView *)findImageViewUsingPoint:(CGPoint)point
{
    //UIImageView *identifier = [UIImageView new];
    for (UIImageView *imageView in self.imagesArray)
    {
        if (CGRectContainsPoint(imageView.frame, point) && imageView.image == nil)
        {
            //identifier = imageView;
            return imageView;
        }
    }
    return nil;
}

- (BOOL)hasPlayerWonGame:(NSSet *)playerSet
{
    // Compare if players chosen plays matches any of the winning combinations
    for (NSSet *set in self.winningIndexCombinations)
    {
        if ([set isSubsetOfSet:playerSet])
        {
            return TRUE;
            
        }
    }
    return FALSE;
}

- (BOOL)isCurrentPlayerX
{
    if ([self.currentPlayer  isEqual: @"X"])
    {
        return TRUE;
    }
    return FALSE;
}

- (void)switchCurrentPlayer
{
    if ([self.currentPlayer isEqualToString:@"X"]) {
        self.currentPlayer = @"O";
    }
    else if ([self.currentPlayer isEqualToString:@"O"])
    {
        self.currentPlayer = @"X";
    }
    [self setCurrentPlayerLabel];
}

- (void)setCurrentPlayerLabel
{
    self.whichPlayerLabel.text = [NSString stringWithFormat:@"It's your turn, %@.", self.currentPlayer];
}


- (void)checkFotTie
{
    // Check for a tie
    if (self.playerXSet.count == 5 || self.playerYSet.count == 5)
    {
        self.gameOverLabel.text = @"Its a TIE!";
    }
}

- (void)createWinningSets
{
    // Set up sets of winning combinations
    self.win1 = [[NSSet alloc] initWithObjects:@"1", @"2", @"3", nil];
    self.win2 = [[NSSet alloc] initWithObjects:@"4", @"5", @"6", nil];
    self.win3 = [[NSSet alloc] initWithObjects:@"7", @"8", @"9", nil];
    self.win4 = [[NSSet alloc] initWithObjects:@"1", @"4", @"7", nil];
    self.win5 = [[NSSet alloc] initWithObjects:@"2", @"5", @"8", nil];
    self.win6 = [[NSSet alloc] initWithObjects:@"3", @"6", @"9", nil];
    self.win7 = [[NSSet alloc] initWithObjects:@"1", @"5", @"9", nil];
    self.win8 = [[NSSet alloc] initWithObjects:@"3", @"5", @"7", nil];
    self.winningIndexCombinations = [[NSMutableSet alloc] initWithObjects: self.win2, self.win3, self.win4, self.win5, self.win6, self.win7, self.win8, nil];
}











@end
