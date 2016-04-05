//
//  HeatmapViewController.m
//  Caremob
//
//  Created by Rick Strom on 9/1/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "HeatmapViewController.h"

@interface HeatmapViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *heatmapOverlayImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveNowLabel;
@property (weak, nonatomic) IBOutlet UIImageView *liveNowContainer;

@end

@implementation HeatmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userPins = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addUserPin:(PFObject*)user atLatitude:(double)latitude andLongitude:(double)longitude isCurrentUser:(BOOL)isCurrentUser {
    
    if (!isCurrentUser) {
        HeatmapMobberPinViewController *newPin = [[HeatmapMobberPinViewController alloc] initWithNibName:@"HeatmapMobberPinViewController" bundle:nil];
    
        [newPin initializeWithUser:user isCurrentUser:isCurrentUser];
    
        double originX = self.view.frame.size.width / 2;
        double originY = 94 - 8; // 11 error minus half height of pin
    
        double xPos = (50.0 * cos(latitude*M_PI/180.0) + 110.0) * longitude / (180.0);
        double yPos = (latitude * 31.0) / 30.0;
        NSLog(@"height of map is %f", self.view.frame.size.height);
    
        NSLog(@"Got position: %f,%f", xPos, yPos);
    
        newPin.view.center = CGPointMake(originX + xPos, originY - yPos);
        [self.view addSubview:newPin.view];
        [self.view bringSubviewToFront:newPin.view];
    
        [self.userPins addObject:newPin];
        
    } else {
        HeatmapUserPinViewController *newPin = [[HeatmapUserPinViewController alloc] initWithNibName:@"HeatmapUserPinViewController" bundle:nil];
        
        [newPin initializeWithUser:user isCurrentUser:isCurrentUser];
        
        double originX = self.view.frame.size.width / 2;
        double originY = 94 - 7;
        
        double xPos = (50.0 * cos(latitude*M_PI/180.0) + 110.0) * longitude / (180.0);
        double yPos = (latitude * 31.0) / 30.0;
        NSLog(@"height of map is %f", self.view.frame.size.height);
        
        NSLog(@"Got position: %f,%f", xPos, yPos);
        
        newPin.view.center = CGPointMake(originX + xPos, originY - yPos);
        [self.view addSubview:newPin.view];
        [self.view bringSubviewToFront:newPin.view];

        self.currentUserPin = newPin;
    }
}

-(void)removeCurrentUserPin {
    if (self.currentUserPin != nil) {
        //[self.currentUserPin.view removeFromSuperview];
        [self.currentUserPin hideAndRemoveFromSuperview];
        self.currentUserPin = nil;
    }
}

