//
//  ViewController.m
//  runtime
//
//  Created by hejingjin on 17/5/18.
//  Copyright © 2017年 teamsun. All rights reserved.
//

#import "ViewController.h"
#import "RunTimeModel.h"
#import "ChatModel.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ChatModel+AddPro.h"

//runtime  归解档
#define encodeRuntime(A) \
\
unsigned int count = 0;\
Ivar *ivars = class_copyIvarList([A class], &count);\
for (int i = 0; i<count; i++) {\
Ivar ivar = ivars[i];\
const char *name = ivar_getName(ivar);\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [self valueForKey:key];\
[encoder encodeObject:value forKey:key];\
}\
free(ivars);\
\

#define initCoderRuntime(A) \
\
if (self = [super init]) {\
unsigned int count = 0;\
Ivar *ivars = class_copyIvarList([A class], &count);\
for (int i = 0; i<count; i++) {\
Ivar ivar = ivars[i];\
const char *name = ivar_getName(ivar);\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [decoder decodeObjectForKey:key];\
[self setValue:value forKey:key];\
}\
free(ivars);\
}\
return self;\
\

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    RunTimeModel *model = [[RunTimeModel alloc] init];
    
    model.teststr = @"teststr";
    
     [model say];
    
    [self replacePeopleRunMethod];
    
    
    [self addRuntimeModelMethod];
    
    [model say];
    
    //调用动态添加的方法
    [model performSelector:@selector(addMethods)];
    
    
    //分类中添加属性测试
    ChatModel *chatmodel = [[ChatModel alloc] init];
    chatmodel.names = @"1111111";
    
    chatmodel.runtimemodel = model;
    NSLog(@"%@",chatmodel.names);
    
    NSLog(@"%@",chatmodel.runtimemodel.teststr);
    
    
    //动态添加方法
//    [model performSelector:@selector(eat:) withObject:@(1111)];
    
    
    //交换方法
    Method orgmethod = class_getInstanceMethod([RunTimeModel class], @selector(say));
    
    Method sourcemethod = class_getInstanceMethod([RunTimeModel class], @selector(helloe));
    
    method_exchangeImplementations(sourcemethod,orgmethod);


//
    [model helloe];
    
    [model say];
    
    SEL oriSEL = @selector(say);
    
    int count;
    
    int ivarCount;
    
    Ivar *ivarList = class_copyIvarList([ChatModel class], &ivarCount);
//    Ivar 为结构体 其中有name  type等等
  
    for (int i = 0; i < ivarCount; i ++) {
        
        NSString *string = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivarList[i])];
//                NSLog(@"%@",string);
        NSString *string1 = [NSString stringWithUTF8String:ivar_getName(ivarList[i])];
//        NSLog(@"%@______%@",string,string1);
    }
    
    objc_property_t *list = class_copyPropertyList([ChatModel class], &count);
    
    for (int i = 0; i < count; i ++) {
        
        NSString *string = [NSString stringWithUTF8String:property_getName(list[i])];
//        NSLog(@"%@",string);
        
    }
    
    int couts;
    Method *methodList = class_copyMethodList(NSClassFromString(@"RunTimeModel"), &couts);

    for (int i = 0; i < couts ; i ++) {
        NSString *string = [NSString stringWithUTF8String:method_getName(methodList[i])];
        NSLog(@"%@",string);
    }
    
//    struct objc_method {
//        SEL method_name                                          OBJC2_UNAVAILABLE;
//        char *method_types                                       OBJC2_UNAVAILABLE;
//        IMP method_imp                                           OBJC2_UNAVAILABLE;
//    }
//
    
  
    
}

-(void)runnn{
    
    NSLog(@"替换某一个类的方法");
    
}


-(void)addMethods{
    NSLog(@"为一个类动态添加一个方法");
    
}

- (void)replacePeopleRunMethod {
    
    Class class = NSClassFromString(@"RunTimeModel");
    SEL classsaySel = @selector(say);
    Method methodsay = class_getInstanceMethod(class, classsaySel);
    char *typeDescription = (char *)method_getTypeEncoding(methodsay);
    

    IMP runFastImp = class_getMethodImplementation([self class], @selector(runnn));
    
    //先将方法添加到类中再做覆盖
    class_addMethod(class, @selector(runnn), runFastImp, typeDescription);
    
    class_replaceMethod(class, classsaySel, runFastImp, typeDescription);
    
}

//为某个类添加方法
-(void)addRuntimeModelMethod{
    
    Class modelclass  = NSClassFromString(@"RunTimeModel");
    
    SEL classSel = @selector(addMethods);
    
    char *typedes = (char *)method_getDescription(class_getInstanceMethod([self class], classSel));
    
    IMP addimp = class_getMethodImplementation([self class], classSel);
    
    class_addMethod(modelclass, classSel, addimp, typedes);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
