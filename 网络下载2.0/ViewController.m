//
//  ViewController.m
//  网络下载2.0
//
//  Created by kai on 16/3/30.
//  Copyright © 2016年 K.K Studio. All rights reserved.
//
#define URL @"http://10.10.5.54:8080/dzq.wav"
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *downLoadLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *downLoadProgress;
- (IBAction)downLoad:(UIButton *)sender;

@property (nonatomic,assign) long long totleLenth;
@property (nonatomic,assign) long long currentLenth;

@property (nonatomic,strong) NSFileHandle *myHandle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)downLoad:(UIButton *)sender {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:0 timeoutInterval:30];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.totleLenth = response.expectedContentLength;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"MYDZQ.wav"];
    
    NSFileManager *manager = [[NSFileManager alloc]init];
    [manager createFileAtPath:filePath contents:nil attributes:nil];
    
    self.myHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    NSLog(@"didReceiveResponse");
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    self.currentLenth += data.length;
    
    float precent = (double)self.currentLenth / self.totleLenth;
    
    self.downLoadLabel.text = [NSString stringWithFormat:@"进度:%.02f％",precent*100];
    
    self.downLoadProgress.progress = precent;
    
    [self.myHandle seekToEndOfFile];
    [self.myHandle writeData:data];
    NSLog(@"didReceiveData %ld",data.length);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.myHandle closeFile];
    
    NSLog(@"connectionDidFinishLoading");
}



@end
