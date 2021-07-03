## DartMars是什么

`DartMars` 是服务端开发框架，能够帮助开发者以 `Dart` 语言为基础，快速开发服务端应用。

[中文文档](https://tangpanqing.github.io/dart_mars_docs/zh/)

## 开始一个项目如此简单

```
# 安装DartMars
dart pub global activate --source git https://github.com/tangpanqing/dart_mars.git

# 创建项目
dart pub global run dart_mars --create project_name

# 进入目录
cd project_name

# 获取依赖
dart pub global run dart_mars --get 

# 启动项目
dart pub global run dart_mars --serve dev
```