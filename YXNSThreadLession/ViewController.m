//
//  ViewController.m
//  YXNSThreadLession
//
//  Created by 郭亚鑫 on 15/8/25.
//  Copyright (c) 2015年 yaxin.guo. All rights reserved.
//

#import "ViewController.h"
#import "YXImageData.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *showImage;

@end


#define ImageURL @"http://www.futureinst.com//images/future_events/future_1039949198165891977_event.jpeg"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray array];
    for (int i = 0; i< 4; i++) {
        for (int j = 0; j<3; j++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i * 100, j*100, 100, 100)];
            [self.view addSubview:image];
            [self.imageArray addObject:image];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击按钮开始下载的方法
- (IBAction)downloadImgBtnClicked:(UIButton *)sender {
    NSMutableArray *threads = [NSMutableArray array];
    for (int i=0; i<12; i++) {
        //创建12个线程，每个线程去下载
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];//设置线程名称
        if (i == 11) {
            [thread setThreadPriority:1];
        }
        else {
            [thread setThreadPriority:0.1];
        }
        [threads addObject:thread];
        
    }
    for (int i=0; i<12; i++) {
        NSThread *thread = [threads objectAtIndex:i];
        [thread start];
    }
}

//下载图片
- (void)loadImage:(NSNumber *)index
{
    if (index.intValue != 11) {
        [NSThread sleepForTimeInterval:3];
    }
    NSData *data = [self requestData];
    YXImageData *yxData = [[YXImageData alloc] init];
    yxData.index = index.intValue;
    yxData.imageData = data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:yxData waitUntilDone:YES];
    
}

//使用url请求图片
- (NSData *)requestData
{
    NSURL *dataUrl = [NSURL URLWithString:ImageURL];
    NSData *data = [NSData dataWithContentsOfURL:dataUrl];
    return data;
}

//显示图片
- (void)updateImage:(YXImageData *)imageData
{
    UIImageView *tempData = self.imageArray[imageData.index];
    tempData.image = [UIImage imageWithData:imageData.imageData];
}

@end
