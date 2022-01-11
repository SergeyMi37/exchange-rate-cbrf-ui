[![Repo-GitHub](https://img.shields.io/badge/dynamic/xml?color=gold&label=GitHub%20module.xml&prefix=ver.&query=%2F%2FVersion&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fexchange-rate-cbrf-ui%2Fmaster%2Fmodule.xml)](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/module.xml)
 
![OEX-zapm](https://img.shields.io/badge/dynamic/json?url=https:%2F%2Fpm.community.intersystems.com%2Fpackages%2Fexchange-rate-cbrf-ui%2F&label=ZPM-pm.community.intersystems.com&query=$.version&color=green&prefix=exchange-rate-cbrf-ui)
 
[![Docker-ports](https://img.shields.io/badge/dynamic/yaml?color=blue&label=docker-compose&prefix=ports%20-%20&query=%24.services.iris.ports&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fexchange-rate-cbrf-ui%2Fmaster%2Fdocker-compose.yml)](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/docker-compose.yml)
 
## exchange-rate-cbrf-ui
 [![OEX](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/exchange-rate-cbrf-ui)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fexchange-rate-cbrf-ui&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fexchange-rate-cbrf-ui)
 <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/SergeyMi37/exchange-rate-cbrf-ui">
 
Database of exchange rates of the Central Bank of the Russian Federation. The database usage rights can be found in the [section](https://www.cbr.ru/eng/about/).
The data is real, [it can be used in accounting and forecasting programs](http://www.cbr.ru/scripts/xml_daily.asp?date_req=01.01.2022)  

The project contains a service for initial data initialization and daily updates from the official website of the Central Bank of the Russian Federation, REST service for obtaining exchange rates on request for any period.

## Installation with ZPM

If ZPM the current instance is not installed, then in one line you can install the latest version of ZPM.
```
set $namespace="%SYS", name="DefaultSSL" do:'##class(Security.SSLConfigs).Exists(name) ##class(Security.SSLConfigs).Create(name) set url="https://pm.community.intersystems.com/packages/zpm/latest/installer" Do ##class(%Net.URLParser).Parse(url,.comp) set ht = ##class(%Net.HttpRequest).%New(), ht.Server = comp("host"), ht.Port = 443, ht.Https=1, ht.SSLConfiguration=name, st=ht.Get(comp("path")) quit:'st $System.Status.GetErrorText(st) set xml=##class(%File).TempFilename("xml"), tFile = ##class(%Stream.FileBinary).%New(), tFile.Filename = xml do tFile.CopyFromAndSave(ht.HttpResponse.Data) do ht.%Close(), $system.OBJ.Load(xml,"ck") do ##class(%File).Delete(xml)
```
If ZPM is installed, then `exchange-rate-cbrf-ui` can be set with the command
```
zpm:USER>install exchange-rate-cbrf-ui
```
## Installation with Docker

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/SergeyMi37/exchange-rate-cbrf-ui.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test it
Open IRIS terminal:

```
$ docker-compose exec iris iris session iris

USER>D $System.SQL.Shell()
[SQL]USER>>select CharCode, DateExchangeRates, Nominal, NumCode, Value from appmsw_cbrf.tabex where DateExchangeRates >= '2022-01-04' and DateExchangeRates <= '20221-01-05'
```
![](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/doc/Screenshot_9.png)

## To check the service, open the link:
```
http://localhost:52663/cbrf-rate/exchange/2021-03-03,2022-01-05
```
![](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/doc/Screenshot_1.png)

## Products for daily currency rate updates:
![](https://raw.githubusercontent.com/sergeymi37/exchange-rate-cbrf-ui/master/doc/Screenshot_2.png)
