//
//  SONLog.h
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#ifndef NDEBUG
    #define SONLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
    #define SONLog(format, ...)
#endif
