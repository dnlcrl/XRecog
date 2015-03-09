//
//  MyObject-C-Interface.h
//  prrr
//
//  Created by Daniele Ciriello on 13/11/14.
//  Copyright (c) 2014 Daniele Ciriello. All rights reserved.
//

#ifndef prrr_MyObject_C_Interface_h
#define prrr_MyObject_C_Interface_h

// This is the C "trampoline" function that will be used
// to invoke a specific Objective-C method FROM C++
int MyObjectDoSomethingWith (void *myObjectInstance, void *parameter);
#endif