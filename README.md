# 📦 Helm Chart

Kubernetes에서 정의된 서비스를 배포하고 관리하기 위한 도구구

---

## 📌 Helm이란?

Helm은 Kubernetes의 **패키지 매니저**로, 복잡한 리소스 정의(YAML)를 **템플릿화**하여 재사용 가능하게 만들고, **버전 관리, 값 주입, 간편 배포** 등을 가능하게 해준다.

### Helm을 사용하는 이유

- ✅ **재사용성**: 같은 리소스를 여러 환경(dev, stage, prod)에서 변수만 바꿔 재사용 가능
- ✅ **버전 관리**: Helm Chart도 버전이 있고, rollback도 가능
- ✅ **템플릿화**: 복잡한 YAML을 템플릿으로 구성해 유지보수 용이
- ✅ **배포 자동화**: `helm install` 혹은 `helm upgrade` 한 줄로 배포 가능
- ✅ **Values 관리**: 설정 파일 하나로 배포 설정 전체를 조절할 수 있음

---

## 📂 프로젝트 구조

```bash
mongo-rs/
├── charts/                 # 하위 의존 Chart 디렉터리 (보통 비워둠)
├── templates/              # Kubernetes 리소스 템플릿이 위치
│   ├── deployment.yaml     # Deployment 템플릿
│   ├── service.yaml        # Service 템플릿
│   ├── ingress.yaml        # (옵션) Ingress 템플릿
│   ├── _helpers.tpl        # 공통 템플릿 함수 정의
│   └── NOTES.txt           # 설치 후 출력 메시지
├── values.yaml             # 사용자 설정값 파일 (기본값 포함)
├── Chart.yaml              # Chart 메타데이터 정의
└── README.md               # 설명서 (본 문서)
```
