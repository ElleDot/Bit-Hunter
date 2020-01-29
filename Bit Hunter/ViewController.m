//
//  ViewController.m
//  Bit Hunter
//
//  Created by Louis Agars-Smith on 11/05/2015.
//  Copyright (c) 2015 Louis Agars-Smith. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) BOOL gameCenterEnabled;

@property (nonatomic, strong) NSString *leaderboardIdentifier;

@property (strong, nonatomic) IBOutlet UIImageView *target1;
@property (strong, nonatomic) IBOutlet UIImageView *target2;

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;

-(void)authenticateLocalPlayer;

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    
    switchNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"switch"];
    
    if (switchNumber == 1) {
        [player play];
        [player2 stop];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"music"
                                         ofType:@"wav"]];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.numberOfLoops = -1;
    
    NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                          pathForResource:@"music2"
                                          ofType:@"wav"]];
    player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    player2.numberOfLoops = -1;
    
    [super viewDidLoad];
    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(152, 965, 0, 0)];
    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySwitch];
    
    switchNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"switch"];
    
    if (switchNumber == 1) {
        [mySwitch setOn:YES animated:YES];
        [player play];
    }
    else {
        [mySwitch setOn:NO animated:YES];
        [player stop];
    }
    
    openTime = 0;
    openTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"open"];
    openTime = openTime + 1;
    [[NSUserDefaults standardUserDefaults] setInteger:openTime forKey:@"open"];
    
    if (openTime == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Read me!"
                                                        message:@"\nWelcome to Bit Hunter! This game is fast, so read up.\n\nDo tap the black targets, don't tap the red ones!\n\nThanks for downloading!"
                                                       delegate:self
                                              cancelButtonTitle:@":)"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else if ((openTime % 5) == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate me on the App Store!"
                                                        message:@"\nWelcome back!\n\nIt would be great for me if you left feedback on the App Store, please feel free to do so."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    [self authenticateLocalPlayer];
    
    _gameCenterEnabled = NO;
    _leaderboardIdentifier = @"hisc";
    
    
    CGPoint newLeftCenter = CGPointMake( 384, 450);
    CGPoint newLeftCenter2 = CGPointMake( 384, 550);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    arcadeButton.center = newLeftCenter;
    gameCenterButton.center = newLeftCenter2;
    [UIView commitAnimations];
    
    titleImage.transform = CGAffineTransformMakeRotation(-0.174532925);
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 1;
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.15];;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = HUGE_VAL;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    [_target1.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [_target2.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [titleImage.layer removeAnimationForKey:@"pulse"];
    [_target1.layer removeAnimationForKey:@"pulse"];
    [_target2.layer removeAnimationForKey:@"pulse"];
    
    [titleImage.layer addAnimation:pulseAnimation forKey:@"pulse"];
    [_target1.layer addAnimation:pulseAnimation forKey:@"pulse"];
    [_target2.layer addAnimation:pulseAnimation forKey:@"pulse"];
    
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        NSLog(@"Switch is ON");
        [player play];
        switchNumber = 1;
        [[NSUserDefaults standardUserDefaults] setInteger:switchNumber forKey:@"switch"];
    } else{
        NSLog(@"Switch is OFF");
        [player stop];
        [player2 stop];
        switchNumber = 0;
        [[NSUserDefaults standardUserDefaults] setInteger:switchNumber forKey:@"switch"];
    }
}

-(void)authenticateLocalPlayer{
    // Instantiate a GKLocalPlayer object to use for authenticating a player.
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            // If it's needed display the login view controller.
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                // If the player is already authenticated then indicate that the Game Center features can be used.
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = @"hisc";
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}


-(IBAction)Arcade:(id)sender {
    
    [player stop];
    
    [player2 play];
    
    if (switchNumber == 0) {
        
        [player2 stop];
    }
    
}

-(IBAction)gameCenter:(id)sender {
    
    [self showLeaderboardAndAchievements:YES];
    
}


-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    // Init the following view controller object.
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    // Set self as its delegate.
    gcViewController.gameCenterDelegate = self;
    
    // Depending on the parameter, show either the leaderboard or the achievements.
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    // Finally present the view controller.
    [self presentViewController:gcViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)capyRight:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copyright"
                                                    message:@"\n2015 AgarsApps\nwww.playonloop.com under CC0"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

-(IBAction)unwindToViewController:(UIStoryboardSegue *)segue {
    
    ViewController *source= segue.sourceViewController;
    
}

#pragma mark - GKGameCenterControllerDelegate method implementation

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
