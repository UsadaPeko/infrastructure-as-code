# ! Alert

`atlantis.yaml`을 만들고, 내부에 `projects`를 설정해주지 않는 이상

`modules` 폴더 외부에 module을 만드는 경우, module이 root directory로 잡혀서 (sub workspace) 원하는대로 구성하지 못하고, 꼬이는 문제가 발생함

항상 module은 `modules` 폴더 내부에 만들어두도록 할 것 !!
