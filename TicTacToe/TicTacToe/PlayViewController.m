//
//  PlayViewController.m
//  TicTacToe
//
//  Created by Chris Giersch on 1/8/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *a1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *a2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *a3ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *b1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *b2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *b3ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *c1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *c2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *c3ImageView;

@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;

@property NSMutableSet *winningIndexCombinations;
@property NSSet *win1;
@property NSSet *win2;
@property NSSet *win3;
@property NSSet *win4;
@property NSSet *win5;
@property NSSet *win6;
@property NSSet *win7;
@property NSSet *win8;
@property NSArray *fourCornersArray;
@property NSArray *full9CellArray;
@property NSMutableSet *playerXSet;
@property NSMutableSet *playerOSet;
@property NSMutableSet *allPlaysSet;

@property NSArray *imagesArray;
@property NSString *startingPlayer;
@property int startingTime;
@property UIGestureRecognizer *gestureRecognizer;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic)  NSTimer *timer;
@property NSInteger timerValue;
@property BOOL isComputerTurn;

@end


@implementation PlayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isComputerTurn = FALSE;

    // Create set of all winning sets
    [self createWinningSets];
    // Create set to hold respective player move choices
    self.playerXSet = [[NSMutableSet alloc] init];
    self.playerOSet = [[NSMutableSet alloc] init];
    self.allPlaysSet = [[NSMutableSet alloc] init];
    self.fourCornersArray = @[@"1", @"3", @"7", @"9"];
    self.full9CellArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];

    // Create array of all ImageView objects
    self.imagesArray = [[NSArray alloc] initWithObjects:self.a1ImageView, self.a2ImageView, self.a3ImageView, self.b1ImageView, self.b2ImageView, self.b3ImageView, self.c1ImageView, self.c2ImageView, self.c3ImageView, nil];

    // Initialize timer and set start time seconds
    self.startingTime = 30;
    [self startTimer:self.startingTime];

    // Set current player label
    [self setCurrentPlayerLabel];
}

// Sets that imageView's image to X or an O depending on the current player
- (IBAction)onImageViewTapped:(UITapGestureRecognizer *)gesture
{
    //NSLog(@"BOOL = %d", (int)self.isComputerTurn);

    NSString *currentPlayerMove;
    self.gestureRecognizer = gesture;
    // Get touch point
    CGPoint touchPoint = [gesture locationInView:self.view];
    // Get the image touched
    UIImageView *imageViewTouched = [self findImageViewUsingPoint:touchPoint];


    if (imageViewTouched != nil && imageViewTouched.image == nil)
    {
        // Change image to current player's X or O
        imageViewTouched.image = [UIImage imageNamed:self.currentPlayer];
        currentPlayerMove = [NSString stringWithFormat:@"%li", (long)imageViewTouched.tag];

        // Save player move
        NSString *currentPlayerMove = [NSString stringWithFormat:@"%ld", (long)imageViewTouched.tag];
        if ([self.currentPlayer isEqualToString:@"X"])
        {
            // Player X turn
            [self.playerXSet addObject: currentPlayerMove];
        }
        else
        {
            // Player Y turn
            [self.playerOSet addObject: currentPlayerMove];
        }
        [self.allPlaysSet addObject:currentPlayerMove];

        // Check for game over conditions:
        // Check for win
        if ([[self whoWon] isEqualToString:@"X"] || [[self whoWon] isEqualToString:@"O"])
        {
            [self endGame:[NSString stringWithFormat:@"Player %@ won!!!", self.currentPlayer]];
            return;
        }
        //Check for a tie
        [self checkFotTie];

        // Switch current player
        [self switchCurrentPlayer];

        // if playing against the computer
        if (self.numberOfPlayers == 1 && self.isComputerTurn == TRUE)
        {
            //NSLog([NSString stringWithFormat:@"%d", [self tagIntForComputerMove]]);
            UIImageView *imageViewForComputer = self.imagesArray[[self tagIntForComputerMove]];
            imageViewForComputer.image = [UIImage imageNamed:self.currentPlayer];
            currentPlayerMove = [NSString stringWithFormat:@"%li", (long)imageViewForComputer.tag];
            if ([self.currentPlayer isEqualToString:@"X"])
            {
                // Player X turn
                [self.playerXSet addObject: currentPlayerMove];
            }
            else
            {
                // Player Y turn
                [self.playerOSet addObject: currentPlayerMove];
            }
            [self.allPlaysSet addObject:currentPlayerMove];
            [self switchCurrentPlayer];
        }

        //        NSLog([NSString stringWithFormat:@"allPlaysSet: %@", self.allPlaysSet ]);
        //        NSLog([NSString stringWithFormat:@"X Set: %@", self.playerXSet ]);
        //        NSLog([NSString stringWithFormat:@"O Set: %@", self.playerOSet ]);
    }
}


