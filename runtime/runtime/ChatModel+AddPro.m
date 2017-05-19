//
//  ChatModel+AddPro.m
//  runtime
//
//  Created by hejingjin on 17/5/19.
//  Copyright © 2017年 teamsun. All rights reserved.
//

#import "ChatModel+AddPro.h"
#import <objc/runtime.h>

@implementation ChatModel (AddPro)


//为分类添加属性
-(void)setNames:(NSString *)names{
    
    objc_setAssociatedObject(self, @selector(names), names, OBJC_ASSOCIATION_COPY);
    
}

-(NSString *)names{
    
    return objc_getAssociatedObject(self, @selector(names));
}

-(void)setRuntimemodel:(RunTimeModel *)runtimemodel{
    
    objc_setAssociatedObject(self, @selector(runtimemodel), runtimemodel, OBJC_ASSOCIATION_RETAIN);
}

-(RunTimeModel *)runtimemodel{
    return objc_getAssociatedObject(self, @selector(runtimemodel));
}

@end
