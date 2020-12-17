#!/bin/bash
#
# Description: A simple script to show running processes and act upon them as required by user input
# Author: Daniel Howe
# Date: 2016-05-09 
#  2020-12-16: Updated some of the process listing logic
#
while true
do
	clear
	echo "Hello " $USER "!"
	echo "Just a reminder..the hostname of the current machine is: " $HOSTNAME
	echo "
	Please select from the following choices..
	1) Show all running processes
	2) Find a running process by name
	3) Find a running process by user
	4) Find errant/zombie processes
	6) Exit
	Enter Your Choice: "
	read RESPONSE
	case $RESPONSE in
	 1) # Show all running processes
		echo "Now showing all running processes"
		ps -e
	;;
	 2) # Find a running process by name
		echo "I suggest showing process name first, but if you insist...Please enter the process name (substring is ok): "
		read PROCESS_NAME
		echo "Checking for other processes with same name.."
		ps -ef | grep -v grep | grep $PROCESS_NAME
		unset NUMBER_OF_PROCESSES
		unset PROCESS_NAME_KILL_PID
		NUMBER_OF_PROCESSES=$(ps -ef | grep $PROCESS_NAME | wc -l)
		echo "Kill process(es)? (y/N)"
		read PROCESS_NAME_KILL_RESPONSE
		if [ $PROCESS_NAME_KILL_RESPONSE=='y' ]
		then
			if [ NUMBER_OF_PROCESSES>2 ]
			then
				echo "Other processes are running with the same name.  Please enter a specific PID"
				read PROCESS_NAME_KILL_PID
				#echo "Killing PID: " ${PROCESS_NAME_KILL_PID}
				echo $PROCESS_NAME_KILL_PID | xargs kill -9
			else
				#PROCESS_NAME_KILL_PID="$ps -ef | awk '/[n]ano/{print $2}'"
				#echo "Killing PID: " ${PROCESS_NAME_KILL_PID}
				echo $PROCESS_NAME_KILL_PID | xargs kill -9
				ps -ef | grep $PROCESS_NAME | grep -v grep | awk '{print $2}' | xargs kill
			fi
		else
			echo "Going back.."
		fi

	;;
	 3) # Find a running process by user
		echo "Please enter the user name (press 1 for current user): "
		read USER_NAME
		echo "Checking processes with same name.."
		if [ $USER_NAME == '1' ]
		then
			USER_NAME=$USER
		fi
		unset NUMBER_OF_PROCESSES
		unset PROCESS_NAME_KILL_PID
		NUMBER_OF_PROCESSES=$(ps -ef | cut -d ' ' -f 1 | grep $USER_NAME | wc -l)
		echo "There are " $NUMBER_OF_PROCESSES " for this user.."
		ps -ef | cut -d ' ' -f 1 | grep $USER_NAME
		echo "Kill process(es)? (y/N)"
		read PROCESS_NAME_KILL_RESPONSE
		if [ $PROCESS_NAME_KILL_RESPONSE=='y' ]
		then
			if [ NUMBER_OF_PROCESSES>2 ]
			then
				echo "Other processes are running with the same name.  Please enter a specific PID"
				read PROCESS_NAME_KILL_PID
				#echo "Killing PID: " ${PROCESS_NAME_KILL_PID}
				echo $PROCESS_NAME_KILL_PID | xargs kill -9
			else
				echo $PROCESS_NAME_KILL_PID | xargs kill -9
				ps -ef | grep $USER_NAME | grep -v grep | awk '{print $2}' | xargs kill
			fi
		else
			echo "Going back.."
		fi
	;;
	 4) # Find errant processes
		echo "Checking for zombies.."
		unset NUMBER_OF_PROCESSES
		unset PROCESS_NAME_KILL_PID
		NUMBER_OF_PROCESSES=$(ps -a | cut -d ' ' -f 8 | grep Z | wc -l)
		echo "There are currently $NUMBER_OF_PROCESSES zombie processes.."
		echo "Kill process(es)? (y/N)"
		read PROCESS_NAME_KILL_RESPONSE
		if [ $PROCESS_NAME_KILL_RESPONSE=='y' ]
		then
			if [ NUMBER_OF_PROCESSES>2 ]
			then
				echo "Other processes are running with the same name.  Please enter a specific PID"
				ps -a
				read PROCESS_NAME_KILL_PID
				#echo "Killing PID: " ${PROCESS_NAME_KILL_PID}
				echo $PROCESS_NAME_KILL_PID | xargs kill -9
			else
				echo $PROCESS_NAME_KILL_PID | xargs kill -9
				ps -aux | cut -d ' ' -f 8 | grep Z | grep -v grep | awk '{print $2}' | xargs kill
			fi
		else
			echo "Going back.."
		fi
	;;
	 6) exit 0
	;;
	 *) echo "Please enter a number between 1 and 6"
	;;
	esac
	echo -n "Hit the Enter key to return to menu "
	read RESPONSE
done
