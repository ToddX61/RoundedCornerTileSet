[![Swift 4.2](https://img.shields.io/badge/swift-5-red.svg?style=flat)](https://developer.apple.com/swift) [![Platform](http://img.shields.io/badge/platform-macOS-blue.svg?style=flat)](https://developer.apple.com/macos/) [![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/macos/) [![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)


# RoundedCornerTileSet
![Imgur](https://i.imgur.com/HxOflQS.png)

*RoundedCornerTileSet* programmatically creates SpriteKit SKTileSets suitable for use in any app or game that require a background grid with rounded corner tiles (for example, Match-3 games).

## Why?
The reason for using SKTileSets in my match-3 game was irresistable. I wanted the performace gains of using 1 SKNode for a background grid, instead of 81 (as it turned out it turned into to 2 nodes ... but still.)

I tried to make this work using Interface Builder in XCode. And tried... and tried... and tried. But never could. I'm not sure if it's my ignorance or the sparse documentation.  

Plus, I found it very cumbersome to add tile sets using InterfaceBuilder. So I decided to create mine programmatically.

## Installation

### CocoaPods

Simply add `pod RoundedCornerTileSet` to your podfile.

### Manual

Download from GitHub and add the files in the 'Sources' folder to your project.

## Using

The easiest way to learn *RoundedCornerTileSet* is to examine the *Example-macos* sample app.

Hint: the important stuff happens in ViewController:

`func createMap(scene: SKScene, tiles: [[Int]])`

Basically this method takes a 2D Array of Integers (columns,row) which defines which grid cells contain a 'filled' tile, and which do not.

First it creates the SKTileSet:

`tileSet = try RoundedCornerTileSet.create(textures: tileCache)`

then creates the SKNode using:

`RoundedCornerTileMapNode.create(tileSet: tileSet, grid: grid)`

where 'grid' is an Array2d<Int> from parameter 'tiles:'

(The Array2d generic is from [raywnderlich/swift-algorithim-club](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Array2D/Array2D.swift))

## RoundedCornerTileSet atlas

A sample atlas is provided in *Example-shared*.  Not including alternate resolutions (@2X, @3X, etc...), it contains 32 .png files. 16 for tiles that are 'filled' and 16 tiles for those that are empty.

The files in the atlas are named following the convention:

`<filled prefix>_xxxx.png` and `<not filled prefix>-.xxxx.png` where 'xxxx.png' represent the cardinal directions (north west, north east, south west, south east) that include a rounded corner.  

For example: 'rounded_1111.png' represents a tile where all four corners are rounded.

Similarly, 'inset_1111.png' represents an 'empty' tile where all four corner are inset with a rounded corner.

## I have to create 32 .png files?

You can.  But an easier method would be to use the svg files from *Example-shared* and modify them accordingly.

You can easily change the size of exported .png files with multiple resolutions using [Svg to Png](https://github.com/ToddX61/Svg-to-Png)

















