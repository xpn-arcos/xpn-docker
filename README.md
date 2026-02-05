# Expand Docker

![Workflow](https://github.com/xpn-arcos/xpn-docker/actions/workflows/xpn_docker_workflow.yml/badge.svg)
![License](https://img.shields.io/github/license/xpn-arcos/xpn-docker)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/116b10e7f3be40cbb99248b30266a19a)](https://app.codacy.com/gh/xpn-arcos/xpn-docker/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)


## Contents

 1. [Prerequisites](#1-prerequisites)
 2. [Summary of using xpn-docker](/docs/summary.md)
 3. [Build the container image](/docs/image.md)
 4. Some xpn-docker use cases:
    1. [Examples using XPN Ad-Hoc](/docs/usecase-xpn.md)
    2. [Examples of benchmarks with XPN Ad-Hoc](/docs/usecase-benchmarks.md)
    3. [Example  of Apache Spark and Ad-Hoc XPN](/docs/usecase-spark.md)
 5. [Multiple containers on multiple nodes](/docs/swarm.md)
 6. [Authors](/docs/authors.md)


## 1. Prerequisites

* Windows:
  * WSL: https://docs.docker.com/desktop/setup/install/windows-install/#wsl-verification-and-setup
  * docker desktop: https://docs.docker.com/desktop/setup/install/windows-install/
* MacOS (docker desktop): https://docs.docker.com/desktop/setup/install/mac-install/
* Linux (docker): https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
  ```bash
  : Add Docker's official GPG key:
  sudo apt update
  sudo apt install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  : Add the repository to Apt sources:
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
  Types: deb
  URIs: https://download.docker.com/linux/ubuntu
  Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
  Components: stable
  Signed-By: /etc/apt/keyrings/docker.asc
  EOF

  : Update repo and install docker
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  ```


## 2. Summary xpn-docker options

  <html>
  <table>
  <tr>
  <th colspan="2">Action</th>
  <th>Command</th>
  </tr>

  <tr>
  <td rowspan="3">
  Container image
  </td>
  <td colspan="1"> build image <br> IF((First time OR dockerfile updated)) </td>
  <td><code>./xpn_docker.sh build</code>
  </td>
  </tr>
  <tr>
  <td colspan="1"> Save image  </td>
  <td><code> ./xpn_docker.sh image-save</code>
  </td>
  </tr>
  <tr>
  <td colspan="1"> Load image  </td>
  <td><code> ./xpn_docker.sh image-load</code>
  </td>
  </tr>

  <tr>
  <td rowspan="2">
  Multiple nodes
  </td>
  <td>  
  Starting docker swarm
  </td>
  <td>
  <code>./xpn-docker.sh swarm-create machinefile</code>
  </td>
  </tr>
  <tr>
  <td>  
  Stopping docker swarm
  </td>
  <td>
  <code>./xpn-docker.sh swarm-destroy</code>
  </td>
  </tr>

  <tr>
  <td rowspan="4">
  Work session
  </td>
  <td colspan="1"> To spin up <b>3</b> containers </td>
  <td><code>./xpn_docker.sh start <b>3</b></code>
  </td>
  </tr>
  <tr>
  <td colspan="1"> To get into container <b>1</b>  </td>
  <td><code> ./xpn_docker.sh bash <b>1</b></code>
  </td>
  </tr>
  <tr>
  <td colspan="1"> To exit from container </td>
  <td><code>exit</code>  </td>
  </tr>
  <tr>
  <td colspan="1"> To spin down all containers </td>
  <td><code>./xpn_docker.sh stop</code>
  </td>
  </tr>

  <tr>
  <td rowspan="2">
  Get information
  </td>
  <td>  
  To check running containers
  </td>
  <td>
  <code>./xpn_docker.sh status</code>
  </td>
  </tr>
  <tr>
  <td>  
  To get the containers internal IP addresses
  </td>
  <td>
  <code>./xpn_docker.sh network</code>
  </td>
  </tr>

  </table>
  </html>

* **Please beware of**:
   * Any modification outside the "/work" directory will be discarded on container stopping.
   * Please make a backup of your work "frequently" (just in case).
   * You might need to use "sudo" before ./xpn_docker.sh if your user doesn't belong to the docker group
     * It could be solved by using "sudo usermod -aG docker ${USER}"



## 3. Build the container image

The first time xpn-docker is deployed or when the ```docker/dockerfile``` is updated we need to build the container image.

  * To build the container image for a single node:
       ```bash
       ./xpn-docker.sh clean-build
       ```

  * To build and distribute the container image to multiple nodes:
    1. Build and save the image to the ```xpn_docker.tgz``` file by using:
        ```bash
       ./xpn-docker.sh clean-build
        ./xpn-docker.sh image-save
        ```
    2. Copy ```xpn_docker.tgz``` to other nodes, and load this file:
        ```bash
        scp xpn_docker.tgz  node-x
        ssh node-x ./xpn-docker.sh image-load
        ```



## 4. Some xpn-docker use cases

### 4.1 Example of using Expand with native API, with LD_PRELOAD (bypass), and with FUSE

   <br>
   <html>
   <table>
   <tr>
   <td>
   Expand (FUSE)
   </td>
   <td>
   Expand (LD_PRELOAD)
   </td>
   <td>
   Expand (native)
   </td>
   </tr>
   <tr>
   <td>
   </html>
     
   ```bash
 : Step 1. 
 ./xpn_docker.sh start 3
 ./xpn_docker.sh status

 : Step 2. 
 ./xpn_docker.sh bash 1
 cd ./test
 ./xpn-mpi-fuse.sh
 exit

 : Step 3. 
 ./xpn_docker.sh stop
   ```

  <html>
  </td>
  <td>
  </html>

  ```bash
 : Step 1. 
 ./xpn_docker.sh start 3
 ./xpn_docker.sh status

 : Step 2. 
 ./xpn_docker.sh bash 1
 cd ./test
 ./xpn-mpi-bypass.sh
 exit

 : Step 3. 
 ./xpn_docker.sh stop
  ```

  <html>
  </td>
  <td>
  </html>

  ```bash
 : Step 1. 
 ./xpn_docker.sh start 3
 ./xpn_docker.sh status

 : Step 2. 
 ./xpn_docker.sh bash 1
 cd ./test
 ./xpn-mpi-native.sh
 exit

 : Step 3. 
 ./xpn_docker.sh stop
  ```

  <html>
  </td>
  </tr>
  </table>
  </html>


  The general steps are:
   1. Starting 3 containers
   2. Then, do some work from container 1
      * Bash on container 1
      * Execute example with Expand native access or access by using FUSE or by using LD_PRELOAD
      * Exit from container 1
   4. Stopping all containers


### 4.2 Examples of benchmarks with XPN Ad-Hoc

  <html>
  <table>
  <tr>
  <td>
MDtest
  </td>
  <td>
IOR
  </td>
  </tr>
  <tr>
  <td>
  </html>
   
  ```bash
  : 1. To start 3 containers,
  : 2. sleep 5 seconds,
  : 3. work from container 1,
  : 4. and stop all containers
  
  ./xpn_docker.sh \
     start 3 \
     sleep 5 \
     exec 1 "./benchmark/xpn-mpi-mdtest.sh" \
     stop
  ```

  <html>
  </td>
  <td>
  </html>
   
  ```bash
  : 1. To start 3 containers,
  : 2. sleep 5 seconds,
  : 3. work from container 1,
  : 4. and stop all containers
  
  ./xpn_docker.sh \
     start 3 \
     sleep 5 \
     exec 1 "./benchmark/xpn-mpi-ior.sh" \
     stop
  ```
    
  <html>
  </td>
  </tr>
  </table>
  </html>


### 4.3 Example of Ad-Hoc XPN with Apache Spark

<html>
 <table>
  <tr>
  <td>
  Word count
  </td>
  </tr>
  <tr>
  <td>
  </html>
  
  ```bash
  : 1. To start 3 containers
  ./xpn_docker.sh start 3
  ./xpn_docker.sh sleep 5

  : 2. Work from container 1
  ./xpn_docker.sh exec 1 ./spark/quixote-local.sh
  ./xpn_docker.sh exec 1 ./spark/quixote-xpn.sh

  : 3. Stop all containers
  ./xpn_docker.sh stop
  ```
  
  <html>
  </td>
  </tr>
 </table>
</html>


## 5. Multiple containers on multiple nodes

   An example using multiples nodes is:
   ```bash
   : Step 1: Starting docker swarm
   ./xpn-docker.sh swarm-create machinefile

        : Step 2: Starting containers
        NC=$(wc machines | awk '{print $1}')
        ./xpn-docker.sh start $NC

             : Step 3: Doing execution
             ./xpn_docker.sh bash 1
             ./benchmark/xpn-mpi-native.sh
             exit
    
        : Step 4: Stopping containers (undoing 2)
        ./xpn-docker.sh stop

   : Step 5: Stopping docker swarm (undoing 1)
   ./xpn-docker.sh swarm-destroy
   ```

   The general steps are:
   1. Starting docker swarm
   2. Starting containers
   3. Doing execution
   4. Stopping containers (undoing 2)
   5. Stopping docker swarm (undoing 1)


## Authors
* :technologist: Félix García-Carballeira
* :technologist: Alejandro Calderón Mateos
* :technologist: Diego Camarmas Alonso
* :technologist: Dario Muñoz Muñoz
* :technologist: Elias del Pozo Puñal


