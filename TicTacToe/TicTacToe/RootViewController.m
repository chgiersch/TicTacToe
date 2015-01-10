//
//  ViewController.m
//  TicTacToe
//
//  Created by Chris Giersch on 1/8/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "RootViewController.h"
#import "PlayViewController.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property NSString *playerString;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerString = [self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
    // Do any additional setup after loading the view, typically from a nib.
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
}

@end
