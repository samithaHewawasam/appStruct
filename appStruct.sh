#!bin/bash

echo "Hello,$USER Welcome to the appStruct";
echo "reading the operating system...";
echo `uname -s`;

function getSuccess() { #execute every single command if the previous command is successful
	OUT=$?;
	if  [ $OUT -eq 0 ];then	
		`$1`;	
		if [ $OUT -eq 0 ];then	
			echo $2;	
		else	
			echo "error occurred";	
		fi	
	else	
			echo "error occurred";	
		exit	
	fi
}

function setStructure() {
	pushd "$1" #changed the root directory. cd command not using here
		declare -a structure=( "${@:2}" ) #get all arguments as an array and pharse to the structure		
			for i in "${structure[@]}" 
			do
		   		:
				getSuccess "mkdir -p $i" "$i directory created"; #use -p flag to create the file if not exist;
			done
	popd	

}

function setFiles() {
	pushd "$1" #changed the root directory. cd command not using here
		declare -a files=( "${@:2}" ) #get all arguments as an array and pharse to the files
			for i in "${files[@]}" 
			do
		   		:
				getSuccess "touch $i" "$i file created"; #use -p flag to create the file if not exist;
			done	
	popd
}


echo "enabling file permissions to 755";
	getSuccess "sudo chmod -R 0755 $(pwd)" "File permissions set to 755";
echo "app name:";
	read APPNAME;
	getSuccess "mkdir -p $(pwd)/$APPNAME" "root directory created";
	
echo "buiding angular folder structure...";
	setStructure "$APPNAME" "script" "style" "php" "views";
	setFiles "$APPNAME" "index.php";
echo "root structure created";

cat << EOF > $APPNAME/index.php
<!DOCTYPE html>
<html lang="en" ng-app="$APPNAME">
    <head>
        <meta charset="utf-8">
        <title>$APPNAME Application</title>
    </head>
    <body ng-view>
    </body>
</html>
EOF

echo "child structure creating..";
	setStructure "$APPNAME/script" "controllers" "directives" "factory" "filters" "services" "vendor";
	setFiles "$APPNAME/script" "app.js";


