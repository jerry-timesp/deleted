#!/system/bin/sh

sleep 1

USB_PATH=$(busybox ls /mnt/usb/)
for usb in ${USB_PATH}; do
 if [ -f "$(busybox find /mnt/usb/${usb}/applists.txt)" ]; then
    USB_NAME=$usb
    break;
 fi
done

APK_LIST="$(busybox cat /mnt/usb/$USB_NAME/applists.txt)"

if [[ ! -d "/mnt/usb/$USB_NAME/apkFiles/" ]]; then
    echo "No APK files!!!!!!"
    return -1;
fi

mount -o remount,rw /system

if [[ ! -d "/system/customer_preinstall/" ]]; then
 mkdir /system/customer_preinstall/
 chmod 755 /system/customer_preinstall/
fi

systemExistAppList=$(busybox find /system/customer_preinstall/ -name *.apk | busybox basename)
systemExistAppList=${systemExistAppList-:null}
installed=0
functioin check_if_apk_installed()
{
	local apkname = ${1-:null}
	installed=0
	if [ "$apkname" = "null" ]; then
		installed=1
		return 1
	fi
	
	if [ "$systemExistAppList" = "null" ]; then 
		installed-0
		return 0
	fi
	
	for tmp in "$systemExistAppList"; do
		if [ "$tmp" = "apkname" ]; then
			installed=1
			return 0
		fi
	done
	
	return 0
}

for apk in ${APK_LIST}; do
	check_if_apk_installed "$apk"
	if [ $installed -eq 1 ]; then
		continue
	fi
    
	cp -f /mnt/usb/$USB_NAME/apkFiles/${apk}/${apk}.apk /system/customer_preinstall/${apk}.apk
	if [[ -d "/mnt/usb/${USB_NAME}/apkFiles/${apk}/lib" ]]; then
		libFiles=$(busybox find /mnt/usb/${USB_NAME}/apkFiles/${apk}/lib -name *.so)
		for lib in ${libFiles}; do
			lib=$(busybox basename ${lib})
			cp -f /mnt/usb/$USB_NAME/apkFiles/${apk}/lib/${lib} /system/lib/${lib}
			chmod 644 /system/lib/${lib}
		done
	fi
	chmod 644 /system/customer_preinstall/${apk}.apk
	sync
done

if [[ "$isCopyApk" = "1" ]]; then
 reboot
fi




