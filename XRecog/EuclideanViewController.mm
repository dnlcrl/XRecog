//
//  EuclideanViewController.m
//  prrr
//
//  Created by Daniele Ciriello on 18/11/14.
//  Copyright (c) 2014 Daniele Ciriello. All rights reserved.
//

#import "EuclideanViewController.h"
#import "EC.h"

float leaf_size;
NSString *input_file_path;

@implementation EuclideanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    input_file_path = @"";
    [input_file_label setStringValue:@""];
    leaf_size = 0.01;
    [self updateUserInterface];
    // Do view setup here.
}

- (IBAction)inputFileDialog:(id)sender {
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
            input_file_path = fileName;
            [input_file_label setStringValue:input_file_path];
        }
    }];
    
}
- (IBAction)updateLeafSize:(id)sender {
    leaf_size =[sender floatValue];
    [self updateUserInterface];
}

- (void)updateUserInterface {
    

    [leaf_size_text_field setStringValue: [NSString stringWithFormat:@"%.6f",leaf_size]];

//    [field1 setStringValue: [NSString stringWithFormat:@"%.6f",value1]];
//    [slider1 setFloatValue:value1];
//    [stepper1 setFloatValue:value1];
//    [label1 setStringValue:[NSString stringWithFormat:@"(%ld kp / %ld Tkp)", [model_keypoints longValue], [total_model_points longValue]]];
//    
//    [field2 setStringValue: [NSString stringWithFormat:@"%.6f",value2]];
//    [slider2 setFloatValue:value2];
//    [stepper2 setFloatValue:value2];
//    [label2 setStringValue:[NSString stringWithFormat:@"(%ld kp  / %ld Tkp)", [scene_keypoints longValue], [total_scene_points longValue]]];
//    
//    
//    [field3 setStringValue: [NSString stringWithFormat:@"%.6f",value3]];
//    [slider3 setFloatValue:value3];
//    [stepper3 setFloatValue:value3];
//    
//    [field4 setStringValue: [NSString stringWithFormat:@"%.6f",value4]];
//    [slider4 setFloatValue:value4];
//    [stepper4 setFloatValue:value4];
//    
//    [field5 setStringValue: [NSString stringWithFormat:@"%.6f",value5]];
//    [slider5 setFloatValue:value5];
//    [stepper5 setFloatValue:value5];
//    
//    [field6 setStringValue: [NSString stringWithFormat:@"%.6f",value6]];
//    [slider6 setFloatValue:value6];
//    [stepper6 setFloatValue:value6];
//    
//    
//    [modelFileLabel setStringValue:model_path];
//    [sceneFileLabel setStringValue:scene_path];
//    
//    
//    [self saveDefaultValues];
    
}


- (IBAction)launch:(id)sender {

    std::string _file_string  = [input_file_path cStringUsingEncoding:NSUTF8StringEncoding];
    EuclideanClustering *ec = new EuclideanClustering(_file_string, leaf_size);
    ec->run();
}

@end
