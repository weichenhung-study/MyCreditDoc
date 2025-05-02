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

## ⭐ 2.建置DB Interface(Jersey)
### 💠 2.1 jdbc-cuscredit-api:8081
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jdbc-cuscredit-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8081:8080 --name jdbc-cuscredit-api --net mysqlnetwork -e MYSQL_HOST=cuscredit-db -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root jdbc-cuscredit-api-img

### 💠 2.2 jdbc-billofmonth-api :8082
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jdbc-billofmonth-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8082:8080 --name jdbc-billofmonth-api --net mysqlnetwork -e MYSQL_HOST=billofmonth-db -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root jdbc-billofmonth-api-img

### 💠 2.3 jdbc-billrecord-api:8083
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jdbc-billrecord-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8083:8080 --name jdbc-billrecord-api --net mysqlnetwork -e MYSQL_HOST=billrecord-db -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root jdbc-billrecord-api-img



## ⭐ 3.建置application(Jersey)
### 💠 3.1 信用卡管理服務（jersey-management-api）:8084
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jersey-management-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8084:8080 --name jersey-management-api --net mysqlnetwork jersey-management-api-img

### 💠 3.2 交易服務（jersey-transactions-api）:8085
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jersey-transactions-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8085:8080 --name jersey-transactions-api --net mysqlnetwork jersey-transactions-api-img

### 💠 3.3 帳單服務（jersey-billing-api）:8086
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jersey-billing-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8086:8080 --name jersey-billing-api --net mysqlnetwork jersey-billing-api-img

### 💠 3.4 爭議處理服務（jersey-dispute-api）:8087
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jersey-dispute-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8087:8080 --name jersey-dispute-api --net mysqlnetwork jersey-dispute-api-img



## ⭐ 4.建置DB Interface(Spring Boot)
### 💠 4.1 jpa-cuscredit-api:8088
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jpa-cuscredit-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8088:8080 --name jpa-cuscredit-api --net mysqlnetwork -e MYSQL_HOST=cuscredit-db -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root jpa-cuscredit-api-img

### 💠 4.2 jpa-billofmonth-api :8089
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jpa-billofmonth-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8089:8080 --name jpa-billofmonth-api --net mysqlnetwork -e MYSQL_HOST=billofmonth-db -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root jpa-billofmonth-api-img

### 💠 4.3 jpa-billrecord-api:8090
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jpa-billrecord-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8090:8080 --name jpa-billrecord-api --net mysqlnetwork -e MYSQL_HOST=billrecord-db -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root jpa-billrecord-api-img



## ⭐ 5.建置application(Spring Boot)
### 💠 5.1 信用卡管理服務（springboot-management-api）:8091
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t springboot-management-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8091:8080 --name springboot-management-api --net mysqlnetwork springboot-management-api-img

### 💠 5.2 交易服務（springboot-transactions-api）:8092
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t springboot-transactions-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8092:8080 --name springboot-transactions-api --net mysqlnetwork springboot-transactions-api-img

### 💠 5.3 帳單服務（springboot-billing-api）:8093
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t springboot-billing-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8093:8080 --name springboot-billing-api --net mysqlnetwork springboot-billing-api-img

### 💠 5.4 爭議處理服務（springboot-dispute-api）:8094
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t springboot-dispute-api-img .
#### 🔸 (3) 啟動容器
    docker run -p 8094:8080 --name springboot-dispute-api --net mysqlnetwork springboot-dispute-api-img



## ⭐ 6.建置API Gateway(Spring Boot)
### 💠 6.1 springboot服務閘道（springboot-apigateway）:8095
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t springboot-apigateway-img .
#### 🔸 (3) 啟動容器
    docker run -p 8095:8080 --name springboot-apigateway --net mysqlnetwork springboot-apigateway-img

### 💠 6.2 jersey（jersey-apigateway）:8096
#### 🔸 (1) cd到專案dockerfile目錄
	mvn clean package
#### 🔸 (2) 創建映像檔
    docker build -t jersey-apigateway-img .
#### 🔸 (3) 啟動容器
    docker run -p 8096:8080 --name jersey-apigateway --net mysqlnetwork jersey-apigateway-img

