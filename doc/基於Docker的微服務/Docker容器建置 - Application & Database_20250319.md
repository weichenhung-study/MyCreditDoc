# Docker容器建置 - Application & Database 

## ⭐ 1. 建置資料庫容器
### 💠 1.1 儲存客戶信用卡資訊（cuscredit-db）:3307
#### 🔸 (1) 啟動Docker容器，該容器內運行MySQL資料庫服務
    docker run -p 3307:3306 --name cuscredit-db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=apdata -d mysql:8.0

#### 🔸 (2) 創建網域
    docker network create mysqlnetwork

#### 🔸 (3) 將資料庫加入網域
    docker network connect mysqlnetwork cuscredit-db

#### 🔸 (4) 查看網域內容器
    docker network inspect mysqlnetwork

#### 🔸 (5) 查看DATABASES
    docker run -it --network mysqlnetwork --rm mysql mysql -h cuscredit-db -uroot -proot -e "USE apdata;SHOW DATABASES;"

#### 🔸 (6) 創建table
    docker run -it --network mysqlnetwork --rm mysql mysql -h cuscredit-db -uroot -proot -e "USE apdata; CREATE TABLE cuscredit (chName VARCHAR(50),enName VARCHAR(50),cid VARCHAR(20),cidReissueDate VARCHAR(10),cidReissueLocation VARCHAR(10),cidReissueStatus VARCHAR(5),birthDate VARCHAR(10),maritalStatus VARCHAR(2),education VARCHAR(2),currentResidentialAdd VARCHAR(255),residentialAdd VARCHAR(255),cellphone VARCHAR(10),email VARCHAR(100),companyName VARCHAR(100),companyIndustry VARCHAR(2),occupation VARCHAR(10),department VARCHAR(10),jobTitle VARCHAR(10),dateOfEmployment VARCHAR(10),companyAddress VARCHAR(255),companyPhoneNum VARCHAR(20),annualIncome VARCHAR(5),cardApprovalStatus VARCHAR(2),ApplyRemark VARCHAR(20),activationRecord VARCHAR(2),eventCode VARCHAR(10),regidate VARCHAR(23),issuing_bank VARCHAR(15),cardNum VARCHAR(20),securityCode VARCHAR(5),status VARCHAR(2),cardType VARCHAR(5),remark VARCHAR(20));"

#### 🔸 (7) 查看table建立是否完成
	docker run -it --network mysqlnetwork --rm mysql mysql -h cuscredit-db -uroot -proot -e "USE apdata;SHOW TABLES;

### 💠 1.2 信用卡帳單紀錄服務（billofmonth-db）:3308
#### 🔸 (1) 啟動Docker容器，該容器內運行MySQL資料庫服務
    docker run -p 3308:3306 --name billofmonth-db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=apdata -d mysql:8.0

#### 🔸 (2) 創建網域
    docker network create mysqlnetwork

#### 🔸 (3) 將資料庫加入網域
    docker network connect mysqlnetwork billofmonth-db

#### 🔸 (4) 查看網域內容器
    docker network inspect mysqlnetwork

#### 🔸 (5) 查看DATABASES
    docker run -it --network mysqlnetwork --rm mysql mysql -h billofmonth-db -uroot -proot -e "USE apdata;SHOW DATABASES;"

#### 🔸 (6) 創建table
    docker run -it --network mysqlnetwork --rm mysql mysql -h billofmonth-db -uroot -proot -e "USE apdata; CREATE TABLE billofmonth (uuid VARCHAR(36),cid VARCHAR(10),cardType VARCHAR(5),writeDate VARCHAR(23),billData LONGTEXT,billMonth VARCHAR(7),amt VARCHAR(255),paidAmount VARCHAR(255),notPaidAmount VARCHAR(255),cycleRate VARCHAR(100),cycleAmt VARCHAR(255),spaceCycleRate VARCHAR(100),spaceAmt VARCHAR(255),payDate VARCHAR(23));"

#### 🔸 (7) 查看table建立是否完成
    docker run -it --network mysqlnetwork --rm mysql mysql -h billofmonth-db -uroot -proot -e "USE apdata;SHOW TABLES;

### 💠 1.3 信用卡交易紀錄服務（billrecord-db）:3309
#### 🔸 (1) 啟動Docker容器，該容器內運行MySQL資料庫服務
    docker run -p 3309:3306 --name billrecord-db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=apdata -d mysql:8.0

#### 🔸 (2) 創建網域
    docker network create mysqlnetwork

#### 🔸 (3) 將資料庫加入網域
    docker network connect mysqlnetwork billrecord-db

#### 🔸 (4) 查看網域內容器
    docker network inspect mysqlnetwork

#### 🔸 (5) 查看DATABASES
    docker run -it --network mysqlnetwork --rm mysql mysql -h billrecord-db -uroot -proot -e "USE apdata;SHOW DATABASES;"

