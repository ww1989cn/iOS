//
//  ViewController.m
//  UDPTest
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 walkera. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"


#define LOGIN           0x10
#define LOGOUT          0x11
#define P2PTRANS        0x12
#define GETALL          0x13
#define GETALLACK       0x14
#define USERINFO        0x16
#define CALLYOU         0x15
#define P2PTRASH        0x17
#define P2PMESSAGE      0x18
#define P2PMESSAGEACK   0x19



@interface ViewController () <GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic) BOOL receivedACK;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    NSError *err;
    [self.udpSocket bindToPort:10010 error:&err];
    
    if (err!=nil) {
        NSLog(@"%@", err);
    }
    
    char buf[3] = {0xff, 0xff, LOGIN};
    char name[] = "wei";
    
    char msg[1024];
    
    memcpy(msg, buf, 3);
    memcpy(msg+3,name, sizeof(name)-1);
    
    [self.udpSocket sendData:[NSData dataWithBytes:msg length:3+sizeof(name)-1] toHost:@"127.0.0.1" port:10086 withTimeout:-1 tag:0];
 //    [self.udpSocket sendData:[NSData dataWithBytes:buf length:3] toHost:@"127.0.0.1" port:10086 withTimeout:-1 tag:0];
    [self.udpSocket beginReceiving:&err];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendMessage : (NSData *)data toHost: (NSString *) host port:(uint16_t)port
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<5; i++) {
            self.receivedACK = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
            });
            
            for (int j=0; j<10; j++) {
                if (self.receivedACK)
                {
                    return;
                }
                else
                {
                    [NSThread sleepForTimeInterval:0.1f];
                }
            }
        }
    });

}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
   // NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
   // NSLog(@"%@", str);

    unsigned char *buf = (unsigned char *)[data bytes];
    unsigned char *buf1 = (unsigned char *)malloc(data.length+1);
    memcpy(buf1, buf, data.length);
    buf1[data.length] = 0;
    
    if (buf[0]==0xff && buf[1]==0xff) {
        switch (buf[2]) {
            case CALLYOU:
            {
                NSString *info = [NSString stringWithCString:&buf1[3] encoding:NSASCIIStringEncoding];
                NSArray *arr = [info componentsSeparatedByString:@":"];
                unsigned char temp[3] = {0xFF,0xFF, P2PTRASH};
                NSLog(@"%@:%@ want to call you", arr[0], arr[1]);
                NSString *ip = arr[0];
                NSString *port = arr[1];
            
                [self.udpSocket sendData:[NSData dataWithBytes:temp length:3] toHost:ip port:port.integerValue withTimeout:-1 tag:0];
                break;
            }
            case USERINFO:
            {
                NSString *info = [NSString stringWithCString:&buf1[3] encoding:NSASCIIStringEncoding];
            
                NSLog(@"%@", info);
                
                break;
            }
            case P2PMESSAGE:
            {
                break;
            }
            case P2PMESSAGEACK:
            {
                self.receivedACK = YES;
                break;
            }
            
            default:
                break;
        }
    }
}



@end
