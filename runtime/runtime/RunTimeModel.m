//
//  RunTimeModel.m
//  runtime
//
//  Created by hejingjin on 17/5/18.
//  Copyright © 2017年 teamsun. All rights reserved.
//

#import "RunTimeModel.h"
#import <objc/runtime.h>

@implementation RunTimeModel

void hjj_eat(id self, SEL _cmd, id prame1){
    NSLog(@"%@",prame1);
}


+(BOOL)resolveInstanceMethod:(SEL)sel{
   
    
    if (sel == @selector(eat:)) {
        class_addMethod(self, sel, (IMP)hjj_eat,"v@:@");
        
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

-(void)say{
    NSLog(@"say");
}

-(void)helloe{
    NSLog(@"helloe");
}

@end
