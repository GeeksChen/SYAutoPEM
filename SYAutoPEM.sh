# PEM 自动制作脚本

# 制作原始命令
# 第一步、openssl pkcs12 -clcerts -nokeys -out apns-dis-cert.pem -in apns-dis-cert.p12
# 第二步、openssl pkcs12 -nocerts -out apns-dis-key.pem -in apns-dis-key.p12
# 第三步、openssl rsa -in apns-dis-key.pem -out apns-dis-key-noenc.pem
# 第四步、cat apns-dis-cert.pem apns-dis-key-noenc.pem > apns-dis.pem
# 第五步、openssl s_client -connect gateway.sandbox.push.apple.com:2195 -cert apns-dis-cert.pem -key apns-dis-key-noenc.pem

#!/bin/bash
# 文件后缀
APNS_P12_Suffix="p12"

# apns-cert.p12 文件路径
echo "请输入【apns-cert.p12】文件"
read  APNS_Cert_Path
# 文件类型判断（否是是 p12 文件）
File_Suffix=${APNS_Cert_Path##*.}
# 循环判断
while([ "$File_Suffix" != "$APNS_P12_Suffix" ])
do
echo "文件格式不对，请重新输入【apns-cert.p12】文件"
read  APNS_Cert_Path
File_Suffix=${APNS_Cert_Path##*.}
done


# apns-key.p12 文件路径
echo "请输入【apns-key.p12】文件"
read  APNS_Key_Path;
# 文件类型判断（否是是 p12 文件）
File_Suffix=${APNS_Key_Path##*.}
# 循环判断
while([ "$File_Suffix" != "$APNS_P12_Suffix" ])
do
echo "文件格式不对，请重新输入【apns-key.p12】文件"
read  APNS_Key_Path
File_Suffix=${APNS_Key_Path##*.}
done


# 输出文件路径
## 结果文件保存目录
Base_Shell_Path=$(cd `dirname $0`; pwd)
if [ ! -d ${Base_Shell_Path}/SYAutoPEM ];
then
mkdir -p ${Base_Shell_Path}/SYAutoPEM
fi


# 结果文件路径
Result_File_path=${Base_Shell_Path}/SYAutoPEM
# apns-cert.pem 输出文件路径
APNS_Cert_Out_Path=${Result_File_path}/apns-cert.pem
# apns-key.pem 输出文件路径
APNS_Key_Out_Path=${Result_File_path}/apns-key.pem
# apns.pem 输出文件路径
APNS_Out_Path=${Result_File_path}/apns.pem

echo "\n开始制作 PEM 。。。"


# 是否设置密码
echo "是否设置密码？[Y/n]"
read Is_Set_Password

if [ "y" == ${Is_Set_Password} -o "Y" == ${Is_Set_Password} ];
then
# 开始制作(带密码)
# 第一步：制作 apns-cert.pem（带密码）
openssl pkcs12 -clcerts -out ${APNS_Cert_Out_Path} -in ${APNS_Cert_Path}
# 第二步：制作 apns-key.pem（带密码）
openssl pkcs12 -nocerts -out ${APNS_Key_Out_Path} -in ${APNS_Key_Path}
# 第三步 合并 apns-cert.pem + apns-key.pem ----> apns.pem（带密码）
cat ${APNS_Cert_Out_Path} ${APNS_Key_Out_Path} > ${APNS_Out_Path}
else
# 开始制作(不带密码)
# 第一步：制作 apns-cert.pem(不带密码)
openssl pkcs12 -clcerts -nokeys -out ${APNS_Cert_Out_Path} -in ${APNS_Cert_Path}
# 第二步：制作 apns-key.pem（不带密码）
openssl pkcs12 -nocerts -in ${APNS_Key_Path} | openssl rsa -out ${APNS_Key_Out_Path}
# 第三步 合并 apns-cert.pem + apns-key.pem ----> apns.pem(不带密码)
cat ${APNS_Cert_Out_Path} ${APNS_Key_Out_Path} > ${APNS_Out_Path}
fi


echo '\n清理资源。。。'
#rm ${APNS_Cert_Out_Path}
#rm ${APNS_Key_Out_Path}


echo "\nPEM 制作文件，请查收 。。。\n"

# 打开结果目录
open ${Result_File_path}



