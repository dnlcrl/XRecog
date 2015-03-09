//
//  ViewController.m
//  prrr
//
//  Created by Daniele Ciriello on 11/11/14.
//  Copyright (c) 2014 Daniele Ciriello. All rights reserved.
//

#import "ViewController.h"
#import "OptionPopover.h"
#import "CR.h"

NSString *docDir;
NSArray *paths;
NSString *docFile;


float value1;
float maxValue1;
float model_ss_def;
NSNumber *model_keypoints;
NSNumber *total_model_points;

float value2;
float maxValue2;
float scene_ss_def;
NSNumber *scene_keypoints;
NSNumber *total_scene_points;


float value3;
float maxValue3;
float rf_rad_def;

float value4;
float maxValue4;
float descr_rad_def;

float value5;
float maxValue5;
float cg_size_def;

float value6;
float maxValue6;
float cg_thresh_def;

BOOL hough;
BOOL stopValue;

CorrespondenceGrouping *c;

NSString *model_path;
NSString *model_path_def;
NSString *scene_path;
NSString *scene_path_def;

NSString* const model_ss_help = @"Model uniform sampling radius (default 0.01)\n\nThis parameter is used as radius search in the uniform sampling process, in order to extract the model's keypoints";
NSString* const scene_ss_help = @"Scene uniform sampling radius (default 0.03)\n\nThis parameter is used as radius search in the uniform sampling process, in order to extract the scene's keypoints";
NSString* const descr_rad_help = @"Descriptor radius (default 0.02)\n\nThis parameter is used as radius search in the SHOTEstimationOMP process, in order to extract the model and scene descriptros.\n The SHOTEstimationOMP estimates the Signature of Histograms of OrienTations (SHOT) descriptor for a given point cloud dataset";
NSString* const rf_rad_help = @"Reference frame radius (default 0.015)\n\nThis parameter is used only in the Hough algorithm, as radius search in the BOARDLocalReferenceFrameEstimation process, in order to Compute (Keypoints) Reference Frames.\nBOARDLocalReferenceFrameEstimation implements the BOrder Aware Repeatable Directions algorithm for local reference frame estimation";
NSString* const cg_size_help = @"Cluster size (default 0.01)\n\nThis parameter is used as HoughBinSize in the Hough3DGrouping or as GCSize in the GeometricConsistencyGrouping algorithm.\ncg_size is the size of the cubes that are created around each keypoint during hough. If two points match also all the points inside of their bins will match, so the smaller the value the better match you will find. If you want a lot of matches increase the value, else decrease it. ";
NSString* const cg_thresh_help = @"Clustering threshold (default 5)\n\nThis parameter is used as HoughThreshold in the Hough3DGrouping or as GCThreshold in the GeometricConsistencyGrouping algorithm.\ncg_thresh is the number of good votes to identify the model. The higher the better the results; if you want a lot of results hold it low, else increase it to have better quality results.";
NSString* const algorithm_help = @"Correspondence algorithm used";

// enum help_strings {
//     model_ss       = 0,
//     scene_ss       = 1,
//     rf_rad_help    = 2,
//     descr_rad      = 3,
//     cg_size        = 4,
//     cg_thresh      = 5
// };

typedef NS_ENUM(NSUInteger, Name){
    model_ss    = 0,
    scene_ss    = 1,
    descr_rad   = 2,
    rf_rad      = 3,
    cg_size     = 4,
    cg_thresh   = 5,
    algorithm   = 6,
};


@implementation ViewController

- (void)viewDidAppear {
    [super viewDidAppear];
    [[self.view window] setTitle:@"XRecog"];
    stopValue = FALSE;
}
- (NSString *) helpForName:(Name) param_name{
    __strong NSString **pointer = (NSString **)&model_ss_help;
    pointer += param_name;
    return *pointer;
}

