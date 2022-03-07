## Flutter 扫码枪支持

本 `package` 依赖 `EditableText` 原理，实现 flutter 端扫码能力支持。

### 引入

在pubspec.yaml文件中进行引用：
```
dependencies:
  scan_gun: ^1.0.0
```
### 使用方式：
提供 `ScanMonitorWidget` 作为父节点，嵌套使用：

```
  ScanMonitorWidget({
    Key? key,
    required ChildBuilder childBuilder,
    FocusNode? scanNode,
    FocusNode? textFiledNode,
    required void Function(String) onSubmit,
  })
```
参数说明:

+ childBuilder :

`typedef ChildBuilder = Widget Function(BuildContext context)`，使用者自己UI作为子节点

+ scanNode:

1. 非必传，如果传，可通过 `scanNode` 监听获取当前扫码可用状态，`hasFocus` 时为可用
2. 也可通过 `scanNode` requestFocus 方法，强制扫码获取焦点，保证扫码能力；

+ textFiledNode:

提供外部存在输入框键盘输入与扫码输入同时存在的场景。内部做了焦点切换能力，保证输入框焦点取消后，能马上切换成扫码枪的焦点

+ onSubmit:

接收扫码枪返回的结果

### 适用场景及Demo演示：

#### 1. 无输入框交互，获取扫码结果：
```
@override
  Widget build(BuildContext context) {
    return ScanMonitorWidget(
      childBuilder: (context) {
        return body();
      },
      onSubmit: (String result) {
        print(result); //接收到扫码结果
      },
    );
  }

```
#### 2. 带输入框交互，获取扫码结果：
```
FocusNode textFiledNode = FocusNode();
TextEditingController controller = TextEditingController();

 Widget body() {
  return TextField(
     focusNode: textFiledNode,
     controller: controller,
   );
 }

@override
  Widget build(BuildContext context) {
    return ScanMonitorWidget(
      textFiledNode: textFiledNode,
      childBuilder: (context) {
        return body();
      },
      onSubmit: (String result) {
        print(result); //接收到扫码结果
      },
    );
  }
```

### 详细使用方式可查看 example ：
![](https://upload-images.jianshu.io/upload_images/25776880-f1664d5a2e720761.gif?imageMogr2/auto-orient/strip)

[技术点分析](https://www.jianshu.com/p/33675f2c352f)