//
//  ViewController.m
//  Walis
//
//  Created by Marc Fiedler on 08/10/2016.
//  Copyright © 2016 snakeNet.org. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (nonatomic)NSArray* history;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.origin = @"https://snakenet.org/api/walis";
    self.history = [NSArray array];
    
    NSDictionary *data = @{
                           @"Request": @"Pull",
                           @"Api": @{
                               @"Version": @"4.0"
                               }
                           };
    
    [self sendJsonRequest:data fromPath:nil withMethod:@"POST" addHeaders:nil completionHandler:^(BOOL success, NSDictionary* replyObject){
        if( success ){
            NSLog(@"Data: %@", replyObject);
            NSLog(@"Reloading Data");
            NSArray *data = [replyObject objectForKey:@"Data"];
            self.history = data;
            [self.historyTableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [_history[indexPath.row] objectForKey:@"content"];
    cell.detailTextLabel.text = @"Heute"; // [_history[indexPath.row] objectForKey:@"time"];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendJsonRequest:( NSDictionary * _Nullable )data fromPath:(NSString * _Nullable)path withMethod:(NSString * _Nullable)method addHeaders:(NSDictionary * _Nullable)headers completionHandler:(void (^ _Nullable)(BOOL successful, NSDictionary * _Nullable replyObject))completionHandler {
    
    // in case there is data to be sent, we append it as JSON
    NSString *jsonString = @"";
    if( data != nil ){
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // set the path according to the users whishes
    NSString *urlWithPath;
    if( path != nil ){
        // TODO we need to be careful with slashes and paths
        urlWithPath = [NSString stringWithFormat:@"%@%@", self.origin, path];
    }
    else{
        urlWithPath = self.origin;
    }
    
    // fallback in case no method was given
    if( method == nil ){
        method = @"GET";
    }
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlWithPath parameters:nil error:nil];
    
    //NSLog(@"Sending to: %@", urlWithPath);
    //NSLog(@"Sending data: %@", jsonString);
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if( headers != nil ){
        for (NSString *key in headers) {
            [req setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //NSLog(@"Reply JSON: %@", responseObject);
        
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if( completionHandler != nil ){
                    completionHandler(YES, (NSDictionary *)responseObject);
                }
            }
            else{
                if( completionHandler != nil ){
                    NSLog(@"Unknown Api Error[1]: %@, %@, %@", error, response, responseObject);
                    completionHandler(NO, nil);
                }
            }
        } else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                // if possible handle errors inside the API and don't forward every error to the user
                NSDictionary *apiResponse = (NSDictionary *)responseObject;
                if( apiResponse != nil ){
                    if( completionHandler != nil ){
                        // since the endppint can be quite different, we also can not 100% distinguish between reply
                        // codes at this point, there should be a handler for each endpoint.
                        completionHandler(NO, apiResponse);
                    }
                }
                else{
                    if( completionHandler != nil ){
                        NSLog(@"Unknown Api Error[2]: %@, %@, %@", error, response, responseObject);
                        completionHandler(NO, nil);
                    }
                }
            }
            else{
                if( completionHandler != nil ){
                    NSLog(@"Unknown Api Error[3]: %@, %@, %@", error, response, responseObject);
                    completionHandler(NO, nil);
                }
            }
        }
    }] resume];
}



@end