- (NSString *) helpForTag:(NSUInteger) param_tag{
    __strong NSString **pointer = (NSString **)&model_ss_help;
    pointer += param_tag;
    return *pointer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    maxValue1 = 50.0f;
    maxValue2 = 50.0f;
    maxValue3 = 50.0f;
    maxValue4 = 50.0f;
    maxValue5 = 50.0f;
    maxValue6 = 50.0f;
    
    
    [slider1 setMaxValue:maxValue1];
    [stepper1 setIncrement:0.005f];
    [stepper1 setMaxValue:maxValue1];
    [label1 setStringValue:@""];
    model_keypoints = [NSNumber numberWithInt:0];
    total_model_points = [NSNumber numberWithInt:0];
    
    [slider2 setMaxValue:maxValue2];
    [stepper2 setIncrement:0.005f];
    [stepper2 setMaxValue:maxValue2];
    [label2 setStringValue:@""];
    scene_keypoints = [NSNumber numberWithInt:0];
    total_scene_points = [NSNumber numberWithInt:0];


    
    [slider3 setMaxValue:maxValue3];
    [stepper3 setIncrement:0.005f];
    [stepper3 setMaxValue:maxValue3];
    [label3 setStringValue:@""];

    
    [slider4 setMaxValue:maxValue4];
    [stepper4 setIncrement:0.01f];
    [stepper4 setMaxValue:maxValue4];
    [label4 setStringValue:@""];

    
    [slider5 setMaxValue:maxValue5];
    [stepper5 setIncrement:0.005f];
    [stepper5 setMaxValue:maxValue5];
    [label5 setStringValue:@""];

    
    [slider6 setMaxValue:maxValue6];
    [stepper6 setIncrement:0.5f];
    [stepper6 setMaxValue:maxValue6];
    [label6 setStringValue:@""];

    
    
    //default values
    value1 = model_ss_def = 0.01f;
    value2 = scene_ss_def = 0.03f;
    value3 = rf_rad_def = 0.015f;
    value4 = descr_rad_def = 0.02f;
    value5 = cg_size_def = 0.01f;
    value6 = cg_thresh_def = 5.0f;
    
    [self setAlgorithm:AlgoRadio];
    
    model_path = model_path_def = @"/Users/mbp/Documents/projects/QRecog/pointclouds.org/correspondence_grouping/build/Debug/milk.pcd";
    scene_path = scene_path_def = @"/Users/mbp/Documents/projects/QRecog/pointclouds.org/correspondence_grouping/build/Debug/milk_cartoon_all_small_clorox.pcd";
    
    NSUserDefaults *_default=[NSUserDefaults standardUserDefaults];
    if ([_default boolForKey:@"yet_saved"]){
        value1 = [_default floatForKey:@"value1"];
        value2 = [_default floatForKey:@"value2"];
        value3 = [_default floatForKey:@"value3"];
        value4 = [_default floatForKey:@"value4"];
        value5 = [_default floatForKey:@"value5"];
        value6 = [_default floatForKey:@"value6"];
        hough = [_default boolForKey:@"hough"];
        [kFlag setState:[_default integerForKey:@"kFlag"]];
        [rFlag setState:[_default integerForKey:@"rFlag"]];
        [cFlag setState:[_default integerForKey:@"cFlag"]];
        [transformFlag setState:[_default integerForKey:@"transformFlag"]];
        
        model_path = [_default objectForKey:@"model_path"];
        scene_path = [_default objectForKey:@"scene_path"];
        
        model_keypoints = [_default objectForKey:@"model_keypoints"];
        total_model_points = [_default objectForKey:@"total_model_points"];
        scene_keypoints = [_default objectForKey:@"scene_keypoints"];
        total_scene_points = [_default objectForKey:@"total_scene_points"];
    }
    [self updateUserInterface];

    // Do any additional setup after loading the view.
    
    
}

//- (void)setRepresentedObject:(id)representedObject {
//    [super setRepresentedObject:representedObject];
//
//    // Update the view, if already loaded.
//}

