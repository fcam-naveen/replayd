# Simple ReplayD Application
This guide will go through how to deploy a simple ReplayD server. ReplayD server will return what you send it. 
This supports POST, PUT and GET request.
Its implemented with Python3 Flask-Restful server on Docker Container created on the same linux system you are running build script(run_all.sh explained bellow).

## Prerequists
1. Please install docker engine. This example is using Centos7. Any other linux flavor should work.
Docker can be installed using. https://docs.docker.com/engine/install/centos/
2. Please install ansible. 
You can install using ```pip3 install ansible```.
3. You need atleast 400MB of disk space.

## Build Deploy and Test
### Clone the repository
```git clone git@github.com:fcam-naveen/replayd.git ```  
```cd replayd```

### Build Run and Test
```run_all.sh``` will perform following operations. Please run this on the machine where application hosting docker container will be created. 
1. Build c7-systemd-sshd docker image with sshd,python3 flask-restful packages. 
2. Docker container will be created with name ```replayd_server```.
3. Then ansible playbook will run to configure replayd daemon on this docker container.
4. POST followed by GET will run against replayd server for verification.
5. PUT followed by GET will run against replayd server for verification.\
You can run using\
```./run_all.sh all``` <br />   
Example output is at ```run_all_example_output.txt```

## Test POST and PUT with your json using curl_replayd.sh
```test``` dir has a script to test with your own json.  
```./curl_replayd.sh``` will show  
```
Usage: 
    ./curl_replayd SERVER_IP <POST|PUT|GET> PAYLOAD
    PAYLOAD is not applicable for GET
```

1. Testing with POST and GET.  
Please create a json file for POST. Example can be seen with post.json.  
```./curl_replayd.sh <your_host_ip> POST <post_json_file>```  
Now you can perform GET to see what you have sent.  
```./curl_replayd.sh <your_host_ip> GET``` <br />  

2. You can test PUT similar to #1 with PUT option.

## run_all.sh
You can see the help using  
./run_all.sh  
```run_all.sh <all | build | run | test> ```.  
```all``` will do all steps. build,run,test.  
```build``` will rebuild docker image.  
```run``` will recreate a docker container and configures replayd server on port 6080.  
```test``` will perform POST and then GET to make sure what we get is what we set.  

### Debugging
1. If run_all.sh fails with
TASK [Ensure group "replayd" exists]
****************************************************************************************************************************************
fatal: [172.17.0.4]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
@\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\nIT IS POSSIBLE ...

Solution is to remove IP shown after fatal from ~/.ssh/known_hosts
