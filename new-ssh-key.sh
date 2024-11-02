curr_dir=`pwd`
cd
ssh-keygen -N '' -f $1
mv $1 $curr_dir
mv $1.pub $curr_dir
cd $curr_dir
