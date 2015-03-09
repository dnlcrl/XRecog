//
//  ViewController.h
//  prrr
//
//  Created by Daniele Ciriello on 11/11/14.
//  Copyright (c) 2014 Daniele Ciriello. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "MyObject-C-Interface.h"
//#import "CR.h"
@class OptionPopover;
@interface ViewController : NSViewController{

    __weak IBOutlet NSTextField *field1;
    __weak IBOutlet NSSlider *slider1;
    __weak IBOutlet NSStepper *stepper1;
    __weak IBOutlet NSTextField *label1;

    __weak IBOutlet NSTextField *field2;
    __weak IBOutlet NSSlider *slider2;
    __weak IBOutlet NSStepper *stepper2;
    __weak IBOutlet NSTextField *label2;
    
    __weak IBOutlet NSTextField *field3;
    __weak IBOutlet NSSlider *slider3;
    __weak IBOutlet NSStepper *stepper3;
    __weak IBOutlet NSTextField *label3;
    
    __weak IBOutlet NSTextField *field4;
    __weak IBOutlet NSSlider *slider4;
    __weak IBOutlet NSStepper *stepper4;
    __weak IBOutlet NSTextField *label4;
    
    __weak IBOutlet NSTextField *field5;
    __weak IBOutlet NSSlider *slider5;
    __weak IBOutlet NSStepper *stepper5;
    __weak IBOutlet NSTextField *label5;
    
    __weak IBOutlet NSTextField *field6;
    __weak IBOutlet NSSlider *slider6;
    __weak IBOutlet NSStepper *stepper6;
    __weak IBOutlet NSTextField *label6;
    
    __weak IBOutlet NSMatrix *AlgoRadio;
    
    __weak IBOutlet NSButton *kFlag;
    __weak IBOutlet NSButton *cFlag;
    __weak IBOutlet NSButton *rFlag;
    __weak IBOutlet NSButton *transformFlag;
    
    __weak IBOutlet NSTextField *modelFileLabel;
    __weak IBOutlet NSTextField *sceneFileLabel;
    
    
    
    OptionPopover *optionPopover;
    NSThread* myThread;
    
    
    
}



- (void)updateUserInterface;
+ (void)logMessage:(NSString *)message;
+ (BOOL)stopPCL;
- (void)setModelKeypoints:(long)number;
- (void)setTotalModelPoints:(long)number;
- (void)setSceneKeypoints:(long)number;
- (void)setTotalScenePoints:(long)number;

@end