#### 🔸 (6) 創建table
    docker run -it --network mysqlnetwork --rm mysql mysql -h billrecord-db -uroot -proot -e "USE apdata; CREATE TABLE billrecord (uuid VARCHAR(36),buyChannel VARCHAR(2),buyDate VARCHAR(23),reqPaymentDate VARCHAR(23),cardType VARCHAR(5),shopId VARCHAR(20),cid VARCHAR(10),buyCurrency VARCHAR(10),buyAmount VARCHAR(10),disputedFlag VARCHAR(2),status VARCHAR(2),actuallyDate VARCHAR(23),remark VARCHAR(50),issuingBank VARCHAR(50),cardNum VARCHAR(20),securityCode VARCHAR(10));"

#### 🔸 (7) 查看table建立是否完成
    docker run -it --network mysqlnetwork --rm mysql mysql -h billrecord-db -uroot -proot -e "USE apdata;SHOW TABLES;"

#### 🔺 SQL指令放於「""」內
    docker run -it --network mysqlnetwork --rm mysql mysql -h billrecord-db -uroot -proot -e "USE apdata; SELECT COUNT(*) FROM billrecord;"
	exit;




## ⭐ 2. 建置「全」資料庫容器─monolith、modular-monolith專用
### 💠 2.1 儲存客戶信用卡資訊（monolith-db）:3301
#### 🔸 (1) 啟動Docker容器，該容器內運行MySQL資料庫服務
    docker run -p 3301:3306 --name monolith-db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=apdata -d mysql:8.0

#### 🔸 (2) 創建網域
    docker network create monolithnetwork

#### 🔸 (3) 將資料庫加入網域
    docker network connect monolithnetwork monolith-db

#### 🔸 (4) 查看網域內容器
    docker network inspect monolithnetwork

#### 🔸 (5) 查看DATABASES
    docker run -it --network monolithnetwork --rm mysql mysql -h monolith-db -uroot -proot -e "USE apdata;SHOW DATABASES;"

#### 🔸 (6) 創建table
	docker run -it --network monolithnetwork --rm mysql mysql -h monolith-db -uroot -proot -e "USE apdata; CREATE TABLE cuscredit (chName VARCHAR(50),enName VARCHAR(50),cid VARCHAR(20),cidReissueDate VARCHAR(10),cidReissueLocation VARCHAR(10),cidReissueStatus VARCHAR(5),birthDate VARCHAR(10),maritalStatus VARCHAR(2),education VARCHAR(2),currentResidentialAdd VARCHAR(255),residentialAdd VARCHAR(255),cellphone VARCHAR(10),email VARCHAR(100),companyName VARCHAR(100),companyIndustry VARCHAR(2),occupation VARCHAR(10),department VARCHAR(10),jobTitle VARCHAR(10),dateOfEmployment VARCHAR(10),companyAddress VARCHAR(255),companyPhoneNum VARCHAR(20),annualIncome VARCHAR(5),cardApprovalStatus VARCHAR(2),ApplyRemark VARCHAR(20),activationRecord VARCHAR(2),eventCode VARCHAR(10),regidate VARCHAR(23),issuing_bank VARCHAR(15),cardNum VARCHAR(20),securityCode VARCHAR(5),status VARCHAR(2),cardType VARCHAR(5),remark VARCHAR(20));"
	docker run -it --network monolithnetwork --rm mysql mysql -h monolith-db -uroot -proot -e "USE apdata; CREATE TABLE billofmonth (uuid VARCHAR(36),cid VARCHAR(10),cardType VARCHAR(5),writeDate VARCHAR(23),billData LONGTEXT,billMonth VARCHAR(7),amt VARCHAR(255),paidAmount VARCHAR(255),notPaidAmount VARCHAR(255),cycleRate VARCHAR(100),cycleAmt VARCHAR(255),spaceCycleRate VARCHAR(100),spaceAmt VARCHAR(255),payDate VARCHAR(23));"
    docker run -it --network monolithnetwork --rm mysql mysql -h monolith-db -uroot -proot -e "USE apdata; CREATE TABLE billrecord (uuid VARCHAR(36),buyChannel VARCHAR(2),buyDate VARCHAR(23),reqPaymentDate VARCHAR(23),cardType VARCHAR(5),shopId VARCHAR(20),cid VARCHAR(10),buyCurrency VARCHAR(10),buyAmount VARCHAR(10),disputedFlag VARCHAR(2),status VARCHAR(2),actuallyDate VARCHAR(23),remark VARCHAR(50),issuingBank VARCHAR(50),cardNum VARCHAR(20),securityCode VARCHAR(10));"

#### 🔸 (7) 查看table建立是否完成
	docker run -it --network monolithnetwork --rm mysql mysql -h monolith-db -uroot -proot -e "USE apdata;SHOW TABLES;



