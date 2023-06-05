# 앤서블로 쿠버네티스 환경 구축 자동화
> 앤서블을 활용하여 쿠버네티스 클러스터를 구축하고 환경설정을 마쳐보자

![](../header.png)

## 설치하기 전에...

해당 자동화 솔루션은 개인 프로젝트로서 작성되었습니다.

아래는 설치하기 전에 필요한 구성입니다.
```
앤서블서버 10.6.3.100
스토리지서버 10.6.3.102
로드밸런싱서버1 10.6.3.201
로드밸런싱서버2 10.6.3.202
마스터노드1 10.6.3.110
마스터노드2 10.6.3.120
마스터노드3 10.6.3.130
워커노드1-1 10.6.3.111
워커노드1-2 10.6.3.112
워커노드2-1 10.6.3.121
워커노드2-2 10.6.3.122
워커노드3-1 10.6.3.131
워커노드3-2 10.6.3.132
```

> ip주소는 개인 설정에따라 변경해주세요.   
> 앤서블 서버는 ```Ansible``` 설치 필요

## 구성요소

![topology](https://github.com/polarishb/prac-ansible/assets/37509306/49bb6cea-dc83-4d54-ad6e-bcccc0bee4cf)


## 설치 방법
> 앤서블 서버에서 실행해주세요.

```yaml
...
    - name: Add Dockerhub Login
      blockinfile:
        path: /etc/containerd/config.toml
        block: |
          [plugins."io.containerd.grpc.v1.cri".registry.configs."registry-1.docker.io".auth]
            username = "DOCKERID"
            password = "DOCKERPASSWD"
...
```
도커허브에 로그인하기 위해`/playbook/install-kubernetes.yml` 를 수정해 줍니다.   

```sh
./init_ansible.sh
```
`init_ansible.sh` 을 실행하여 앤서블 hosts설정과 필요한 모듈을 설치합니다.   

```sh
./install_k8s.sh
```
앤서블 환경설정을 마치면 `install_k8s.sh` 을 실행하여 쿠버네티스 클러스터를 구축합니다.   

## 정상 동작 확인

### 쿠버네티스 클러스터 구축 완료
<img width="556" alt="get_node" src="https://github.com/polarishb/prac-ansible/assets/37509306/149c2622-98b3-4955-bd5f-a8439b91914c">   

### 쿠버네티스에 동작중인 서비스들
<img width="300" alt="kube_system" src="https://github.com/polarishb/prac-ansible/assets/37509306/04185984-9bb8-4cba-8858-a45aa62894c4"> <img width="300" height="257"  alt="monitoring" src="https://github.com/polarishb/prac-ansible/assets/37509306/4d8cad2b-ab73-44bf-ba19-76e9538ff729">   
<img width="300" alt="metallb-system" src="https://github.com/polarishb/prac-ansible/assets/37509306/d81f695c-2637-481e-8dd8-ea31b786c373">    

### 그라파나 모니터링 서비스 실행 확인
![dashboard](https://github.com/polarishb/prac-ansible/assets/37509306/f4dec189-7106-4695-99b2-29b9627cc1a9)    

### 웹 서버 배포
<img width="378" alt="applyYML" src="https://github.com/polarishb/prac-ansible/assets/37509306/7a1c81c9-f9b0-4587-93f5-6188212e07f3">

### 오토스케일링 동작 확인
<img width="300" alt="webpage" src="https://github.com/polarishb/prac-ansible/assets/37509306/f74fd16a-14e6-4f93-b1af-395a51ebbcee"> <img width="300" alt="deploy_containerCreate_monitor" src="https://github.com/polarishb/prac-ansible/assets/37509306/64fb9e38-a990-45d7-b84a-5357aff293e7">    
<img width="300" alt="deploy_autoscaling_monitor" src="https://github.com/polarishb/prac-ansible/assets/37509306/5cc603ca-0e71-40b6-b8fa-ce3c836bff50"> <img width="300" alt="deploy_terminate_monitor" src="https://github.com/polarishb/prac-ansible/assets/37509306/c77078fd-eb88-4ac5-ab6e-88b3f7059c2c">

### 스토리지 서버에 PV/PVC 연결 
<img width="300" alt="pod_df_Th" src="https://github.com/polarishb/prac-ansible/assets/37509306/480691f6-8cd1-47a9-ac0b-bfaa31be7df3"> <img width="300" height="96" alt="nfs_ls" src="https://github.com/polarishb/prac-ansible/assets/37509306/5c655942-43a7-4678-bcda-f2076c9f6321">   
<img width="300" alt="get_pv_pvc" src="https://github.com/polarishb/prac-ansible/assets/37509306/d19bfe5f-1464-4dd8-a3dd-6610591d9539">