- (IBAction)save:(id)sender {
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = [paths objectAtIndex: 0];
    docFile = [docDir stringByAppendingPathComponent: @"deck.txt"];
    
    [[field1 stringValue] writeToFile:docFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}



- (IBAction)updateField1:(id)sender {
    value1 =[sender floatValue];
    [self updateUserInterface];
}

- (IBAction)updateField2:(id)sender {
    value2 =[sender floatValue];
    [self updateUserInterface];
}

- (IBAction)updateField3:(id)sender {
    value3 =[sender floatValue];
    [self updateUserInterface];
}

- (IBAction)updateField4:(id)sender {
    value4 =[sender floatValue];
    [self updateUserInterface];
}

- (IBAction)updateField5:(id)sender {
    value5 =[sender floatValue];
    [self updateUserInterface];
}

- (IBAction)updateField6:(id)sender {
    value6 =[sender floatValue];
    [self updateUserInterface];
}


- (IBAction)checkClicked:(id)sender {
    [self saveValues];
}

- (IBAction)relaunch:(id)sender
{
    //$N = argv[N]
    NSString *killArg1AndOpenArg2Script = @"kill -9 $1 \n open \"$2\"";
    
    //NSTask needs its arguments to be strings
    NSString *ourPID = [NSString stringWithFormat:@"%d",
                        [[NSProcessInfo processInfo] processIdentifier]];
    
    //this will be the path to the .app bundle,
    //not the executable inside it; exactly what `open` wants
    NSString * pathToUs = [[NSBundle mainBundle] bundlePath];
    
    NSArray *shArgs = [NSArray arrayWithObjects:@"-c", // -c tells sh to execute the next argument, passing it the remaining arguments.
                       killArg1AndOpenArg2Script,
                       @"", //$0 path to script (ignored)
                       ourPID, //$1 in restartScript
                       pathToUs, //$2 in the restartScript
                       nil];
    NSTask *restartTask = [NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:shArgs];
    [restartTask waitUntilExit]; //wait for killArg1AndOpenArg2Script to finish
    NSLog(@"*** ERROR: %@ should have been terminated, but we are still running", pathToUs);
    assert(!"We should not be running!");
//    [[NSWorkspace sharedWorkspace] launchApplication: [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]]];
//    exit(0);

    
    
    //    NSTask *task = [NSTask new];
//    
//    NSMutableArray *args = [NSMutableArray array];
//    [args addObject:@"-c"];
//    [args addObject:[NSString stringWithFormat:@"sleep 1; open \"%@\"", [[NSBundle mainBundle] bundlePath]]];
//    [task setLaunchPath:@"/bin/sh"];
//    [task setArguments:args];
//    [task launch];
//    
//    //[self terminate:nil];
}

- (void)saveValues {
    NSUserDefaults *_default=[NSUserDefaults standardUserDefaults];
    [_default setBool:true forKey:@"yet_saved"];
    [_default setFloat:value1 forKey:@"value1"];
    [_default setFloat:value2 forKey:@"value2"];
    [_default setFloat:value3 forKey:@"value3"];
    [_default setFloat:value4 forKey:@"value4"];
    [_default setFloat:value5 forKey:@"value5"];
    [_default setFloat:value6 forKey:@"value6"];
    [_default setBool:hough forKey:@"hough"];
    [_default setInteger:[kFlag state] forKey:@"kFlag"];
    [_default setInteger:[cFlag state] forKey:@"cFlag"];
    [_default setInteger:[rFlag state] forKey:@"rFlag"];
    [_default setInteger:[transformFlag state] forKey:@"transformFlag"];
    
    [_default setObject:model_path forKey:@"model_path"];
    [_default setObject:scene_path forKey:@"scene_path"];
    
    [_default setObject:model_keypoints forKey:@"model_keypoints"];
    [_default setObject:total_model_points forKey:@"total_model_points"];
    [_default setObject:scene_keypoints forKey:@"scene_keypoints"];
    [_default setObject:total_scene_points forKey:@"total_scene_points"];

    
}

- (void)updateUserInterface {
    
    
    [field1 setStringValue: [NSString stringWithFormat:@"%.6f",value1]];
    [slider1 setFloatValue:value1];
    [stepper1 setFloatValue:value1];
    [label1 setStringValue:[NSString stringWithFormat:@"(%ld kp / %ld Tkp)", [model_keypoints longValue], [total_model_points longValue]]];
    
    [field2 setStringValue: [NSString stringWithFormat:@"%.6f",value2]];
    [slider2 setFloatValue:value2];
    [stepper2 setFloatValue:value2];
    [label2 setStringValue:[NSString stringWithFormat:@"(%ld kp  / %ld Tkp)", [scene_keypoints longValue], [total_scene_points longValue]]];

    
    [field3 setStringValue: [NSString stringWithFormat:@"%.6f",value3]];
    [slider3 setFloatValue:value3];
    [stepper3 setFloatValue:value3];
    
    [field4 setStringValue: [NSString stringWithFormat:@"%.6f",value4]];
    [slider4 setFloatValue:value4];
    [stepper4 setFloatValue:value4];
    
    [field5 setStringValue: [NSString stringWithFormat:@"%.6f",value5]];
    [slider5 setFloatValue:value5];
    [stepper5 setFloatValue:value5];
    
    [field6 setStringValue: [NSString stringWithFormat:@"%.6f",value6]];
    [slider6 setFloatValue:value6];
    [stepper6 setFloatValue:value6];
    
    
    [modelFileLabel setStringValue:model_path];
    [sceneFileLabel setStringValue:scene_path];
    
    
    [self saveValues];
    
}



- (IBAction)setAlgorithm:(id)sender {// sender is NSMatrix object
    hough = !(BOOL)[[sender selectedCell] tag];
}

- (IBAction)ModelFileDialog:(id)sender {
    NSWindow* window = [[self view] window];
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    //[openDlg setCanChooseDirectories:YES];
    
    // Change "Open" dialog button to "Select"
    [openDlg setPrompt:@"Select Model file"];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    [openDlg beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if ( result == NSModalResponseOK )
        {
            // Get an array containing the full filenames of all
            // files and directories selected.
            NSArray* files = [openDlg URLs];
            
            // Loop through all the files and process them.
            //for( int i = 0; i < [files count]; i++ )
            //{
            NSString* fileName = [[files objectAtIndex:0]path];//i];
            model_path = fileName;
            [modelFileLabel setStringValue:model_path];
        }
    }];
    
    
}

