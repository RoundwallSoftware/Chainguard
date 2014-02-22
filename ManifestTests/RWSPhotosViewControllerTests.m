//
//  RWSPhotosViewControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSPhotosViewController.h"
#import "RWSProject.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSPhotosViewControllerTests : XCTestCase {
    RWSPhotosViewController *controller;
}

@end

@implementation RWSPhotosViewControllerTests

- (void)setUp
{
    [super setUp];

    controller = [[RWSPhotosViewController alloc] init];
}

- (void)testControllerUsesItemForCellCount
{
    id<RWSItem> item = mockProtocol(@protocol(RWSItem));
    controller.item = item;

    [given([item photoCount]) willReturnInteger:4];

    assertThatInteger([controller collectionView:nil numberOfItemsInSection:0], equalToInteger(4));
}

- (void)testControllerUsesSpecificPhotoForCells
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    id<RWSItem> item = mockProtocol(@protocol(RWSItem));
    controller.item = item;

    [controller collectionView:nil cellForItemAtIndexPath:indexPath];

    [verify(item) photoAtIndexPath:indexPath];
}

- (void)testControllerGivesImageToItem
{
    UIImage *image = [self pokemonImage];
    NSDictionary *info = @{ UIImagePickerControllerOriginalImage: image };
    id<RWSItem> item = mockProtocol(@protocol(RWSItem));
    controller.item = item;

    [controller imagePickerController:nil didFinishPickingMediaWithInfo:info];

    [verify(item) addPhotoWithImage:image];
}

- (UIImage *)pokemonImage
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"Pokemon" ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
}

@end
