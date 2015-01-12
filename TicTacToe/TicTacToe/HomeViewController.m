//
//  ViewController.m
//  TicTacToe
//
//  Created by Chris Giersch on 1/8/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "HomeViewController.h"
#import "PlayViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *xORoSegmentcontrol;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfPlayersSegmentControl;

@property NSString *playerString;
@property int numberOfPlayers;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfPlayers = 2;
    self.playerString = [self.xORoSegmentcontrol titleForSegmentAtIndex:self.xORoSegmentcontrol.selectedSegmentIndex];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)onNumPlayersSegment:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.numberOfPlayers = 2;
    }
    else
    {
        self.numberOfPlayers = 1;
    }
}

- (IBAction)onSegmentPressed:(UISegmentedControl *)sender
{
    self.playerString = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    NSLog(@"%@", self.playerString);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PlayViewController *playVC = segue.destinationViewController;
    playVC.currentPlayer = self.playerString;
    playVC.numberOfPlayers = self.numberOfPlayers;
}

@end