-(void)showUserPinsForMobActionFootprints:(NSArray*)mobActionFootprints {
    // NOTE: this assumes a list of users who AREN'T the current user!
    
    NSLog(@"Got %lu footprints to process", (unsigned long)mobActionFootprints.count);
    
    if (mobActionFootprints == nil) return;
    
    // First remove any users who are shown who aren't in the display
    NSMutableArray *pinsToRemove = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.userPins.count; i++) {
        HeatmapMobberPinViewController *thisPin = (HeatmapMobberPinViewController*)self.userPins[i];
        PFObject *thisPinUser = (PFObject*)thisPin.user;
        
        BOOL userIsStillInList = NO;
        for (int j = 0; j < mobActionFootprints.count; j++) {
            PFObject *thisMobActionFootprint = (PFObject*)mobActionFootprints[j];
            PFObject *thisMobActionFootprintUser = (PFObject*)[thisMobActionFootprint objectForKey:kMobActionFootprintUserKey];
            if ([thisMobActionFootprintUser.objectId isEqualToString:thisPinUser.objectId]) userIsStillInList = YES;
        }
        
        if (!userIsStillInList) {
            NSLog(@"Removing user %@", thisPinUser.objectId);
            //[thisPin.view removeFromSuperview];
            [thisPin hideAndRemoveFromSuperview];
            
            [pinsToRemove addObject:thisPin];
        } else NSLog(@"User is still in list");
    }
    
    NSLog(@"Removing %lu user pins", (unsigned long)pinsToRemove.count);
    [self.userPins removeObjectsInArray:pinsToRemove];
    
    // Next add any new users to the display
    for (int i = 0; i < mobActionFootprints.count; i++) {
        NSLog(@"Processing pin %d", i);
        
        PFObject *thisMobActionFootprint = (PFObject*)mobActionFootprints[i];
        PFObject *thisMobActionFootprintUser = (PFObject*)[thisMobActionFootprint objectForKey:kMobActionFootprintUserKey];
        PFGeoPoint *thisMobActionFootprintGeoPoint = (PFGeoPoint*)[thisMobActionFootprint objectForKey:kMobActionFootprintLocationKey];
        
        // Only process footprints with geo data
        if (thisMobActionFootprintGeoPoint != nil) {
            NSLog(@"this user id is %@", thisMobActionFootprintUser.objectId);
            BOOL userIsAlreadyShown = NO;
            for (int j = 0; j < self.userPins.count; j++) {
                HeatmapMobberPinViewController *thisPin = (HeatmapMobberPinViewController*)self.userPins[j];
                PFObject *thisPinUser = thisPin.user;
                
                if ([thisPinUser.objectId isEqualToString:thisMobActionFootprintUser.objectId]) userIsAlreadyShown = YES;
            }
            
            if (!userIsAlreadyShown) {
                // Create and place the pin
                NSLog(@"Adding pin for %@", [thisMobActionFootprintUser objectForKey:kUserFieldNameKey]);
                [self addUserPin:thisMobActionFootprintUser atLatitude:thisMobActionFootprintGeoPoint.latitude andLongitude:thisMobActionFootprintGeoPoint.longitude isCurrentUser:NO];
            } else NSLog(@"User is already shown");
        } else NSLog(@"Geopoint was nil");
    }
    
    // Update the "live now" count
    self.liveNowLabel.text = [NSString stringWithFormat:@"%lu", (self.userPins.count + 1)];
}

