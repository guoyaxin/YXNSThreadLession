#YXNSThreadLession
##通过使用NSThread类来讲解iOS中的多线程，创建了12个线程，来下载12张图片，而且把最后一个线程的优先级设置成最高，其他线程在最后一个线程执行完毕之后在执行
##ViewController.m 
###1.点击按钮下载的方法来开始执行
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

###2.下载图片，当下载完成之后，去主线程中刷新UI，来显示图片
    
    -(void)loadImage:(NSNumber *)index{
    	if (index.intValue != 11) {
        	[NSThread sleepForTimeInterval:3];
    	}
    	NSData *data = [self requestData];
    	YXImageData *yxData = [[YXImageData alloc] init];
    	yxData.index = index.intValue;
    	yxData.imageData = data;
    	[self performSelectorOnMainThread:@selector(updateImage:) withObject:yxData waitUntilDone:YES];
    }
   
###3.使用url请求图片，把请求回来的数据保存在NSData中
    - (NSData *)requestData
	{
    	NSURL *dataUrl = [NSURL URLWithString:ImageURL];
    	NSData *data = [NSData dataWithContentsOfURL:dataUrl];
    	return data;
	}
	
###4.显示图片    
    - (void)updateImage:(YXImageData *)imageData
	{
    	UIImageView *tempData = self.imageArray[imageData.index];
    	tempData.image = [UIImage imageWithData:imageData.imageData];
	}    


##YXImageData 包含了一个index和NSData
    @interface YXImageData : NSObject
    @property (nonatomic, assign) int index;
    @property (nonatomic, retain) NSData *imageData;
    @end






















