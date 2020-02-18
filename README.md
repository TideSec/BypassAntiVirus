# BypassAntiVirus

**本文为Tide安全团队成员`重剑无锋`原创文章，转载请声明出处！**

**郑重声明：文中所涉及的技术、思路和工具仅供以安全为目的的学习交流使用，任何人不得将其用于非法用途以及盈利等目的，否则后果自行承担！**

一直从事web安全多一些，对waf绕过还稍微有些研究，但是对远控免杀的认知还大约停留在ASPack、UPX加壳、特征码定位及修改免杀的年代。近两年随着hw和红蓝对抗的增多，接触到的提权、内网渗透、域渗透也越来越多。攻击能力有没有提升不知道，但防护水平明显感觉提升了一大截，先不说防护人员的技术水平如果，最起码各种云WAF、防火墙、隔离设备部署的多了，服务器上也经常能见到安装了杀软、软waf、agent等等，特别是某数字杀软在国内服务器上尤为普及。这个时候，不会点免杀技术就非常吃亏了。

但web狗一般对逆向和二进制都不大熟，编译运行别人的代码都比较费劲，这时候就只能靠现成的工具来曲线救国了。为此，我从互联网上搜集了大约20款知名度比较高的免杀工具研究免杀原理及免杀效果测试，后面还学习了一下各种语言编译加载shellcode的各种姿势，又补充了一些白名单加载payload的常见利用，于是就有了这一个远控免杀的系列文章。

- **工具篇内容**：msf自免杀、Veil、Venom、Shellter、BackDoor-Factory、Avet、TheFatRat、Avoidz、Green-Hat-Suite、zirikatu、AVIator、DKMC、Unicorn、Python-Rootkit、DKMC、Unicorn、Python-Rootkit、ASWCrypter、nps_payload、GreatSCT、HERCULES、SpookFlare、SharpShooter、CACTUSTORCH、Winpayload等。

- **代码篇内容**：C/C++、C#、python、powershell、ruby、go等。

- **白名单内容**：MsBuild、Msiexec、mshta、InstallUtil、rundll32、Regsvr32、Cmstp、Wmic、CSC、Regasm、Regsvcs、Control、Msxsl、Odbcconf、Compiler等。

