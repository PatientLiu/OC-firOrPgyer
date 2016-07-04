#!/bin/sh
#for 璞锋
#pod update

project_path=`(dirname $0)`/../
development_macro_setting='${inherited} DEVELOPMENT=1'
develoment_profile="真机描述文件名称"

app_name="YummyClient"
scheme="YummyClient"
workspace="YummyClient.xcworkspace"

macro_setting="$development_macro_setting"
profile="$develoment_profile"

cd "$project_path"
# pwd --> project path
export_path=./build/

if [ -d $export_path ]; then
#clear export dir
rm -rf $export_path
else
mkdir $export_path
fi

#archive and export ipa
archive_path=$export_path/"$app_name".xcarchive
app_path=$export_path/"$app_name".ipa

xcodebuild -verbose -scheme "$scheme" archive -archivePath $archive_path -workspace "$workspace" GCC_PREPROCESSOR_DEFINITIONS="${macro_setting}"
xcodebuild -verbose -exportArchive -exportFormat ipa -archivePath $archive_path -exportPath $app_path -exportProvisioningProfile "$profile"

# push to fir
fir p ${app_path} -T "fir Token"

# push to pgyer
uKey="蒲公英key"
apiKey="蒲公英 apikey"
password="password"
curl --progress-bar -F "file=@${app_path}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload