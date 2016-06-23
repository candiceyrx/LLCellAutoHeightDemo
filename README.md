# CocoaPods导入Masonry,提示找不到头文件的解决方法

第一步, 找到TARGETS -> Build Settings -> SearchPaths -> User Header Search Paths 在后面的空白处双击

第二步, 点击 ‘+’号,添加一个新的键为${SRCROOT},值设置为recursive

完成以上两步，在引入头文件就OK了！

温馨提醒：使用Masonry进行约束的视图一定要记得添加到父视图上，否则程序会崩溃哦！
