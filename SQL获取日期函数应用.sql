DECLARE@dtdatetime
SET@dt=GETDATE()

DECLARE@numberint
SET@number=3

--1．指定日期该年的第一天或最后一天
--A. 年的第一天
SELECTCONVERT(char(5),@dt,120)+'1-1'

--B. 年的最后一天
SELECTCONVERT(char(5),@dt,120)+'12-31'


--2．指定日期所在季度的第一天或最后一天
--A. 季度的第一天
SELECTCONVERT(datetime,
    CONVERT(char(8),
        DATEADD(Month,
            DATEPART(Quarter,@dt)*3-Month(@dt)-2,
            @dt),
        120)+'1')

--B. 季度的最后一天（CASE判断法）
SELECTCONVERT(datetime,
    CONVERT(char(8),
        DATEADD(Month,
            DATEPART(Quarter,@dt)*3-Month(@dt),
            @dt),
        120)
    +CASEWHENDATEPART(Quarter,@dt) in(1,4)
        THEN'31'ELSE'30'END)

--C. 季度的最后一天（直接推算法）
SELECTDATEADD(Day,-1,
    CONVERT(char(8),
        DATEADD(Month,
            1+DATEPART(Quarter,@dt)*3-Month(@dt),
            @dt),
        120)+'1')


--3．指定日期所在月份的第一天或最后一天
--A. 月的第一天
SELECTCONVERT(datetime,CONVERT(char(8),@dt,120)+'1')

--B. 月的最后一天
SELECTDATEADD(Day,-1,CONVERT(char(8),DATEADD(Month,1,@dt),120)+'1')

--C. 月的最后一天（容易使用的错误方法）
SELECTDATEADD(Month,1,DATEADD(Day,-DAY(@dt),@dt))


--4．指定日期所在周的任意一天
SELECTDATEADD(Day,@number-DATEPART(Weekday,@dt),@dt)


--5．指定日期所在周的任意星期几
--A.  星期天做为一周的第1天
SELECTDATEADD(Day,@number-(DATEPART(Weekday,@dt)+@@DATEFIRST-1)%7,@dt)

--B.  星期一做为一周的第1天
SELECTDATEADD(Day,@number-(DATEPART(Weekday,@dt)+@@DATEFIRST-2)%7-1,@dt)
