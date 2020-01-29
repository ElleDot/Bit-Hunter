//
//  Arcade.h
//  Bit Hunter
//
//  Created by Louis Agars-Smith on 31/05/2015.
//  Copyright (c) 2015 Louis Agars-Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>

NSInteger highScoreNumber;
float timeMax;
int Score;
NSInteger targX;
NSInteger targY;
NSInteger targXX;
NSInteger targXY;
NSInteger lives;

@interface Arcade : UIViewController {
    
    IBOutlet UIButton *exitButton;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *Target;
    IBOutlet UIButton *Targetx;
    IBOutlet UILabel *highScoreAchieved;
    IBOutlet UILabel *highScoreLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *tenLabel;
    IBOutlet UILabel *Text;
    IBOutlet UILabel *scoreAddLabel;
    IBOutlet UIImageView *one;
    IBOutlet UIImageView *two;
    IBOutlet UIImageView *three;
    
    NSTimer *Timer;
    SystemSoundID playSoundID;
    
}

-(IBAction)badTargetTapped:(id)sender;
-(IBAction)startButtonPressed:(id)sender;
-(IBAction)targetTapped:(id)sender;

-(void)Lose;

@end
