#!/bin/bash

SHARE_WIN_LIN_FILE=/media/EXT4_300/CODE/smdk6410/temp_share_for_other_proj/smdk6410_toFixfsMount/u-boot

function current_script_path()
{
  filepath=$(cd "$(dirname "$0")"; pwd)
  echo -e "\nCurrent script path: $filepath"
}

function copy_u-boot_img_to_share_file()
{
  echo "list u-boot images:"
  ls -laF u-boot*  

  if [ ! -f $SHARE_WIN_LIN_FILE ]; then
    mkdir -p $SHARE_WIN_LIN_FILE
  fi

  echo "Copy u-boot.bin to $SHARE_WIN_LIN_FILE"
  cp  u-boot.bin  $SHARE_WIN_LIN_FILE
  ls -laF $SHARE_WIN_LIN_FILE

  echo -e "\nNow, you can transfer u-boot.bin from Virtual-Win8 to Note-PC by QQ."
}

function u-boot_operate()
{
  cd ../uboot1.1.6
  current_script_path

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
   'u'|'U')
        echo "you have selected [ u-boot ]"
        u-boot_operate
        ;;
   'k'|'K')
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

echo -e "\nWhich part you want to operate ?"
list_build_part
read -p "Please select the character. such as 'u' or 'k':  "  BUILD_PART
part_operate_branch

echo
