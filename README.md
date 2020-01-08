# BypassAntiVirus

**本文为Tide安全团队成员`重剑无锋`原创文章，转载请声明出处！**

**郑重声明：文中所涉及的技术、思路和工具仅供以安全为目的的学习交流使用，任何人不得将其用于非法用途以及盈利等目的，否则后果自行承担！**

一直是从事web安全多一些，对waf绕过还稍微有些研究，但是对远控免杀的认知还大约停留在ASPack、UPX加壳免杀的年代。近两年随着hw和红蓝对抗的增多，接触到的提权、内网渗透、域渗透也越来越多。攻击能力有没有提升不知道，但防护水平明显感觉提升了一大截，先不说防护人员的技术水平如果，最起码各种云WAF、防火墙、隔离设备部署的多了，服务器上也经常能见到安装了杀软、软waf、agent等等，特别是某数字杀软在国内服务器上尤为普及。这个时候，不会点免杀技术就非常吃亏了。

但是因为对逆向和二进制都不大熟，编译运行别人的代码都比较费劲，这时候就只能靠现成的工具来曲线救国了。为此，从互联网上搜集了二三十种免杀的方法，对msf或CS进行免杀测试，大部分都是互联网已有的方法，感谢大佬们的无私分享，我只是进行了重新汇总整理。

实验主要是使用了metasploit或cobaltstrike生成的代码或程序进行免杀处理，在实验机器上安装了360全家桶和火绒进行本地测试，在`https://www.virustotal.com/`上进行在线查杀。


# 文章导航

