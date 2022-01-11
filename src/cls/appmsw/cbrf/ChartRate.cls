/*!
 * Chart.js
 * http://chartjs.org/
 * Version: 2.7.3
 *
 * Copyright 2018 Chart.js Contributors
 * Released under the MIT license
 * https://github.com/chartjs/Chart.js/blob/master/LICENSE.md
 */

Include apptools.core

Class appmsw.cbrf.ChartRate Extends apptools.Chart.ChartPanel
{

/// do ##class(appmsw.cbrf.ChartRate).AllCurrencies(.arg,1200,.res, .data, .labels)
ClassMethod AllCurrencies(arg, days, res, data, labels)
{
	do ..GetValueCurrencies(days,.res)
	
	set df=$p(res," ",1) //date from
	set dt=$p(res," ",2) //date to
	set arg("header")="All Currencies "_df_" - "_dt
	set arg("type")="line"
	set labels="["
	for yyyy=$p(df,".",3):1:$p(dt,".",3) {
		for m=1:1:12 {
			if yyyy=$p(df,".",3),m<$p(df,".",2)  continue
			if yyyy=$p(dt,".",3),m>$p(dt,".",2)  continue
			if m?1n s mm="0"_m
			else  s mm=m
			set labels=labels_""""_##class(apptools.core.type).GetTextMonth(mm)_"."_yyyy_""","
			set a="" f num=1:1 { s a=$o(res(a)) q:a=""
				if '$d(color(a)) s color(a)=num
				if '$d(data(a)) s data(a)="{  label: """_a_""", borderColor: '"_..ColorRGBa(color(a),1)_"',  data: ["
				set data(a)=data(a)_+$g(res(a,yyyy,mm))_","
			}

		}
	}
 do ..FinishArg(.res, .data, .labels, .arg)
 if 1 { //debug
	 w "<pre>" zw res zw data zw labels zw arg w "</pre>"
 }
 quit $$$OK
}

/// do ##class(appmsw.cbrf.ChartRate).GetValueCurrencies(1200,.res) zw res
/// do ##class(appmsw.cbrf.ChartRate).GetValueCurrencies("2021-01-11,2022-01-11","GBP,USD,EUR".res) zw res
ClassMethod GetValueCurrencies(date, curr, res)
{
	set from=date
		,to=date
	if date?1n.n {
		set period=##class(apptools.core.files).getPeriod(date,.FromDateTime,.ToDateTime,.df,.dt)
		set date=##class(apptools.core.type).getYYYYMMDD(df)_","_##class(apptools.core.type).getYYYYMMDD(dt)
		
	}
	if date["," {
		set from=$p(date,",",1)
		set to=$p(date,",",2)
	}
	set gn="^tmpRate"
	set sql="select CharCode, DateExchangeRates, DateReq, LastChanged, Nominal, NumCode, Value from appmsw_cbrf.tabex where DateExchangeRates >= '"_from_"' and DateExchangeRates <= '"_to_"'"
	do ##class(apptools.core.sys).SaveSQL(sql,gn)
	for i=1:1 { quit:'$d(@gn@(i))
		
	}
}

}