- (IBAction)SceneFileDialog:(id)sender {
    NSWindow* window = [[self view] window];
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    //[openDlg setCanChooseDirectories:YES];
    
    // Change "Open" dialog button to "Select"
    [openDlg setPrompt:@"Select Scene file"];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    [openDlg beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if ( result == NSModalResponseOK )
        {
            // Get an array containing the full filenames of all
            // files and directories selected.
            NSArray* files = [openDlg URLs];
            
            // Loop through all the files and process them.
            //for( int i = 0; i < [files count]; i++ )
            //{
            NSString* fileName = [[files objectAtIndex:0]path];//i];
            scene_path = fileName;
            [sceneFileLabel setStringValue:scene_path];
        }
    }];
    
}
- (IBAction)launch:(id)sender {
    
    //myThread = [[NSThread alloc] initWithTarget:self selector:@selector(launchWithThread) object:nil];
    //[myThread start];
    //[self performSelector:@selector(launchWithThread) onThread:myThread withObject:nil waitUntilDone:NO];
    //[self launchWithThread];
    //[NSThread detachNewThreadSelector:@selector(launchWithThread)  toTarget:nil withObject:nil];
    //[self performSelectorInBackground:@selector(launchWithThread) withObject:nil];
    [self performSelectorOnMainThread:@selector(launchWithThread) withObject:nil  waitUntilDone:NO];
    
    
    //  [self launchWithThread];
    
}
- (IBAction)stop:(id)sender {
    stopValue = TRUE;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(launchWithThread) object:nil];
    
}

+ (BOOL)stopPCL{
    return stopValue;
}

- (void)launchWithThread{ // remove withthread ?
    
    std::string _modelString  = [model_path cStringUsingEncoding:NSUTF8StringEncoding];
    std::string _sceneString  = [scene_path cStringUsingEncoding:NSUTF8StringEncoding];
    BOOL _kflag         = [kFlag state]         == NSOnState ? TRUE : FALSE;
    BOOL _cflag         = [cFlag state]         == NSOnState ? TRUE : FALSE;
    BOOL _rflag         = [rFlag state]         == NSOnState ? TRUE : FALSE;
    BOOL _transformflag = [transformFlag state] == NSOnState ? TRUE : FALSE;
    c = new CorrespondenceGrouping(_modelString, _sceneString, _kflag, _cflag, _rflag, _transformflag, hough, value1, value2, value3, value4, value5, value6);
    c->setParent(self);
    c->run();
}



- (IBAction)reset:(id)sender {
    //default values
    value1 = model_ss_def;
    value2 = scene_ss_def;
    value3 = rf_rad_def;
    value4 = descr_rad_def;
    value5 = cg_size_def;
    value6 = cg_thresh_def;
    model_keypoints = 0;
    scene_keypoints = 0;
    
    [self setAlgorithm:AlgoRadio];
    
    model_path = @"/Users/mbp/Documents/projects/QRecog/pointclouds.org/correspondence_grouping/build/Debug/milk.pcd";
    scene_path = @"/Users/mbp/Documents/projects/QRecog/pointclouds.org/correspondence_grouping/build/Debug/milk_cartoon_all_small_clorox.pcd";
    
    [self updateUserInterface];
}


//Our action to show the popover on click
-(IBAction)helpPressed:(id)sender{
    
    
    optionPopover = [[OptionPopover alloc] initWithNibName:@"OptionPopover" bundle:Nil];
    [optionPopover showPopup:sender andText:[self helpForTag:(NSUInteger)[sender tag]]];
    
}

- (void)setModelKeypoints:(long)number{
    model_keypoints = [NSNumber numberWithLong:number];
    [self updateUserInterface];
}
- (void)setTotalModelPoints:(long)number{
    total_model_points = [NSNumber numberWithLong:number];
    [self updateUserInterface];
}
- (void)setSceneKeypoints:(long)number{
    scene_keypoints = [NSNumber numberWithLong:number];
    [self updateUserInterface];
}
- (void)setTotalScenePoints:(long)number{
    total_scene_points = [NSNumber numberWithLong:number];
    [self updateUserInterface];
}
+ (void)logMessage:(NSString *)message{
    NSLog(message);
}

@end
