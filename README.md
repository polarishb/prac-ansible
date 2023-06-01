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

![dashboard](https://github.com/polarishb/prac-ansible/assets/37509306/f4dec189-7106-4695-99b2-29b9627cc1a9)