**已完成的免杀文章及相关软件下载：[`https://github.com/TideSec/BypassAntiVirus`](https://github.com/TideSec/BypassAntiVirus)**


# 文章导航

1.远控免杀专题(1)-基础篇：[https://mp.weixin.qq.com/s/3LZ_cj2gDC1bQATxqBfweg](https://mp.weixin.qq.com/s/3LZ_cj2gDC1bQATxqBfweg)

2.远控免杀专题(2)-msfvenom隐藏的参数：[https://mp.weixin.qq.com/s/1r0iakLpnLrjCrOp2gT10w](https://mp.weixin.qq.com/s/1r0iakLpnLrjCrOp2gT10w)

3.远控免杀专题(3)-msf自带免杀(VT免杀率35/69)：[https://mp.weixin.qq.com/s/A0CZslLhCLOK_HgkHGcpEA](https://mp.weixin.qq.com/s/A0CZslLhCLOK_HgkHGcpEA)

4.远控免杀专题(4)-Evasion模块(VT免杀率12/71)：[https://mp.weixin.qq.com/s/YnnCM7W20xScv52k_ubxYQ](https://mp.weixin.qq.com/s/YnnCM7W20xScv52k_ubxYQ)

5.远控免杀专题(5)-Veil免杀(VT免杀率23/71):[https://mp.weixin.qq.com/s/-PHVIAQVyU8QIpHwcpN4yw](https://mp.weixin.qq.com/s/-PHVIAQVyU8QIpHwcpN4yw)

6.远控免杀专题(6)-Venom免杀(VT免杀率11/71):[https://mp.weixin.qq.com/s/CbfxupSWEPB86tBZsmxNCQ](https://mp.weixin.qq.com/s/CbfxupSWEPB86tBZsmxNCQ)

7.远控免杀专题(7)-Shellter免杀(VT免杀率7/69)：[https://mp.weixin.qq.com/s/ASnldn6nk68D4bwkfYm3Gg](https://mp.weixin.qq.com/s/ASnldn6nk68D4bwkfYm3Gg)

8.远控免杀专题(8)-BackDoor-Factory免杀(VT免杀率13/71)：[https://mp.weixin.qq.com/s/A30JHhXhwe45xV7hv8jvVQ](https://mp.weixin.qq.com/s/A30JHhXhwe45xV7hv8jvVQ)

9.远控免杀专题(9)-Avet免杀(VT免杀率14/71)：[https://mp.weixin.qq.com/s/EIfqAbMC8HoC6xcZP9SXpA](https://mp.weixin.qq.com/s/EIfqAbMC8HoC6xcZP9SXpA)

10.远控免杀专题(10)-TheFatRat免杀(VT免杀率22/70)：[https://mp.weixin.qq.com/s/zOvwfmEtbkpGWWBn642ICA](https://mp.weixin.qq.com/s/zOvwfmEtbkpGWWBn642ICA)

11.远控免杀专题(11)-Avoidz免杀(VT免杀率23/71)：[https://mp.weixin.qq.com/s/TnfTXihlyv696uCiv3aWfg](https://mp.weixin.qq.com/s/TnfTXihlyv696uCiv3aWfg)

12.远控免杀专题(12)-Green-Hat-Suite免杀(VT免杀率23/70)：[https://mp.weixin.qq.com/s/MVJTXOIqjgL7iEHrnq6OJg](https://mp.weixin.qq.com/s/MVJTXOIqjgL7iEHrnq6OJg)

13.远控免杀专题(13)-zirikatu免杀(VT免杀率39/71)：[https://mp.weixin.qq.com/s/5xLuu5UfF4cQbCq_6JeqyA](https://mp.weixin.qq.com/s/5xLuu5UfF4cQbCq_6JeqyA)

14.远控免杀专题(14)-AVIator免杀(VT免杀率25/69)：[https://mp.weixin.qq.com/s/JYMq_qHvnslVlqijHNny8Q](https://mp.weixin.qq.com/s/JYMq_qHvnslVlqijHNny8Q)

15.远控免杀专题(15)-DKMC免杀(VT免杀率8/55)：[https://mp.weixin.qq.com/s/UZqOBQKEMcXtF5ZU7E55Fg](https://mp.weixin.qq.com/s/UZqOBQKEMcXtF5ZU7E55Fg)

16.远控免杀专题(16)-Unicorn免杀(VT免杀率29/56)：[https://mp.weixin.qq.com/s/y7P6bvHRFes854EAHAPOzw](https://mp.weixin.qq.com/s/y7P6bvHRFes854EAHAPOzw)

17.远控免杀专题(17)-Python-Rootkit免杀(VT免杀率7/69)：[https://mp.weixin.qq.com/s/OzO8hv0pTX54ex98k96tjQ](https://mp.weixin.qq.com/s/OzO8hv0pTX54ex98k96tjQ)

18.远控免杀专题(18)-ASWCrypter免杀(VT免杀率19/57)：[https://mp.weixin.qq.com/s/tT1i55swRWIYiEdxEWElSQ](https://mp.weixin.qq.com/s/tT1i55swRWIYiEdxEWElSQ)

19.远控免杀专题(19)-nps_payload免杀(VT免杀率3/57)：[https://mp.weixin.qq.com/s/XmSRgRUftMV3nmD1Gk0mvA](https://mp.weixin.qq.com/s/XmSRgRUftMV3nmD1Gk0mvA)

20.远控免杀专题(20)-GreatSCT免杀(VT免杀率14/56)：[https://mp.weixin.qq.com/s/s9DFRIgpvpE-_MneO0B_FQ](https://mp.weixin.qq.com/s/s9DFRIgpvpE-_MneO0B_FQ)

21.远控免杀专题(21)-HERCULES免杀(VT免杀率29/70)：[https://mp.weixin.qq.com/s/Rkr9lixzL4tiL89r10ndig](https://mp.weixin.qq.com/s/Rkr9lixzL4tiL89r10ndig)

22.远控免杀专题(22)-SpookFlare免杀(VT免杀率16/67)：[https://mp.weixin.qq.com/s/LfuQ2XuD7YHUWJqMRUmNVA](https://mp.weixin.qq.com/s/LfuQ2XuD7YHUWJqMRUmNVA)

23.远控免杀专题(23)-SharpShooter免杀(VT免杀率22/57)：[https://mp.weixin.qq.com/s/EyvGfWXLbxkHe7liaNFhGg](https://mp.weixin.qq.com/s/EyvGfWXLbxkHe7liaNFhGg)

24.远控免杀专题(24)-CACTUSTORCH免杀(VT免杀率23/57)：[https://mp.weixin.qq.com/s/g0CYvFMsrV7bHIfTnSUJBw](https://mp.weixin.qq.com/s/g0CYvFMsrV7bHIfTnSUJBw)

25.远控免杀专题(25)-Winpayloads免杀(VT免杀率18/70)：本文

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
27| Unicorn免杀|29/56|||√||||√||√|√|√|
28| Python-Rootkit免杀|7/69|√|√|√||√||√|√|√|√|√|
29| ASWCrypter免杀|19/57|√||||√||||√|√|√|
30| nps_payload免杀|3/56|√|√|√||√|√|√|√|√|√|√|
31| GreatSct免杀|14/56|√|√|√|||√|√|√|√|√|√|
32| HERCULES免杀|29/71|||√||||||√||√|
33| SpookFlare免杀|16/67||√|√|√|√|√|√|√|√||√|
34| SharpShooter免杀|22/57|√|√||||√|||√|√|√|
35| CACTUSTORCH免杀|23/57|√|√|√||√||||√|√|√|
36| Winpayloads免杀|18/70|√|√|√|√|√||√|√|√|√|√|
37|C/C++1:指针执行|23/71|√|√|||√||√||√||√|
38|C/C++2:动态内存|24/71|√|√|||√||√||√||√|
39|C/C++3:嵌入汇编|12/71|√|√|√||√|√|√||√|√|√|
40|C/C++4:强制转换|9/70|√|√|√||√|√|√|√|√|√|√|
41|C/C++5:汇编花指令|12/69|√|√|√||√|√|√||√|√|√|
42|C/C++6:XOR加密|15/71|√|√|√||√||√|√|√|√|√|
43|C/C++7:base64加密1|28/69|√|√|√||√||√||√|√|√|
44|C/C++8:base64加密2|28/69|√|√|√||√||√||√||√|
45|C/C++9:python+汇编|8/70|√|√|√|√|√|√|√|√|√|√|√|
46|C/C++10:python+xor|15/69|√|√|√|√|√||√|√|√|√|√|
47|C/C++11:sc_launcher|3/71|√|√|√|√|√|√|√|√|√|√|√|
48|C/C++12:使用SSI加载|6/69|√|√|√|√|√|√|√||√|√|√|
49|C# 法1:编译执行|20/71|√|√|√||√||√|√|√|√|√|
50|C# 法2:自实现加密|8/70|√|√|√|√|√|√|√|√|√|√|√|
51|C# 法3:XOR/AES加密|14/71|√|√|√||√||√|√|√|√|√|
52|C# 法4:CSC编译|33/71|√|√|√|||||√|√|√|√|
53|py 法1:嵌入C代码|19/70|√|√|√|||√||√|√|√|√|
54|py 法2:py2exe编译|10/69|√|√|√||√||√|√|√|√|√|
55|py 法3:base64加密|16/70|√|√|√|√||||√|√|√|√|
56|py 法4:py+C编译|18/69||√|√|||||√|√|√|√|
57|py 法5:xor编码|19/71|√|√|√|||||√|√|√|√|
58|py 法6:aes加密|19/71|√|√|√|||||√|√|√|√|
59|py 法7:HEX加载|3/56|√|√|√|√|√||√|√|√|√|√|
60|py 法8:base64加载|4/58|√|√|√|√|√||√|√|√|√|√|
61|ps 法1:msf原生|18/56|√|√|√|||||√|√|√|√|
62|ps 法2:SC加载|0/58|√|√|√|√|√|√|√|√|√|√|√|
63|ps 法3:PS1编码|3/58|√|√|√||√|√|√|√|√|√|√|
64|ps 法4:行为免杀|0/58|√|√|√|√|√|√|√|√|√|√|√|
65|go 法1:嵌入C代码|3/71|√|√|√|√|√||√|√|√||√|
66|go 法2:sc加载|4/69|√|√|√|√|√|√|√|√|√||√|
67|go 法3:gsl加载|6/71|√|√|√|√|√|√|√|√|√|√|√|
68|ruby加载|0/58|√|√|√|√|√|√|√|√|√|√|√|
69|MSBuild 代码1|4/57|√|√|√||√|√||√|√|√|√|
70|MSBuild 代码2|18/58|√|√|√||||√||√|√|√|
71|Msiexec 法1|22/60|√|√|√||||√||√|√|√|
72|Msiexec 法2|29/58|√|√|√||||√||√|√||
73|InstallUtil 法1|33/71|√|√|√|||||√|√|√|√|
74|InstallUtil 法2|3/68|√|√|√|√|√|√|√|√|√|√|√|
75|Mshta 法1|28/58||||||√|||√|√|√|
76|Mshta 法2|28/58||||||√|||√|√|√|
77|Mshta 法3|26/58|√|√|√||||||√|√|√|

**几点说明：**

**1、下表中标识 √ 说明相应杀毒软件未检测出病毒，也就是代表了Bypass。**

**2、为了更好的对比效果，大部分测试payload均使用msf的`windows/meterperter/reverse_tcp`模块生成。**

**3、由于本机测试时只是安装了360全家桶和火绒，所以默认情况下360和火绒杀毒情况指的是静态+动态查杀。360杀毒版本`5.0.0.8160`(2020.01.01)，火绒版本`5.0.34.16`(2020.01.01)，360安全卫士`12.0.0.2002`(2020.01.01)。**

**4、其他杀软的检测指标是在`virustotal.com`（简称VT）上在线查杀，所以可能只是代表了静态查杀能力，数据仅供参考，不足以作为免杀或杀软查杀能力的判断指标。**

**5、完全不必要苛求一种免杀技术能bypass所有杀软，这样的技术肯定是有的，只是没被公开，一旦公开第二天就能被杀了，其实我们只要能bypass目标主机上的杀软就足够了。**

---

# 目标可期

<div align=center><img src=images/0.png width=40% ></div>

---

# 关于我们

对web安全感兴趣的小伙伴可以关注团队官网: http://www.TideSec.com 或关注公众号：

<div align=center><img src=images/ewm.png width=30% ></div>



