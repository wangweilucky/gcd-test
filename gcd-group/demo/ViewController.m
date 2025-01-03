//
//  ViewController.m
//  demo
//
//  Created by wwango666 on 2025/1/2.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_group_t hitchAllGroup;

@property (nonatomic, strong) dispatch_queue_t queue1;
@property (nonatomic, strong) dispatch_queue_t queue2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.queue1 = dispatch_get_global_queue(0, 0);
    self.queue2 = dispatch_get_global_queue(0, 0);
    
    
//    [self test1];
    
    [self test2];
}


- (void)test1 {
    [self test:4 time2:2 uuid:@"1111"];
    [self test:2 time2:3 uuid:@"2222"];
}

- (void)test2 {
    [self asyncTest:4 time2:2 uuid:@"1111"];
    [self asyncTest:2 time2:3 uuid:@"2222"];
    [self asyncTest:10 time2:3 uuid:@"3333"];
}





- (void)test:(int)time1 time2:(int)time2 uuid:(NSString *)uuid {
    [self testWithGroup1:self.hitchAllGroup time:time1 uuid:uuid];
    [self testWithGroup2:self.hitchAllGroup time:time2 uuid:uuid];
    dispatch_group_notify(self.hitchAllGroup, dispatch_get_main_queue(), ^{
        NSLog(@"====dispatch_group_notify， uuid:%@", uuid);
    });
}

- (void)testWithGroup1:(dispatch_group_t)group time:(int)time uuid:(NSString *)uuid {
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(time);
        NSLog(@"====testWithGroup1, time:%d, uuid:%@", time, uuid);
        dispatch_group_leave(group);
    });
}
- (void)testWithGroup2:(dispatch_group_t)group time:(int)time uuid:(NSString *)uuid {
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(time);
        NSLog(@"====testWithGroup2, time:%d, uuid:%@", time, uuid);
        dispatch_group_leave(group);
    });
}





- (void)asyncTest:(int)time1 time2:(int)time2 uuid:(NSString *)uuid {
    [self asyncEvent1:self.hitchAllGroup time:time1 uuid:uuid];
    [self asyncEvent2:self.hitchAllGroup time:time2 uuid:uuid];
    dispatch_group_notify(self.hitchAllGroup, dispatch_get_main_queue(), ^{
        NSLog(@"====dispatch_group_notify， uuid:%@", uuid);
    });
}

- (void)asyncEvent1:(dispatch_group_t)group time:(int)time uuid:(NSString *)uuid {
    dispatch_group_enter(group);
    dispatch_async(self.queue1, ^{
        sleep(time);
        NSLog(@"====asyncEvent1, time:%d, uuid:%@, time:%d, thread:%@", time, uuid, time, NSThread.currentThread);
        dispatch_group_leave(group);
    });
}

- (void)asyncEvent2:(dispatch_group_t)group time:(int)time uuid:(NSString *)uuid {
    dispatch_group_enter(group);
    dispatch_async(self.queue2, ^{
        sleep(time);
        NSLog(@"====asyncEvent2, time:%d, uuid:%@, time:%d, thread:%@", time, uuid, time, NSThread.currentThread);
        dispatch_group_leave(group);
    });
}





- (dispatch_group_t)hitchAllGroup {
    if (!_hitchAllGroup) {
        _hitchAllGroup = dispatch_group_create();
    }
    return _hitchAllGroup;
}

@end
