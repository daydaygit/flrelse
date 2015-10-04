#!/bin/bash

#copy_imgs_name=u-boot.bin

function current_script_path()
{
  filepath=$(cd "$(dirname "$0")"; pwd)
  echo -e "\nCurrent script path: $filepath"
}

# Note:
# If you want to use checkpfrest value, you should call checkout_path_file_exist at first()"
function checkout_path_file_exist()
{
  echo -e "\$@ = \"$@\""
  specific_contents=$3
  checkpfrest=1

  case $1 in
  d)
     if [ ! -d $2 ]; then
       echo "The $specific_contents path: \"$2\" is not exist."
       checkpfrest=1
     else
       echo -e "The $specific_contents path is \"$2\"\n"
       checkpfrest=0
     fi
     ;;
  f)
     if [ ! -f $2 ]; then
       echo "The $specific_contents file: \"$2\" is not exist."
       checkpfrest=1
     else
       echo -e "The $specific_contents file is \"$2\"\n"
       checkpfrest=0
     fi
     ;;
  *)
     echo "the 1st parameter is error."
     checkpfrest=1
     ;;
  esac
}

function create_share_win_lin_path()
{
  parameter_file=$SCRIPTDIR/.paramfile
  if [ ! -f $parameter_file ]; then
      echo ""
      read -p "Please supply the root SHARE path for sharing image:  "  SHARE_ROOT_PATH
#     rest=`checkout_path_file_exist d $SHARE_ROOT_PATH "root share file"`
#     rest=$(checkout_path_file_exist  d  $SHARE_ROOT_PATH  "root share file")
#     if [ $rest -ne 0 ]; then
#     if [ "$rest" = "0" ]; then
      checkout_path_file_exist  d  $SHARE_ROOT_PATH  "root share file"  # 和$()还是有区别的，$()赋值后还需要echo调用才去调用函数
      if [ $checkpfrest -ne 0 ]; then
        exit
      else
        echo "SHARE_ROOT_PATH=$SHARE_ROOT_PATH"  >  $parameter_file
      fi

      read -p "Please supply the share file path based $SHARE_ROOT_PATH :  "  SHARE_IMGS_FILE
      SHARE_IMGS_FULL_PATH=$SHARE_ROOT_PATH/$SHARE_IMGS_FILE
      checkout_path_file_exist  d  $SHARE_IMGS_FULL_PATH  "share file"
      if [ $checkpfrest -ne 0 ]; then
        mkdir -p $SHARE_IMGS_FULL_PATH
        echo "The share file path \"$SHARE_IMGS_FULL_PATH\" now is created."
      else
        rm $SHARE_IMGS_FULL_PATH/u-boot.bin
      fi
      echo "SHARE_IMGS_FILE=$SHARE_IMGS_FILE"  >> $parameter_file
  else
      SHARE_ROOT_PATH=`grep "SHARE_ROOT_PATH="  $parameter_file | awk -F '=' '{print $2}'`
      checkout_path_file_exist  d  $SHARE_ROOT_PATH "root share file"
      if [ $checkpfrest -ne 0 ]; then
        exit
      fi

      SHARE_IMGS_FILE=`grep "SHARE_IMGS_FILE="  $parameter_file  | awk -F '=' '{print $2}'`
      SHARE_IMGS_FULL_PATH=$SHARE_ROOT_PATH/$SHARE_IMGS_FILE
      checkout_path_file_exist  d  $SHARE_IMGS_FULL_PATH  "image file"
      if [ $checkpfrest -ne 0 ]; then
        mkdir -p $SHARE_IMGS_FULL_PATH
        echo "The share file path \"$SHARE_IMGS_FULL_PATH\" now is created."
      else
        rm $SHARE_IMGS_FULL_PATH/u-boot.bin
      fi
  fi
}

function copy_u-boot_img_to_share_file()
{
  echo "list u-boot images:"
  ls -laF u-boot*

  echo "Copy u-boot.bin to $SHARE_IMGS_FULL_PATH"
  cp  u-boot.bin  $SHARE_IMGS_FULL_PATH
  ls -laF $SHARE_IMGS_FULL_PATH

  echo -e "\nNow, you can transfer u-boot.bin from Virtual-Win8 to Note-PC by QQ."
}

function u-boot_operate()
{
  cd ../uboot1.1.6
  current_script_path

  create_share_win_lin_path
  copy_u-boot_img_to_share_file
}

function kernel_operate()
{
  cd ../linux-3.0.1
  current_script_path

}


function part_operate_branch()
{
  case "$BUILD_PART" in
   "u"|"U")
        echo "you have selected [ u-boot ]"
        u-boot_operate
        ;;
   "k"|"K")
        echo "you h4ave selected [ kernel ]"
        kernel_operate
        ;;
   *)
        echo "Sorry, no part you selected is exist."
        exit
        ;;
  esac

}

function list_build_part()
{
  echo "        * u <-> u-boot"
  echo "        * k <-> kernel"
}

SCRIPT_NAME=$0
SCRIPTDIR=$(cd "$(dirname "$0")"; pwd)
echo -e "SCRIPT: \n\t$SCRIPTDIR/$SCRIPT_NAME"

echo -e "\nWhich part you want to operate ?"
list_build_part
read -p "Please select the character. such as 'u' or 'k':  "  BUILD_PART
part_operate_branch

echo
