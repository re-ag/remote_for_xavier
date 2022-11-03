#!/bin/bash

help()
{
	echo -e "\nThis script run ichthus_tensorrt_yolo_cam.launch.py in xavier2 or xavier4 's isaac_yolo docker container"
	echo -e "If you terminate ichthus_tensorrt_yolo_cam.launch.py, Press Ctrl+C!\n"
	echo -e "Usage: $0 [ xavier2 or xavier4 ]\n"

}
if [ $# -ne 1 ] || [ $1 == "--help" ] || [ $1 == "-h" ]
then
	help
	exit 0
fi
CMD_RUN="ros2 launch isaac_ros_argus_camera_mono isaac_ros_argus_camera_mono_launch.py"
CMD_RUN="ros2 launch ichthus_tensorrt_yolo ichthus_tensorrt_yolo_cam.launch.py"
#read CMD_RUN
CMD_FN="source /workspaces/isaac_ros-dev/install/setup.bash; ${CMD_RUN}"


REMOTE=$1
CONTAINER_NAME="isaac_yolo"
CONTAINER_ID=$(ssh ${REMOTE} "docker ps -a -q --filter name=${CONTAINER_NAME} --filter status=running")

############### SIGINT HANDLER #############

function _int() {
	CMD_KILL="ps -A -o pid,pgid,cmd | grep ichthus_tensorrt_yolo_cam.launch.py | head -1  "
	PGID=$(ssh ${REMOTE} "docker exec -i ${CONTAINER_ID} /bin/bash <<< '${CMD_KILL}'" | awk -F' ' '{print $2}')
	echo $PGID
	ssh $REMOTE "docker exec -i ${CONTAINER_ID} /bin/bash <<< 'kill -2 -${PGID}'"

	echo "Kill Node is successful..."
	exit 0	
}

trap _int SIGINT


if [ "$CONTAINER_ID" == "" ]
then
	echo -e "\n\n### The container is EXITED... "
	echo -e "### Start container..."
	CONTAINER_ID=$(ssh ${REMOTE} "docker ps -a -q --filter name=${CONTAINER_NAME} --filter status=exited")
	ssh ${REMOTE} "docker start ${CONTAINER_ID}"
else
	echo "The $CONTAINER_ID is already running..."
fi

echo -e "\n $CMD_RUN \n"
ssh ${REMOTE} "docker exec -i ${CONTAINER_ID} /bin/bash <<< '${CMD_FN}'" 

