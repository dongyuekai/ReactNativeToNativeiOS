把React Native组件植入到iOS应用中有如下几个主要步骤：

首先当然要了解你要植入的React Native组件。
创建一个Podfile，在其中以subspec的形式填写所有你要植入的React Native的组件。
创建js文件，编写React Native组件的js代码。
添加一个事件处理函数，用于创建一个RCTRootView。这个RCTRootView正是用来承载你的React Native组件的，而且它必须对应你在index.ios.js中使用AppRegistry注册的模块名字。
启动React Native的Packager服务，运行应用。
根据需要添加更多React Native的组件。
调试。
准备部署发布 （比如可以利用react-native-xcode.sh脚本）。
发布应用，升职加薪，走向人生巅峰！😘
1. 创建一个原生应用
这个就不多说。

2. 添加依赖包
React Native的植入过程同时需要React和React Native两个node依赖包。我们把具体的依赖包记录在package.json文件中。如果项目根目录中没有这个文件，那就自己创建一个。

2.1 package.json
我这里的做法是在项目的根目录下创建一个专门存放react native相关的文件夹，就像这样：

RNComponent文件夹
然后在这个文件夹下创建一个package.json文件，就像这样：

package.json文件
在package.json文件中的内容是这样的：

{
    "name": "NativeRN",
    "version": "0.0.1",
    "private": true,
    "scripts": {
        "start": "node node_modules/react-native/local-cli/cli.js start"
    },
    "dependencies": {
        "react": "16.0.0-alpha.6",
        "react-native": "0.44.0"
    }
}

解释一下：

version字段没有太大意义（除非你要把你的项目发布到npm仓库）。
scripts中是用于启动packager服务的命令。
dependencies中的react和react-native的版本取决于你的具体需求。一般来说我们推荐使用最新版本。你可以使用npm info react和npm info react-native来查看当前的最新版本。另外，react-native对react的版本有严格要求，高于或低于某个范围都不可以。
本文无法在这里列出所有react native和对应的react版本要求，只能提醒读者先尝试执行npm install，然后注意观察安装过程中的报错信息，例如require react@某.某.某版本, but none was installed，然后根据这样的提示，执行npm i -S react@某.某.某版本。

2.2 安装依赖包
使用npm（node包管理器，Node package manager）来安装React和React Native模块。这些模块会被安装到项目根目录下的node_modules/目录中。 在包含有package.json文件的目录（一般也就是项目根目录,我这里因为创建了RNComponent文件夹，所以是在这个文件夹目录下执行这个命令）中运行下列命令来安装：

$ npm install
运行完成后会出现node_modules这样一个文件夹，这个文件夹下包含了RN的一些模块，就像这样：

执行命令安装模块
3. React Native框架
React Native框架整体是作为node模块安装到项目中的。下一步我们需要在CocoaPods的Podfile中指定我们所需要使用的组件。

3.1 Subspecs
在你开始把React Native植入到你的应用中之前，首先要决定具体整合的是React Native框架中的哪些部分。而这就是subspec要做的工作。在创建Podfile文件的时候，需要指定具体安装哪些React Native的依赖库。所指定的每一个库就称为一个subspec。

可用的subspec都列在node_modules/react-native/React.podspec中，基本都是按其功能命名的。一般来说你首先需要添加Core，这一subspec包含了必须的AppRegistry、StyleSheet、View以及其他的一些React Native核心库。如果你想使用React Native的Text库（即<Text>组件），那就需要添加RCTText的subspec。同理，Image需要加入RCTImage，等等。

3.2 Podfile
在React和React Native模块成功安装到node_modules目录之后，你就可以开始创建Podfile以便选择所需的组件安装到应用中。

创建podfile在这里不在多说，相信只要用过cocoapods的朋友都知道。

podfile创建完成之后，在文件里添加一下内容：

# target的名字一般与你的项目名字相同
target 'NativeRN' do

  # 'node_modules'目录一般位于根目录中
  # 但是如果你的结构不同，那你就要根据实际路径修改下面的`:path`
  pod 'React', :path => './RNComponent/node_modules/react-native', :subspecs => [
    'Core',
    'RCTText',
    'RCTNetwork',
    'RCTWebSocket', # 这个模块是用于调试功能的
    # 在这里继续添加你所需要的模块
  ]
  # 如果你的RN版本 >= 0.42.0，请加入下面这行
  pod "Yoga", :path => "./RNComponent/node_modules/react-native/ReactCommon/yoga"

end
然后执行下面的👇命令，开始安装React Native的pod包。

$ pod install
4. 代码集成
4.1 index.ios.js
首先创建一个空的index.ios.js文件。一般来说我们把它放置在项目根目录下。就像👇：

index.ios.js
index.ios.js是React Native应用在iOS上的入口文件。而且它是不可或缺的！它可以是个很简单的文件，简单到可以只包含一行require/import导入语句。

# 在项目根目录执行以下命令创建文件：
$ touch index.ios.js
4.2 添加你自己的React Native代码
import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';

export default class NativeRN extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('NativeRN', () => NativeRN);
4.3 集成到原生项目中
我这里先创建了一个ViewController，👇这样：

RNViewController
然后导入#import <RCTRootView.h>头文件,👇这样：

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * strUrl = @"http://localhost:8081/index.ios.bundle?platform=ios&dev=true";
    NSURL * jsCodeLocation = [NSURL URLWithString:strUrl];
    
    RCTRootView * rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                         moduleName:@"NativeRN"
                                                  initialProperties:nil
                                                      launchOptions:nil];
    self.view = rootView;
    
}

4.4 配置info.plist
还需要在info.plist文件中配置一下：

<key>NSAppTransportSecurity</key>
  <dict>
    <key>NSExceptionDomains</key>
    <dict>
      <key>localhost</key>
      <dict>
       <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
       <true/>
      </dict>
    </dict>
  </dict>
配置后的效果：

配置info.plist
5. 运行项目
在运行项目前，先在react native文件夹目录下，启动开发服务器。也就是在本文中的RNComponent目录下，启动命令行：

$ npm start
运行项目，看到效果：

效果图
