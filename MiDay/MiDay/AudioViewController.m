//
//  AudioViewController.m
//  MiDay
//
//  Created by xuchen on 3/14/15.
//  Copyright (c) 2015 __ChenXu_MingYangYu__. All rights reserved.
//

#import "AudioViewController.h"
#import "FileManager.h"
#import <AVFoundation/AVFoundation.h>
#import "editViewController.h"

@interface AudioViewController () <AVAudioPlayerDelegate,AVAudioRecorderDelegate>

@property (strong,nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger timerCount;
@property (nonatomic) BOOL isCountDown;
@property (nonatomic) NSInteger duration;

@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set round corner
    self.upButton.layer.cornerRadius = 5;
    self.downButton.layer.cornerRadius = 5;
    
    if (self.audioPath) {
        //if there already an audio file
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   self.audioPath,
                                   nil];
        NSURL *audioURL = [NSURL fileURLWithPathComponents:pathComponents];
        DLog(@"audio exists is: %@",audioURL);
        
        NSError *err;
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&err];
        
        [self setUpTimerLabel:self.player.duration];
        self.timerCount = self.player.duration;
        self.duration = self.player.duration;
        
        self.player = nil;
        
        //set up ui
        [self.upButton setTitle:@"Play" forState:UIControlStateNormal];
        [self.downButton setTitle:@"Remove" forState:UIControlStateNormal];
        self.downButton.backgroundColor = [UIColor redColor];
        
        self.isCountDown = YES;
        
    }else{
        [self.upButton setTitle:@"Record" forState:UIControlStateNormal];
        self.downButton.hidden = YES;
        
        self.isCountDown = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)increaseTimeCount{
    
    if (self.isCountDown){
        self.timerCount--;
    }else{
        self.timerCount++;
    }
    
    DLog(@"timerCount:%i",(int)self.timerCount);
    
    [self setUpTimerLabel:self.timerCount];
}

- (void)setUpTimerLabel:(NSInteger)timeCount{
    NSInteger second = timeCount % 60;
    NSInteger minute = timeCount / 60;
    
    //if self.timerCount == 3600 stop timer
    NSString *secondString;
    if (second < 10) {
        secondString = [[NSString alloc] initWithFormat:@"0%i",(int)second];
    }else{
        secondString = [[NSString alloc] initWithFormat:@"%i",(int)second];
    }
    
    NSString *minuteString;
    if (minute < 10) {
        minuteString = [[NSString alloc] initWithFormat:@"0%i",(int)minute];
    }else{
        minuteString = [[NSString alloc] initWithFormat:@"%i",(int)minute];
    }
    
    self.TimeLabel.text = [[NSString alloc] initWithFormat:@"%@:%@",minuteString,secondString];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma audio
-(void) PrepareForRecord{
    //create audioPath by create Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    self.audioPath = [[NSString alloc] initWithFormat:@"%@.m4a",[dateFormatter stringFromDate:[NSDate date]]];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               self.audioPath,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    DLog(@"audio output: %@",outputFileURL);
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    NSError *err;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:&err];
    
    if (err) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"An error encountered"
                              message:@"Cannot record sound because there is an error when creating a new sound record"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
    }
}

- (IBAction)upButtonTapped:(id)sender {
    DLog(@"%@",self.upButton.titleLabel.text);
    
    if ([self.upButton.titleLabel.text isEqualToString:@"Record"]) {
        //set up timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimeCount) userInfo:nil repeats:YES];
        
        //do prepare for record and start
        [self PrepareForRecord];
        [self.recorder record];
        
        //change the ui of the button
        [self.upButton setTitle:@"Stop Record" forState:UIControlStateNormal];
        self.upButton.backgroundColor = [UIColor redColor];
        
    }else if([self.upButton.titleLabel.text isEqualToString:@"Stop Record"]){
        //stop timer
        [self stopTimer];
        
        //stop record
        [self.recorder stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        //record duration
        self.duration = self.timerCount;
        
        //change the ui of the button
        [self.upButton setTitle:@"Play" forState:UIControlStateNormal];
        self.upButton.backgroundColor = [[UIColor alloc] initWithRed:0.204 green:0.286 blue:0.369 alpha:0.9];
        [self.downButton setTitle:@"Remove" forState:UIControlStateNormal];
        self.downButton.backgroundColor = [UIColor redColor];
        self.downButton.hidden = NO;
        
    }else if([self.upButton.titleLabel.text isEqualToString:@"Play"]){
        
        //set timer label
        [self setUpTimerLabel:self.duration];
        self.timerCount = self.duration;
        self.isCountDown = YES;
        
        //set up player
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   self.audioPath,
                                   nil];
        NSURL *audioURL = [NSURL fileURLWithPathComponents:pathComponents];
        DLog(@"audio exists is: %@",audioURL);
        
        NSError *err;
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&err];
        self.player.delegate = self;
        [self.player prepareToPlay];
        
        //start play
        [self.player play];
        
        //set up timer
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimeCount) userInfo:nil repeats:YES];
        
        //change the ui of the button
        [self.upButton setTitle:@"Stop Play" forState:UIControlStateNormal];
        self.upButton.backgroundColor = [UIColor redColor];
        self.downButton.hidden = YES;
        
    }else if([self.upButton.titleLabel.text isEqualToString:@"Stop Play"]){
        [self resetForPlay];
    }
}

- (void) resetForPlay{
    //stop timer
    [self stopTimer];
    
    //stop player
    [self.player stop];
    self.player = nil;
    
    //resume timer label
    [self setUpTimerLabel:self.duration];
    self.timerCount = self.duration;
    self.isCountDown = YES;
    
    //change the ui of the button
    [self.upButton setTitle:@"Play" forState:UIControlStateNormal];
    self.upButton.backgroundColor = [[UIColor alloc] initWithRed:0.204 green:0.286 blue:0.369 alpha:0.9];
    [self.downButton setTitle:@"Remove" forState:UIControlStateNormal];
    self.downButton.backgroundColor = [UIColor redColor];
    self.downButton.hidden = NO;
}

- (void) resetForRecord{
    //reset ui for record
    [self.upButton setTitle:@"Record" forState:UIControlStateNormal];
    self.downButton.hidden = YES;
    
    //reset
    self.timerCount = 0;
    self.TimeLabel.text = @"00:00";
    
    self.isCountDown = NO;
    
    self.audioPath = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self resetForPlay];
}

- (IBAction)downButtonTapped:(id)sender {
    if ([self.downButton.titleLabel.text isEqualToString:@"Remove"]) {
        //delete original file
        [[FileManager getFileManager] RemoveFromDocumentsByFilename:self.audioPath];
        
        //reset settings
        [self resetForRecord];
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    editViewController *evc = (editViewController*)segue.destinationViewController;
    evc.journal.audioPath = self.audioPath;
}

@end
