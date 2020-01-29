//
//  Arcade.m
//  Bit Hunter
//
//  Created by Louis Agars-Smith on 31/05/2015.
//  Copyright (c) 2015 Louis Agars-Smith. All rights reserved.
//

#import "Arcade.h"

@interface Arcade ()

@property (nonatomic, strong) NSString *leaderboardIdentifier;

@property CALayer *pathLayer;

@end

@implementation Arcade

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tenLabel.hidden = YES;
    highScoreAchieved.hidden = YES;
    scoreLabel.hidden = YES;
    Target.hidden = YES;
    Targetx.hidden = YES;
    Text.hidden = YES;
    
    highScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"high"];
    highScoreLabel.text = [NSString stringWithFormat:@"High Score: %li", (long)highScoreNumber];
    
    _leaderboardIdentifier = @"hisc";
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startButtonPressed:(id)sender {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    [Target.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    NSURL *SoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)SoundURL, &playSoundID);
    
    AudioServicesPlaySystemSound(playSoundID);
    
    timeMax = 5;
    Score = 0;
    lives = 3;
    
    Target.hidden = NO;
    tenLabel.hidden = NO;
    Text.hidden = YES;
    startButton.hidden = YES;
    scoreLabel.hidden = YES;
    scoreAddLabel.hidden = YES;
    
    Timer = [NSTimer scheduledTimerWithTimeInterval:timeMax target:self selector:@selector(Lose) userInfo:nil repeats:NO];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0,910.0)];
    [path addLineToPoint:CGPointMake(768, 910.0)];
    
    targX = arc4random() %618;
    targY = arc4random() %850;
    
    Target.center = CGPointMake(targX, targY);
    
    [self.pathLayer removeAnimationForKey:@"strokeEnd"];
    
    if (self.pathLayer == nil) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0,910.0)];
        [path addLineToPoint:CGPointMake(768.0, 910.0)];
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.view.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [[UIColor blueColor] CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = 20;
        pathLayer.lineJoin = kCALineJoinBevel;
        
        [self.view.layer addSublayer:pathLayer];
        
        self.pathLayer = pathLayer;
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = timeMax;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}

-(IBAction)targetTapped:(id)sender {
    
    NSLog(@"%f", timeMax);
    
    [Timer invalidate];
    
    Targetx.hidden = YES;
    
    scoreAddLabel.hidden = NO;
    scoreAddLabel.center = Target.center;
    scoreAddLabel.text = [NSString stringWithFormat:@"+1"];
    
    targX = arc4random() %618;
    targY = arc4random() %850;
    
    Target.center = CGPointMake(targX, targY);
    
    int spawnBad = arc4random() % 9;
    
    if (spawnBad == 4) {
        targXX = arc4random() %618;
        targXY = arc4random() %850;
        Targetx.hidden = NO;
        Targetx.center = CGPointMake(targXX, targXY);
        CABasicAnimation *rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation2.toValue = [NSNumber numberWithFloat:-M_PI];
        rotationAnimation2.duration = 2;
        rotationAnimation2.cumulative = YES;
        rotationAnimation2.repeatCount = HUGE_VAL;
        
        [Targetx.layer addAnimation:rotationAnimation2 forKey:@"rotationAnimation2"];
    }
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.duration= 0.1;
    theAnimation.repeatCount= 1;
    theAnimation.autoreverses= YES;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    theAnimation.fromValue =[NSNumber numberWithFloat:0];
    theAnimation.toValue =[NSNumber numberWithFloat:-50];
    
    Score = Score + 1;
    
    timeMax = 5 - (Score * 0.03);
    
    if (timeMax <= 0.5) {
        timeMax = 0.5;
    }
    
    [self tenFlash];
    
    [scoreAddLabel.layer addAnimation:theAnimation forKey:@"animateLayer"];
    
    [self.pathLayer removeAnimationForKey:@"strokeEnd"];
    
    if (self.pathLayer == nil) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0,910.0)];
        [path addLineToPoint:CGPointMake(768.0, 910.0)];
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.view.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [[UIColor blueColor] CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = 20;
        pathLayer.lineJoin = kCALineJoinBevel;
        
        [self.view.layer addSublayer:pathLayer];
        
        self.pathLayer = pathLayer;
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = timeMax;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    Timer = [NSTimer scheduledTimerWithTimeInterval:timeMax target:self selector:@selector(Lose) userInfo:nil repeats:NO];
    
}

