#!/bin/sh

eval `dbus export adm`
# ������Ӷ���
UPDATE_VERSION_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/version"
UPDATE_TAR_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/adm.tar.gz"
	# adm_install_status=	#adm��δ��װ
	# adm_install_status=0	#adm��δ��װ
	# adm_install_status=1	#adm�Ѱ�װ
	# adm_install_status=2	#adm������װ��jffs����...
	# adm_install_status=3	#��������adm��...�����ĵȴ�...
	# adm_install_status=4	#���ڰ�װadm��...
	# adm_install_status=5	#adm��װ�ɹ�����5���ˢ�±�ҳ�棡...
	# adm_install_status=6	#admж����......
	# adm_install_status=7	#admж�سɹ���
	# adm_install_status=8	#û�м�⵽���߰汾�ţ�

	# adm_install_status=9	#��������adm����......
	# adm_install_status=10	#���ڰ�װadm����...
	# adm_install_status=11	#��װ���³ɹ���5���ˢ�±�ҳ��
	# adm_install_status=12	#�����ļ�У�鲻һ�£�
	# adm_install_status=13	#Ȼ����û�и��£�
	# adm_install_status=14	#���ڼ���Ƿ��и���~
	# adm_install_status=15	#�����´���

	# adm_install_status=2	#adm������װ��jffs����...
	dbus set adm_install_status="2"
	adm_version_web1=`curl -s $UPDATE_VERSION_URL | sed -n 1p`
	if [ ! -z $adm_version_web1 ];then
		dbus set adm_version_web=$adm_version_web1
		# adm_install_status=3	#��������adm��...�����ĵȴ�...
		dbus set adm_install_status="3"
		cd /tmp
		md5_web1=$(curl $UPDATE_VERSION_URL | sed -n 2p)
		wget --no-check-certificate --tries=1 --timeout=15 $UPDATE_TAR_URL
		md5sum_gz=$(md5sum /tmp/adm.tar.gz | sed 's/ /\n/g'| sed -n 1p)
		if [ "$md5sum_gz"x != "$md5_web1"x ]; then
			# adm_install_status=12	#�����ļ�У�鲻һ�£�
			dbus set adm_install_status="12"
			rm -rf /tmp/adm*
			sleep 3
			# adm_install_status=0	#adm��δ��װ
			dbus set adm_install_status="0"
			exit
		else
			tar -zxf adm.tar.gz
			dbus set adm_enable="0"
			# adm_install_status=4	#���ڰ�װadm��...
			dbus set adm_install_status="4"
			chmod a+x /tmp/adm/install.sh
			sh /tmp/adm/install.sh
			sleep 2
			# adm_install_status=5	#adm��װ�ɹ�����5���ˢ�±�ҳ�棡...
			dbus set adm_install_status="5"
			dbus set adm_version=$adm_version_web1
			sleep 2
			# adm_install_status=1	#adm�Ѱ�װ
			dbus set adm_install_status="1"
		fi
	else
		dbus set adm_install_status="8"
		sleep 3
		# adm_install_status=0	#adm��δ��װ
		dbus set adm_install_status="0"
		exit
	fi