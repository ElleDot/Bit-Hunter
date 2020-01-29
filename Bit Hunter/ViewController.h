//
//  ViewController.h
//  Bit Hunter
//
//  Created by Louis Agars-Smith on 11/05/2015.
//  Copyright (c) 2015 Louis Agars-Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>

NSInteger switchNumber;
int openTime;

@interface ViewController : UIViewController <GKGameCenterControllerDelegate> {
    
    IBOutlet UIImageView *titleImage;
    IBOutlet UIButton *arcadeButton;
    IBOutlet UIButton *gameCenterButton;
    AVAudioPlayer *player;
    AVAudioPlayer *player2;
    
}

-(IBAction)Arcade:(id)sender;
-(IBAction)gameCenter:(id)sender;
-(IBAction)capyRight:(id)sender;

@end