-(IBAction)badTargetTapped:(id)sender {
    
    NSURL *SoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"lose" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)SoundURL, &playSoundID);
    
    AudioServicesPlaySystemSound(playSoundID);
    
    NSLog(@"bad %f", timeMax);
    
    [Timer invalidate];
    
    Targetx.hidden = YES;
    
    scoreAddLabel.hidden = NO;
    scoreAddLabel.center = Targetx.center;
    scoreAddLabel.text = [NSString stringWithFormat:@"-10"];
    
    targX = arc4random() %618;
    targY = arc4random() %850;
    
    Target.center = CGPointMake(targX, targY);
    
    int spawnBad = arc4random() % 9;
    
    if (spawnBad == 4) {
        targXX = arc4random() %618;
        targXY = arc4random() %850;
        Targetx.hidden = NO;
        Targetx.center = CGPointMake(targXX, targXY);
    }
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.duration= 0.1;
    theAnimation.repeatCount= 1;
    theAnimation.autoreverses= YES;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    theAnimation.fromValue =[NSNumber numberWithFloat:0];
    theAnimation.toValue =[NSNumber numberWithFloat:-50];
    
    Score = Score - 10;
    
    timeMax = 5 - (Score * 0.03);
    
    if (timeMax <= 0.5) {
        timeMax = 0.5;
    }
    
    [self tenFlash];
    
    [scoreAddLabel.layer addAnimation:theAnimation forKey:@"animateLayer"];
    
    [self.pathLayer removeAnimationForKey:@"strokeEnd"];
    
    if (self.pathLayer == nil) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0,910.0)];
        [path addLineToPoint:CGPointMake(768.0, 910.0)];
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.view.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [[UIColor blueColor] CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = 20;
        pathLayer.lineJoin = kCALineJoinBevel;
        
        [self.view.layer addSublayer:pathLayer];
        
        self.pathLayer = pathLayer;
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = timeMax;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    
    Timer = [NSTimer scheduledTimerWithTimeInterval:timeMax target:self selector:@selector(Lose) userInfo:nil repeats:NO];
    
    CABasicAnimation *scoreBadPulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scoreBadPulse.duration= 0.5;
    scoreBadPulse.toValue =[NSNumber numberWithFloat:0.5];
    scoreBadPulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scoreBadPulse.autoreverses= YES;
    scoreBadPulse.repeatCount= 1;
    
    [tenLabel.layer addAnimation:scoreBadPulse forKey:@"scoreBadPulse"];
    
    lives = lives - 1;
    
    if (lives == 2) {
        CABasicAnimation *lifeDie = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        lifeDie.duration= 1;
        lifeDie.toValue =[NSNumber numberWithFloat:0];
        lifeDie.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        lifeDie.autoreverses= NO;
        lifeDie.repeatCount= 1;
        [CATransaction begin]; {
            [CATransaction setCompletionBlock:^{
                [self->three removeFromSuperview];
            }];
            [three.layer addAnimation:lifeDie forKey:@"lifeDie"];
        } [CATransaction commit];
    }
    else if (lives == 1) {
        CABasicAnimation *lifeDie2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        lifeDie2.duration= 1;
        lifeDie2.toValue =[NSNumber numberWithFloat:0];
        lifeDie2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        lifeDie2.autoreverses= NO;
        lifeDie2.repeatCount= 1;
        [CATransaction begin]; {
            [CATransaction setCompletionBlock:^{
                [self->two removeFromSuperview];
            }];
            [two.layer addAnimation:lifeDie2 forKey:@"lifeDie2"];
        } [CATransaction commit];
    }
    else if (lives == 0) {
        CABasicAnimation *lifeDie3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        lifeDie3.duration= 1;
        lifeDie3.toValue =[NSNumber numberWithFloat:0];
        lifeDie3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        lifeDie3.autoreverses= NO;
        lifeDie3.repeatCount= 1;
        [self Lose];
        [self.pathLayer removeAnimationForKey:@"strokeEnd"];
        [CATransaction begin]; {
            [CATransaction setCompletionBlock:^{
                [self->one removeFromSuperview];
            }];
            [one.layer addAnimation:lifeDie3 forKey:@"lifeDie3"];
        } [CATransaction commit];
    }
    
}

-(void)tenFlash{
    
    if (Score == 10 || Score == 20 || Score == 30 || Score == 40 || Score == 50 || Score == 60 || Score == 70 || Score == 80 || Score == 90 || Score == 100 || Score == 110 || Score == 120 || Score == 130 || Score == 140 || Score == 150 || Score == 160 || Score == 170 || Score == 180 || Score == 190 || Score == 200) {
        
        NSURL *SoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ten" ofType:@"mp3"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)SoundURL, &playSoundID);
        
        AudioServicesPlaySystemSound(playSoundID);
        
        tenLabel.text = [NSString stringWithFormat:@"%li", (long)Score];
        
        CABasicAnimation *scorePulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scorePulse.duration= 0.5;
        scorePulse.toValue =[NSNumber numberWithFloat:3];
        scorePulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scorePulse.autoreverses= YES;
        scorePulse.repeatCount= 1;
        
        [tenLabel.layer addAnimation:scorePulse forKey:@"scorePulse"];
        
    }
    
    else {
        
        CABasicAnimation *scorePulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scorePulse.duration= 0.1;
        scorePulse.toValue =[NSNumber numberWithFloat:1.1];
        scorePulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scorePulse.autoreverses= YES;
        scorePulse.repeatCount= 1;
        
        [tenLabel.layer addAnimation:scorePulse forKey:@"scorePulse"];
        
        tenLabel.text = [NSString stringWithFormat:@"%li", (long)Score];
        
    }
    
}

-(void)Lose{
    
    [self reportScore];
    
    scoreAddLabel.hidden = YES;
    
    Text.hidden = NO;
    scoreLabel.hidden = NO;
    Target.hidden = YES;
    Targetx.hidden = YES;
    scoreLabel.text = [NSString stringWithFormat:@"Score: %li", (long)Score];
    
    if (Score > highScoreNumber) {
        highScoreAchieved.hidden = NO;
        highScoreNumber = Score;
        highScoreLabel.text = [NSString stringWithFormat:@"High Score: %li", (long)highScoreNumber];
        [[NSUserDefaults standardUserDefaults] setInteger:highScoreNumber forKey:@"high"];
    }
    
}

-(void)reportScore{
    // Create a GKScore object to assign the score and report it as a NSArray object.
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = Score;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
