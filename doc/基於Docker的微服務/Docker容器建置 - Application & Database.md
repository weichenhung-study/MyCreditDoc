# Docker容器建置 - Application & Database 
## 1. 建置資料庫容器，
### 1.1 儲存客戶信用卡資訊（customerinfo-service）:3307
#### (1)啟動Docker容器，該容器內運行MySQL資料庫服務
    docker run -p 3307:3306 --name customerinfo-service -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=apdata -d mysql:8.0

#### (2)創建網域
    docker network create mysqlnetwork

#### (3)將資料庫加入網域
    docker network connect mysqlnetwork customerinfo-service

#### (4)查看網域內容器
    docker network inspect mysqlnetwork

#### (5)查看DATABASES
    docker run -it --network mysqlnetwork --rm mysql mysql -h customerinfo-service -uroot -proot -e "SHOW DATABASES;"

#### (6)check db table
    docker run -it --network mysqlnetwork --rm mysql mysql -h customerinfo-service -uroot -proot

#### (7)創建table
    docker run -it --network mysqlnetwork --rm mysql mysql -h customerinfo-service -uroot -proot -e "USE apdata; CREATE TABLE cuscredit (chName VARCHAR(50),enName VARCHAR(50),cid VARCHAR(20),cidReissueDate VARCHAR(10),cidReissueLocation VARCHAR(10),cidReissueStatus VARCHAR(5),birthDate VARCHAR(10),maritalStatus VARCHAR(2),education VARCHAR(2),currentResidentialAdd VARCHAR(255),residentialAdd VARCHAR(255),cellphone VARCHAR(10),email VARCHAR(100),companyName VARCHAR(100),companyIndustry VARCHAR(2),occupation VARCHAR(10),department VARCHAR(10),jobTitle VARCHAR(10),dateOfEmployment VARCHAR(10),companyAddress VARCHAR(255),companyPhoneNum VARCHAR(20),annualIncome VARCHAR(5),cardApprovalStatus VARCHAR(2),ApplyRemark VARCHAR(20),activationRecord VARCHAR(2),eventCode VARCHAR(10),regidate VARCHAR(23),issuing_bank VARCHAR(15),cardNum VARCHAR(20),securityCode VARCHAR(5),status VARCHAR(2),cardType VARCHAR(5),remark VARCHAR(20));"

#### (8)查看table建立是否完成
    docker run -it --network mysqlnetwork --rm mysql mysql -h customerinfo-service -uroot -proot
USE apdata; SHOW TABLES;
exit;

### 1.2 儲存信用卡交易、帳單紀錄（billinginfo-service）:3308
#### (1)啟動Docker容器，該容器內運行MySQL資料庫服務
    docker run -p 3308:3306 --name billinginfo-service -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=apdata -d mysql:8.0

#### (2)創建網域
    docker network create mysqlnetwork

#### (3)將資料庫加入網域
    docker network connect mysqlnetwork billinginfo-service

#### (4)查看網域內容器
    docker network inspect mysqlnetwork

#### (5)查看DATABASES
    docker run -it --network mysqlnetwork --rm mysql mysql -h billinginfo-service -uroot -proot -e "SHOW DATABASES;"

#### (6)check db table
    docker run -it --network mysqlnetwork --rm mysql mysql -h billinginfo-service -uroot -proot

#### (7)創建table
    docker run -it --network mysqlnetwork --rm mysql mysql -h billinginfo-service -uroot -proot -e "USE apdata; CREATE TABLE billrecord (uuid VARCHAR(36),buyChannel VARCHAR(2),buyDate VARCHAR(23),reqPaymentDate VARCHAR(23),cardType VARCHAR(5),shopId VARCHAR(20),cid VARCHAR(10),buyCurrency VARCHAR(10),buyAmount VARCHAR(10),disputedFlag VARCHAR(2),status VARCHAR(2),actuallyDate VARCHAR(23),remark VARCHAR(50),issuingBank VARCHAR(50),cardNum VARCHAR(20),securityCode VARCHAR(10)); CREATE TABLE billofmonth (uuid VARCHAR(36),cid VARCHAR(10),cardType VARCHAR(5),writeDate VARCHAR(23),billData LONGTEXT,billMonth VARCHAR(7),amt VARCHAR(255),paidAmount VARCHAR(255),notPaidAmount VARCHAR(255),cycleRate VARCHAR(100),cycleAmt VARCHAR(255),spaceCycleRate VARCHAR(100),spaceAmt VARCHAR(255),payDate VARCHAR(23));"

#### (8)查看table建立是否完成
    docker run -it --network mysqlnetwork --rm mysql mysql -h billinginfo-service -uroot -proot
USE apdata; SHOW TABLES;
exit;



## 2.建置application
### 2.1 信用卡管理服務（management-api）:8081
#### (1)cd到專案dockerfile目錄
#### (2)創建映像檔
    docker build -t management-api-img .
#### (3)啟動容器
    docker run -p 8081:8080 --name management-api --net mysqlnetwork -e MYSQL_HOST=customerinfo-service -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root management-api-img

### 2.2 交易服務（transactions-api）:8082
#### (1)cd到專案dockerfile目錄
#### (2)創建映像檔
    docker build -t transactions-api-img .
#### (3)啟動容器
    docker run -p 8082:8080 --name transactions-api --net mysqlnetwork -e MYSQL_HOST=customerinfo-service -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root transactions-api-img

### 2.3 帳單服務（billing-api）:8083
#### (1)cd到專案dockerfile目錄
#### (2)創建映像檔
    docker build -t billing-api-img .
#### (3)啟動容器
    docker run -p 8083:8080 --name billing-api --net mysqlnetwork -e MYSQL_HOST=customerinfo-service -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root billing-api-img

### 2.4 爭議處理服務（dispute-api）:8084
#### (1)cd到專案dockerfile目錄
#### (2)創建映像檔
    docker build -t dispute-api-img .
#### (3)啟動容器
    docker run -p 8084:8080 --name dispute-api --net mysqlnetwork -e MYSQL_HOST=customerinfo-service -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=apdata -e MYSQL_USER=root -e MYSQL_PASSWORD=root dispute-api-img

