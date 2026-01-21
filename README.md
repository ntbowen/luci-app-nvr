

用软路由给IPC摄像头做录像机，视频同步保存到webdav网盘.

一、实现方法：

	1、在istoreOS中安装软件包 luci-app-nvr.ipk . 下载链接。
	https://dl.openwrt.ai/23.05/packages/x86_64/kiddin9/luci-app-nvr_20230818-1_all.ipk
		luci-app-nvr基于sh脚本，循环调用FFmpeg录制视频实现该功能。

		由于luci-app-nvr自身有一些BUG，需要手动修复，参看三.1、


	2、istoreOS 默认的FFmpeg不支持h264解码，无法采集IPC摄像头。
	
	 安装支持h264解码的独立版本即可(免去编译的麻烦)，下载链接。
	https://dl.openwrt.ai/23.05/packages/x86_64/kiddin9/ffmpeg-static_0.0.1-1_x86_64.ipk
	
	
二、这里以虚拟机中的istoreos为例。

	1、luci-app-nvr 基本设置
		引用磁盘或分区给istoreos做第二块磁盘(无需直通)。单网卡即可
		
		istoreos 会自动挂载 第二块硬盘 路径为/mnt/sdb1/
		
		安装好luci-app-nvr 进行基本配置
		
		开启录像守护进程 打勾。
		
		摄像机源，选择多种视频源。格式参照 四、
		
		数据存储目录：/mnt/sdb1/camera
		
		存储数据的磁盘名：sdb1
		
		每个文件的时长 300

		开启循环写入磁盘和仅检测整个磁盘空间 打勾
		
		其他保持默认或根据自身情况设置。
		
		保存并应用
		
		然后到动作 【一键录制视频】 （或者重启istoreos）
		
		然后到 /mnt/sdb1/camera 目录查看是否有视频文件生成。
		
	2、设置远程查看录制的视频
	
		istoreos安装网络共享 启用Samba ，挂载/mnt/sdb1 可在局域网中查看视频目录。
		istoreos配置易有云，移动端安装易有云APP ，即可Web管理目录和远程查看视频目录。
		istoreos挂载网盘webdav目录,并同步/mnt/sdb1/camera 到网盘目录。实现云端备份

	
三、luci-app-nvr BUG手动修复

	ssh 连接到 istoreOS .
		
	替换文件 /usr/nvr/nvrrecord 	为项目中的 nvrrecord 文件。

	原始代码在循环录制的过程中，强制停止了ffmpeg，视频文件不完整的情况mp4格式无法正常播放(mkv不受影响，但移动端支持不好，不推荐使用)。
	原始代码使用通道完整URL做目录名，导致路径过长，一些情况下无法播放。也不方便查阅。
	原始代码有声使用.mkv格式，不适合移动端播放，改为mp4.
	原始代码提前6秒，抢进下一次循环录制并强制停止了ffmpeg，导致视频不完整。

	
四、常见Rtsp地址格式大全

	1. 海康、中威摄像机	rtsp://用户名:密码@192.168.1.64:554/Streaming/Channels/1
	2. Hikvision:		rtsp://用户名:密码@10.141.44.110:554/h264/ch1/main/av_stream
	3. 中威：			rtsp://用户名:密码@10.141.231.183:554/Stream/Live/102
	4. 大华、乐橙			rtsp://用户名:密码@192.168.1.64:554/cam/realmonitor?channel=1&subtype=0
	5. 米家				rtsp://ipaddress:554/ch0_0.h264
	6. 华为:				rtsp://用户名:密码@172.33.102.15/LiveMedia/ch1/Media1


	
	
	