## ⭐ 3. jersey-monolith:8071
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jersey-monolith-img .
#### 🔸 (3) 啟動容器
    docker run -d -p 8071:8080 --name jersey-monolith --net monolithnetwork jersey-monolith-img



## ⭐ 4. jersey-modular-monolith:8072
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jersey-modular-monolith-img .
#### 🔸 (3) 啟動容器
    docker run -d -p 8072:8080 --name jersey-modular-monolith --net monolithnetwork jersey-modular-monolith-img




## ⭐ 5.建置jersey-microservice
#### 🔸 (1) cd到專案docker-compose.yml目錄
	mvn clean package
#### 🔸 (2)  啟動容器
    docker-compose up --build -d
#### 🔺 針對其中一個重建
	(1) 到該目錄層下重新打包
		mvn clean package
	(2) 重新建構 Docker 映像檔
		docker build -t jersey-microservice-management-img .
	(3) 重新啟動專案	
		docker-compose up -d --no-deps --build jersey-microservice-management



## ⭐ 6.建置jersey-microservice-jdbc
#### 🔸 (1) cd到專案docker-compose.yml目錄
	mvn clean package
#### 🔸 (2)  啟動容器
    docker-compose up --build -d
#### 🔺 針對其中一個重建
	(1) 到該目錄層下重新打包
		mvn clean package
	(2) 重新建構 Docker 映像檔
		docker build -t jersey-microservice-jdbc-cuscredit-img .
	(3) 重新啟動專案	
		docker-compose up -d --no-deps --build jersey-microservice-jdbc-cuscredit



## ⭐ 7. jersey-microservice-gateway:8096
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jersey-microservice-gateway-img .
#### 🔸 (3) 啟動容器
    docker run -d -p 8096:8080 --name jersey-microservice-gateway --net mysqlnetwork jersey-microservice-gateway-img



## ⭐ 8. springboot-modular-monolith:8073
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t springboot-modular-monolith-img .
#### 🔸 (3) 啟動容器
    docker run -d -p 8073:8080 --name springboot-modular-monolith --net monolithnetwork springboot-modular-monolith-img



## ⭐ 9.建置springboot-microservice-jpa
#### 🔸 (1) cd到專案docker-compose.yml目錄
	mvn clean package
#### 🔸 (2)  啟動容器
    docker-compose up --build -d
#### 🔺 針對其中一個重建
	(1) 到該目錄層下重新打包
		mvn clean package
	(2) 重新建構 Docker 映像檔
		docker build -t springboot-microservice-jpa-cuscredit-img .
	(3) 重新啟動專案	
		docker-compose up -d --no-deps --build springboot-microservice-jpa-cuscredit

## ⭐ 10.設定「springboot-microservice-aamode」專用的分流設定：
拉取分流server
docker run -d --name=consul -p 8500:8500 consul
docker network connect mysqlnetwork consul



## ⭐ 11.建置springboot-microservice
#### 🔸 (1) cd到專案docker-compose.yml目錄
	mvn clean package
#### 🔸 (2)  啟動容器
    docker-compose up --build -d
#### 🔺 針對其中一個重建
	(1) 到該目錄層下重新打包
		mvn clean package
	(2) 重新建構 Docker 映像檔
		docker build -t springboot-microservice-management-img .
	(3) 重新啟動專案	
		docker-compose up -d --no-deps --build springboot-microservice-management



## ⭐ 12. springboot-microservice-gateway:8095
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t springboot-microservice-gateway-img .
#### 🔸 (3) 啟動容器
    docker run -d -p 8095:8080 --name springboot-microservice-gateway --net mysqlnetwork springboot-microservice-gateway-img



## ⭐ 13. springboot-microservice-aamode
#### 🔸 (1) cd到專案docker-compose.yml目錄
	mvn clean package
#### 🔸 (2)  啟動容器
    docker-compose up --build -d


## ⭐ 14.設定「jersey-microservice-aamode」專用的分流設定：
	docker run -d --name=jersey-consul --network=mysqlnetwork -p 8501:8500 consul:1.14


## ⭐ 15. jersey-microservice-aamode
#### 🔸 (1) cd到專案docker-compose.yml目錄
	mvn clean package
#### 🔸 (2)  啟動容器
    docker-compose up --build -d



## ⭐ 16. 移除多餘的 Consul 實例
#### 🔸 針對特定的刪除
	curl --request PUT http://localhost:8500/v1/agent/service/deregister/gateway-service-04ac3bb9aa27d96503c2768ea2c5174b



## ⭐ 17. 釋放 Docker 不必要資源
#### 🔸 清理停止的 Container
	docker container prune

#### 🔸 清理未使用的映像 (image)
	docker image prune -a

#### 🔸 清理未使用的網路 (network)
	docker network prune

#### 🔸 清理所有暫存資源
	docker system prune -a