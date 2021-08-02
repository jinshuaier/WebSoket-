//
//  ViewController.m
//  WebSoketDemo
//
//  Created by jin on 2021/7/26.
//

#import "ViewController.h"
#import <SocketRocket/SRWebSocket.h>

@interface ViewController ()<SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"webSoketDemo";
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(100, 100, 50, 50);
    btn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UIButton *btn_pic = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn_pic.frame = CGRectMake(100, 200, 50, 50);
    btn_pic.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    [btn_pic addTarget:self action:@selector(btn_pic:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn_pic];
    
    UIButton *btn_mp3 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn_mp3.frame = CGRectMake(100, 300, 50, 50);
    btn_mp3.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    [btn_mp3 addTarget:self action:@selector(btn_mp3:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn_mp3];
    
    //创建Socket
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.0.241:80/test"]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
    
    
    // Do any additional setup after loading the view.
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;{

    NSLog(@"Websocket Connected");

    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"id":@"chat",@"clientid":@"hxz",@"to":@""} options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [webSocket send:jsonString];
}



 

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;{

    NSLog(@":( Websocket Failed With Error %@", error);

    webSocket = nil;

}

 

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;{

    NSLog(@"Received \"%@\"", message);

}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;{

   NSLog(@"WebSocket closed");

   webSocket = nil;

}
//其中webSocketDidOpen是在链接服务器成功后回调的方法，在这里发送一次消息，把id 名字发送到服务器，告知服务器，
//发送消息
- (void)btnAction:(UIButton *)sender {
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"id":@"chat",@"clientid":@"hxz",@"to":@"mary",@"msg":@{@"type":@"0",@"content":@"hhh"}} options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [self.webSocket send:jsonString];
}

//发送图片文件
- (void)btn_pic:(UIButton *)sender {
    
    NSString *str=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"22.jpg"];
    NSLog(@"Path: %@", str);
    NSData *fileData = [NSData dataWithContentsOfFile:str];
    NSLog(@"Data: %@", fileData);
    UIImage *image = [UIImage imageWithData:fileData];
    //UIImage转换为NSData
    NSData *imageData = UIImageJPEGRepresentation(image,1.0f);//第二个参数为压缩倍数
    [self.webSocket send:imageData];

    NSLog(@"%@", imageData);
}

//发送mp3文件

- (void)btn_mp3:(UIButton *)sender {
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);

    dispatch_async(dispatchQueue,^(void){

       NSString*filePath = [[NSBundle mainBundle] pathForResource:@"0001" ofType:@"mp3"];

       NSData* data= [NSData dataWithContentsOfFile:filePath];
        [self.webSocket send:data];
    });
}

@end