-(void)showHeatForMobActions:(NSArray*)mobActions withMobType:(NSString*)mobType {
    self.heatmapOverlayImageView.image = [UIImage imageNamed:@"heatmap_transparent"];
    //NSString *mobType = @"mourning";

    // Remove all subviews from the heatmap overlay image
    for (UIView *subview in self.heatmapOverlayImageView.subviews) {
        [subview removeFromSuperview];
    }
    
    int mapWidth = 320;
    int mapHeight = 188;
    
    int heatpoints[mapWidth][mapHeight];
    for (int x = 0; x < mapWidth; x++)
        for (int y = 0; y < mapHeight; y++)
            heatpoints[x][y] = 0;
    
    if (mobActions == nil) return;
    
    for (int i = 0; i < mobActions.count; i++) {
        PFObject *mobAction = (PFObject*)mobActions[i];
        NSNumber *mobActionPoints = (NSNumber*)[mobAction objectForKey:kMobActionPointsKey];
        
        int points = 0;

        PFGeoPoint *location = (PFGeoPoint*)[mobAction objectForKey:kMobActionLocationKey];
        if (location == nil) continue;
        else {
            double latitude = location.latitude;
            double longitude = location.longitude;
    
            double originX = self.heatmapOverlayImageView.frame.size.width / 2;
            double originY = 94; // 11 error minus half height of pin
    
            double xPos = (50.0 * cos(latitude*M_PI/180.0) + 110.0) * longitude / (180.0);
            double yPos = (latitude * 31.0) / 30.0;
    
            int pointX = (int)(originX + xPos);
            int pointY = (int)(originY - yPos);
    
            if (pointX < 0) pointX = 0;
            if (pointX >= mapWidth) pointX = mapWidth - 1;
    
            if (pointY < 0) pointX = 0;
            if (pointY >= mapHeight) pointX = mapHeight - 1;

            // Snap to grid
            pointX = pointX / 4;
            pointX = pointX * 4;
            pointX += 2;

            pointY = pointY / 4;
            pointY = pointY * 4;
            pointY += 10;
            
            if (mobActionPoints != nil) points = [mobActionPoints intValue];
        
            heatpoints[pointX][pointY] += points;
        }
    }
    
    // Place the heat underlays
    for (int x = 0; x < mapWidth; x++) {
        for (int y = 0; y < mapHeight; y++) {
            if (heatpoints[x][y] > 0) {
                int heatLevel = 0;
                
                if (heatpoints[x][y] <= 1) heatLevel = 0;
                else if (heatpoints[x][y] <= 3) heatLevel = 1;
                else if (heatpoints[x][y] <= 5) heatLevel = 2;
                else if (heatpoints[x][y] <= 10) heatLevel = 3;
                else if (heatpoints[x][y] <= 20) heatLevel = 4;
                else if (heatpoints[x][y] <= 30) heatLevel = 5;
                else if (heatpoints[x][y] <= 40) heatLevel = 6;
                else if (heatpoints[x][y] <= 50) heatLevel = 7;
                else if (heatpoints[x][y] <= 75) heatLevel = 8;
                else heatLevel = 9;
                
                UIImageView *newHeatUnderlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"heatmap_heat_%@_underlay_%d", mobType, heatLevel]]];
                newHeatUnderlay.center = CGPointMake(x, y);
                
                [self.heatmapOverlayImageView addSubview:newHeatUnderlay];
                [self.heatmapOverlayImageView bringSubviewToFront:newHeatUnderlay];
                
                //NSLog(@"Placed heat underlay level %d at point %d, %d because points was %d", heatLevel, x, y, heatpoints[x][y]);
            }
        }
    }

    // Place the heat
    for (int x = 0; x < mapWidth; x++) {
        for (int y = 0; y < mapHeight; y++) {
            if (heatpoints[x][y] > 0) {
                int heatLevel = 0;
                
                if (heatpoints[x][y] <= 1) heatLevel = 0;
                else if (heatpoints[x][y] <= 3) heatLevel = 1;
                else if (heatpoints[x][y] <= 5) heatLevel = 2;
                else if (heatpoints[x][y] <= 10) heatLevel = 3;
                else if (heatpoints[x][y] <= 20) heatLevel = 4;
                else if (heatpoints[x][y] <= 30) heatLevel = 5;
                else if (heatpoints[x][y] <= 40) heatLevel = 6;
                else if (heatpoints[x][y] <= 50) heatLevel = 7;
                else if (heatpoints[x][y] <= 75) heatLevel = 8;
                else heatLevel = 9;
                
                UIImageView *newHeat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"heatmap_heat_%@_%d", mobType, heatLevel]]];
                newHeat.center = CGPointMake(x, y);
                
                [self.heatmapOverlayImageView addSubview:newHeat];
                [self.heatmapOverlayImageView bringSubviewToFront:newHeat];
                
                NSLog(@"Placed heat level %d at point %d, %d because points was %d", heatLevel, x, y, heatpoints[x][y]);
            }
        }
    }
    
    // Here we should compress the heat into the transparency
}

-(UIImage*)getFlattenedImage {
    self.liveNowContainer.hidden = YES;
    self.liveNowLabel.hidden = YES;
    
    CGRect screenRect = self.view.layer.bounds;
    //UIImage *screenshot = [self captureScreenInRect:CGRectMake(0.0, 0.0, screenRect.size.width, screenRect.size.height)];
    UIImage *screenshot = [self captureScreenInRect:screenRect];
    
    self.liveNowContainer.hidden = NO;
    self.liveNowLabel.hidden = NO;
    
    return screenshot;
}

- (UIImage *)captureScreenInRect:(CGRect)captureFrame {
    CALayer *layer;
    layer = self.view.layer;
    
    UIGraphicsBeginImageContext(captureFrame.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

@end
