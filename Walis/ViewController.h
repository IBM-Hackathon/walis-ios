//
//  ViewController.h
//  Walis
//
//  Created by Marc Fiedler on 08/10/2016.
//  Copyright © 2016 snakeNet.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic)NSString *origin;

@end

