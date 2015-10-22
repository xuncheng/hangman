Hangman
===============================
Hangman 是一个双人游戏。一位玩家想一个字，另一位尝试猜该玩家所想的字中的每一个字母。详细介绍可以参考[中文Wiki](https://zh.wikipedia.org/wiki/猜單詞遊戲)。

开始游戏
-------------------------------
```console
ruby hangman.rb
```

测试结果
-------------------------------
根据[@luikore](https://github.com/luikore)的实现，80个单词中猜中的数量平均在72个左右，准确率超过90%，得分在1200～1300之间。

策略
-------------------------------
[贪心算法](https://zh.wikipedia.org/wiki/贪心法)，每次排除掉尽可能多的单词，让猜测步骤尽可能少。

关键步骤
-------------------------------
1. 找到单词长度中字母出现频率最高的去猜测
2. 猜测不成功的话，继续找下一个字母出现频率最好的字母的猜测
3. 字母猜测正确后，根据字母在单词里的位置过滤单词，然后找剩下单词里字母频率最好的字母去猜测
4. 重复以上步骤，直到猜测成功。
``` console
# => {"sessionId"=>"408b33250f829ffeba9dcc28f7b63a65", "data"=>{"totalWordCount"=>80, "correctWordCount"=>73, "totalWrongGuessCount"=>222, "score"=>1238}}
```

参考资源
-------------------------------
* https://zh.wikipedia.org/wiki/字母频率
* http://nifty.stanford.edu/2011/schwarz-evil-hangman/dictionary.txt
* http://www.datagenetics.com/blog/april12012/index.html
* [@luikore](https://github.com/luikore) 基于[决策树](https://zh.wikipedia.org/wiki/决策树)写的实现方法: https://gist.github.com/luikore/8011242
* https://github.com/mvj3/hangman
* https://github.com/spydez/hangman

TODO
-------------------------------
* 添加测试，包括功能测试和性能测试
* 和其它策略做比较，以元音、辅音间隔的方式去猜测