1、远控免杀专题(1)-基础篇：[https://mp.weixin.qq.com/s/3LZ_cj2gDC1bQATxqBfweg](https://mp.weixin.qq.com/s/3LZ_cj2gDC1bQATxqBfweg)

2、远控免杀专题(2)-msfvenom隐藏的参数：[https://mp.weixin.qq.com/s/1r0iakLpnLrjCrOp2gT10w](https://mp.weixin.qq.com/s/1r0iakLpnLrjCrOp2gT10w)

3、远控免杀专题(3)-msf自带免杀(VT免杀率35/69)：[https://mp.weixin.qq.com/s/A0CZslLhCLOK_HgkHGcpEA](https://mp.weixin.qq.com/s/A0CZslLhCLOK_HgkHGcpEA)

4、远控免杀专题(4)-Evasion模块(VT免杀率12/71)：[https://mp.weixin.qq.com/s/YnnCM7W20xScv52k_ubxYQ](https://mp.weixin.qq.com/s/YnnCM7W20xScv52k_ubxYQ)

5、远控免杀专题(5)-Veil免杀(VT免杀率23/71):[https://mp.weixin.qq.com/s/-PHVIAQVyU8QIpHwcpN4yw](https://mp.weixin.qq.com/s/-PHVIAQVyU8QIpHwcpN4yw)

6、远控免杀专题(6)-Venom免杀(VT免杀率11/71):[https://mp.weixin.qq.com/s/CbfxupSWEPB86tBZsmxNCQ](https://mp.weixin.qq.com/s/CbfxupSWEPB86tBZsmxNCQ)

7、远控免杀专题(7)-Shellter免杀(VT免杀率7/69)：[https://mp.weixin.qq.com/s/ASnldn6nk68D4bwkfYm3Gg](https://mp.weixin.qq.com/s/ASnldn6nk68D4bwkfYm3Gg)

8、远控免杀专题(8)-BackDoor-Factory免杀(VT免杀率13/71)：[https://mp.weixin.qq.com/s/A30JHhXhwe45xV7hv8jvVQ](https://mp.weixin.qq.com/s/A30JHhXhwe45xV7hv8jvVQ)

9、远控免杀专题(9)-Avet免杀(VT免杀率14/71)：[https://mp.weixin.qq.com/s/EIfqAbMC8HoC6xcZP9SXpA](https://mp.weixin.qq.com/s/EIfqAbMC8HoC6xcZP9SXpA)

10、远控免杀专题(10)-TheFatRat免杀(VT免杀率22/70)：[https://mp.weixin.qq.com/s/zOvwfmEtbkpGWWBn642ICA](https://mp.weixin.qq.com/s/zOvwfmEtbkpGWWBn642ICA)

11、远控免杀专题(11)-Avoidz免杀(VT免杀率23/71)：[https://mp.weixin.qq.com/s/TnfTXihlyv696uCiv3aWfg](https://mp.weixin.qq.com/s/TnfTXihlyv696uCiv3aWfg)

12、远控免杀专题(12)-Green-Hat-Suite免杀(VT免杀率23/70)：[https://mp.weixin.qq.com/s/MVJTXOIqjgL7iEHrnq6OJg](https://mp.weixin.qq.com/s/MVJTXOIqjgL7iEHrnq6OJg)

13、远控免杀专题(13)-zirikatu免杀(VT免杀率39/71)：[https://mp.weixin.qq.com/s/5xLuu5UfF4cQbCq_6JeqyA](https://mp.weixin.qq.com/s/5xLuu5UfF4cQbCq_6JeqyA)

14、远控免杀专题(14)-AVIator免杀(VT免杀率25/69)：

15、远控免杀专题(15)-DKMC免杀(VT免杀率8/55)：

# 免杀能力一览表


序号 | 免杀方法 | VT查杀率 | 360 | QQ | 火绒 | 卡巴 | McAfee | 微软 |  Symantec | 瑞星 | 金山 | 江民 |趋势 
---|--- |--- |--- |--- |--- |--- |--- |--- |--- |--- |--- |--- |---
1 | 未免杀处理|53/69| | | | | | | | |√ |√|
2 | msf自编码|51/69 | |√ | | | | | | |√ |√|
3 | msf自捆绑|39/69| |√ | | | | | | |√ |√|√|
4 | msf捆绑+编码|35/68|√|√ | | | | | | |√ |√|√|
5 | msf多重编码|45/70||√| | |√|| | |√ |√|√|
6 | Evasion模块exe|42/71||√|| |||| |√ |√|√|
7 | Evasion模块hta|14/59|||√| |||√| |√ |√|√|
8 | Evasion模块csc|12/71||√|√|√|√||√|√ |√ |√|√|
9 | Veil原生exe|44/71|√||√||||||√||√|
10| Veil+gcc编译|23/71|√|√|√||√||||√|√|√|
11| Venom-生成exe|19/71||√|√|√|√||||√|√|√|
12| Venom-生成dll|11/71|√|√|√|√|√|√|||√|√|√|
13| Shellter免杀|7/69|√|√|√||√||√||√|√|√|
14| BackDoor-Factory|13/71||√|√||√|√|||√|√|√|
15| BDF+shellcode|14/71||√|√||√||√||√|√|√|
16| Avet免杀|17/71|√|√|√||√|||√|√|√|√|
17| TheFatRat:ps1-exe|22/70||√|√||√|√|√||√|√|√|
18| TheFatRat:加壳exe|12/70|√|√||√|√|√|√||√|√|√|
19| TheFatRat:c#-exe|37/71||√|||√|||√|√|√|√|
20| Avoidz:c#-exe|23/68||√||√|√|||√|√||√|
21| Avoidz:py-exe|11/68||√||√|√||√||√|√|√|
22| Avoidz:go-exe|23/71||√||√|√|√|||√|√|√|
23| Green-Hat-Suite|23/70||√||√|√|√|||√|√|√|
24| Zirikatu免杀|39/71|√|√|√|||||√|√|√|√|
25| AVIator免杀|25/69|√|√|√||√||√|√|√|√|√|
26| DMKC免杀|8/55||√||√||√|√|√|√|√|√|


**几点说明：**

**1、下表中标识 √ 说明相应杀毒软件未检测出病毒，也就是代表了Bypass。**

**2、为了更好的对比效果，大部分测试payload均使用msf的`windows/meterperter/reverse_tcp`模块生成。**

**3、由于本机测试时只是安装了360全家桶和火绒，所以默认情况下360和火绒杀毒情况指的是静态+动态查杀。360杀毒版本`5.0.0.8160`(2020.01.01)，火绒版本`5.0.34.16`(2020.01.01)，360安全卫士`12.0.0.2002`(2020.01.01)。**

**4、其他杀软的检测指标是在`virustotal.com`（简称VT）上在线查杀，所以可能只是代表了静态查杀能力，数据仅供参考，不足以作为免杀的精确判断指标。**

**5、完全不必要苛求一种免杀技术能bypass所有杀软，这样的技术肯定是有的，只是没被公开，一旦公开第二天就能被杀了，其实我们只要能bypass目标主机上的杀软就足够了。**

---

# 目标可期

<div align=center><img src=images/0.png width=40% ></div>

---

# 关于我们

对web安全感兴趣的小伙伴可以关注团队官网: http://www.TideSec.com 或关注公众号：

<div align=center><img src=images/ewm.png width=30% ></div>



