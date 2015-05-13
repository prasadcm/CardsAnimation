//
//  SynthesizeSingleton.h
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#define SYNTHESIZE_SINGLETON_METHOD_FOR_CLASS(classname) \
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
+ (classname *)shared##classname \
{ \
static classname *shared##classname = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##classname = [[classname alloc] init]; \
}); \
\
return shared##classname; \
} \
\