- (int)tagIntForComputerMove
{
    //BOOL computerModeOffensive = FALSE;

    // If: no one has played in the middle square, play in middle square
    if ([self isCellEmpty:5])
    {
        return 4;
    }

    // If fork ten play in non-corner/non-center cell

    // Else if: squares(1, 3, 7, 9) are empty, play in one of those empty squares
    // Check to see if cell is empty and play in cell if true
    for (NSString *cell in self.fourCornersArray)
    {
        //NSLog([NSString stringWithFormat:@"O Set: %@", cell]);
        //NSLog(@"BOOL = %d", (int)[self cell.intValue]);


        if([self isCellEmpty:cell.intValue])
        {
            return cell.intValue-1;
            //NSLog([NSString stringWithFormat:@"Computer string %@", string]);
        }
    }
    // Else if: BLOCK: human player has 2 moves in a winning set, play in 3rd move to complete the set
    for (int cell = 1; cell <= 9; ++cell)
    {
        if ([self isCellEmpty:cell])
        {
            NSMutableSet *tempSet = [[NSMutableSet alloc] initWithSet: self.playerOSet];
            [tempSet addObject:[NSString stringWithFormat:@"%i", cell]];
            //NSLog([NSString stringWithFormat:@"Temp Set: %@", tempSet]);

            for (NSSet *winningSet in self.winningIndexCombinations)
            {
                if ([winningSet isSubsetOfSet:self.playerXSet]) // || [winningSet isSubsetOfSet:self.playerOSet])
                {
                    return cell-1;
                }

            }
            // if (defensive): player can win in set play in set-finishing cell
            // if (offensive): computer can win in set play in set-finishing cell
        }
        //     Else: play in any open square
        //     Check to see if any cell is empty and play in one of them
        for (NSString *string in self.full9CellArray)
        {
            if([self isCellEmpty:string.intValue])
            {
                // return empty cell int value
                return string.intValue-1;
            }
        }
    }
    return 0;
}

- (BOOL)isCellEmpty:(int)integerOfTagForCell
{
    //    NSLog([NSString stringWithFormat:@"isEmptyCell: %i", integerOfTagForCell]);
    //if ([self.allPlaysSet containsObject:[NSString stringWithFormat:@"%i", integerOfTagForCell]])
    if ([self.allPlaysSet containsObject:[NSString stringWithFormat:@"%i", integerOfTagForCell]])
    {
        return FALSE;
    }
    return TRUE;
}

- (void)startTimer:(int)timerStartValue
{
    [self.timer invalidate];
    self.timerValue = timerStartValue;
    self.timerLabel.text = [NSString stringWithFormat:@"%i", timerStartValue];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)timerFired:(NSTimer *)timer   //  *** need to fix timer (if you click reset before time=0 it is broken)
{
    if (self.timerValue <= 0)
    {
        [timer invalidate];
        [self endGame:@"Time's up! Nobody Wins"];
    }
    else
    {
        self.timerValue--;
        self.timerLabel.text = [NSString stringWithFormat:@"%li", (long)self.timerValue];
    }
}

- (void)resetGame
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
    [self.playerOSet removeAllObjects];
    [self.allPlaysSet removeAllObjects];
    [self setCurrentPlayerLabel];
    self.gameOverLabel.text = @"";
    [self startTimer:self.startingTime];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self resetGame];
    }
}

- (void)endGame:(NSString *)winnerString
{
    self.gestureRecognizer.enabled = FALSE;
    self.gameOverLabel.text = winnerString;
    self.whichPlayerLabel.text = [NSString stringWithFormat:@""];

    UIAlertView *alertView = [UIAlertView new];
    alertView.delegate = self;
    alertView.title = winnerString;
    [alertView addButtonWithTitle:@"Dismiss"];
    [alertView addButtonWithTitle:@"Play Again"];
    [alertView show];
    [self.timer invalidate];

}

- (NSString *)whoWon  //:(NSString *)playerString
{
    if ([self.currentPlayer isEqualToString:@"X"])
    {
        // Compare if players chosen plays matches any of the winning combinations
        for (NSSet *winningSet in self.winningIndexCombinations)
        {
            //NSLog(@"%@  %@", self.playerXSet, winningSet);
            if ([winningSet isSubsetOfSet:self.playerXSet] || [winningSet isSubsetOfSet:self.playerOSet])
            {
                return self.currentPlayer;
            }
        }
    }
    return FALSE;
}

- (IBAction)onResetButtonPressed:(UIButton *)sender
{
    [self resetGame];
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

    // Switch computer turn on or off
    if (self.isComputerTurn)
    {
        self.isComputerTurn = FALSE;
    }
    else
    {
        self.isComputerTurn = TRUE;
    }
    [self setCurrentPlayerLabel];
}

- (void)setCurrentPlayerLabel
{
    self.whichPlayerLabel.text = [NSString stringWithFormat:@"It's your turn, %@.", self.currentPlayer];

    if (self.numberOfPlayers == 1 && self.isComputerTurn == TRUE)
    {
        self.whichPlayerLabel.text = [NSString stringWithFormat:@"Nice move...computer is thinking"];
    }

}

- (void)checkFotTie
{
    // Check for a tie
    if (self.playerXSet.count == 5 || self.playerOSet.count == 5)
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
    self.winningIndexCombinations = [[NSMutableSet alloc] initWithObjects: self.win1, self.win2, self.win3, self.win4, self.win5, self.win6, self.win7, self.win8, nil];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    [self.timer];
//}



@end
