# DOTA2AHK

本脚本库编写语言为https://github.com/Lexikos/AutoHotkey_L/tree/alphaAutoHotkey 编写的AutoHotkey_H v2 alpha-100版，同时依赖于https://github.com/mmikeww/AHKv2-Gdip 改写的v2版 Gdi+库Gdip_All.ahk，部分脚本会用到https://github.com/HotKeyIt/ahkdll/tree/alpha 编写的v2版多线程库Autohotkey.dll。这些库与v2版的AHK编辑器Scite4AHK均在本页/environments内提供，感谢以上诸位AutoHotkey社区成员的无私奉献。

本脚本库仅供学习交流研究使用，禁止应用于职业比赛，且作者不对在Steam联网对战中使用带来的任何后果负责。

本脚本库包含以下库文件

ThreadManager.ahk，用于增强替代AHK的SetTimer功能，提供更为完善的Thread管理（包含查看Thread状态，开始时间等）

ColorCatcher.ahk，基于AHK的GDI+库编写，用于提供大面积高效率的屏幕捕获功能

DotaClass.ahk，同时依赖DotaFunc.ahk，Mymath.ahk，以及配置文件4ability.ini，6ability.ini，item_dict.ini，包含编写脚本所需的dota2英雄、道具类。包含技能冷却状态，道具种类判断等函数。

本脚本库中的按键部分按照作者个人按键习惯设置，其中大多在DotaClass.ahk中修改，也有部分在脚本顶部修改，AHK触发快捷键本身需要在对应脚本内修改，大家可以活用编辑器内的查找替换功能。

使用传统键位或者特定英雄有不同改键的，请按格式修改脚本中以下部分：new DotaClass(n_ability,dir,,["q","w","e","r","d","f"],["q","w","e","r","d","f"])

本脚本库可适应高度为1920的各种不同比例的dota2分辨率设置，但完全不支持其余高度的屏幕。

短时间内发送相反的滚轮指令可能会被系统block掉，AHK无法解决这一问题，安排时需要谨慎。

通常来说本页内的大多数脚本设定键均为Shift+S，重启键均为Ctrl+LWin。

发现BUG请联系我，当然受限于AHK功能部分问题不做修复保证。

# Changelog
## a0.40
2019-4-15 14:38:51

新增ChaosKnight.ahk，提供混沌骑士的假腿相关操作，支持在释放大招前自动切换至力量假腿并开启臂章（如果存在）。

## a0.30
2019-4-15 13:40:50

新增几个英雄脚本

DrowRanger.ahk，提供卓尔游侠的假腿相关操作。

Clinkz.ahk，提供骨弓的假腿相关操作，并把大招改为智能矢量施法：按下快捷键施法并选择方向，抬起快捷键释放，按下快捷键时，再按S，A或鼠标右键即可取消。如假腿位于按a自动切换状态，请勿在隐身状态使用A地板移动，第二次按下A键会因为切换假腿打断隐身。

DarkSeer.ahk，提供黑暗贤者的大招智能矢量施法，该脚本很简单，其他单独需要智能矢量施法的英雄都可以用此脚本简单修改得到，不再额外提供，

## a0.20

2019-4-14 18:58:54

新增GeneralMapping.ahk脚本，该脚本提供突破Dota2固有限制的改键设置（如按住鼠标中键时屏蔽滚轮以防止误触），更完善的切换自动攻击状态（可分别调整英雄和其余单位），同时提供持续高频率右键点击，一键交换背包和物品栏内道具等功能。使用本脚本的Win键映射为将英雄锁定于屏幕中心功能，需在dota2的autoexec.cfg文件中加入控制台指令：


bind KP_9 dota_camera_center


按Alt强制移动功能需将dota2设置中的Directional Move设为小键盘6

## a0.10

新增UniversalTreads.ahk脚本，提供普适性的切假腿功能，在涉及到的装备不处于cd状态时按下Shift+S，可将当前假腿状态记录为默认主属性，此后可以自动在施法、攻击、移动前自动切换至对应的假腿，亦可用于最大化切臂章和使用魔棒的收益。完美适用于绝大多数4或6技能英雄，对5技能英雄不完美支持，不支持可切换开关的技能（如冰龙a杖一技能），不支持卡尔，水人，以及偷了上述技能的拉比克。但在未来计划推出水人的专门脚本。由于可能打断隐身，强烈建议对隐身英雄进行专门的细微修改后再使用。同时脚本内有按个人习惯的设置将ZXC分别映射为切换到力量，智力，敏捷三种属性的假腿，提供给对智能脚本不太放心的人手动切换。如不需要或有快捷键冲突可自行调整。
