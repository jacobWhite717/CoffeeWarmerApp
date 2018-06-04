#include "CoffeeCup.h"

#include <QTime>
#include <QDate>

using namespace std;

CoffeeCup::CoffeeCup() :
    mId(-1),
    mDate(""),
    mStartTime(""),
    mEndTime(""),
    mDuration(""),
    mMaxTemp(INT_MIN),
    mMinTemp(INT_MAX),
    mAvgTemp(0),
    mTemperatures(vector<int>())
{
    mTime.start();
}

int CoffeeCup::id() const
{
    return mId;
}

void CoffeeCup::setId(int id)
{
    mId = id;
}

QString CoffeeCup::date() const
{
    return mDate;
}

void CoffeeCup::setDate(const QString &date)
{
    mDate = date;
}

QString CoffeeCup::startTime() const
{
    return mStartTime;
}

void CoffeeCup::setStartTime(const QString &startTime)
{
    mStartTime = startTime;
}

QString CoffeeCup::endTime() const
{
    return mEndTime;
}

void CoffeeCup::setEndTime(const QString &endTime)
{
    mEndTime = endTime;
}

QString CoffeeCup::duration() const
{
    return mDuration;
}

void CoffeeCup::setDuration(const QString &duration)
{
    mDuration = duration;
}

int CoffeeCup::maxTemp() const
{
    return mMaxTemp;
}

void CoffeeCup::setMaxTemp(int maxTemp)
{
    mMaxTemp = maxTemp;
}

int CoffeeCup::minTemp() const
{
    return mMinTemp;
}

void CoffeeCup::setMinTemp(int minTemp)
{
    mMinTemp = minTemp;
}

double CoffeeCup::avgTemp() const
{
    return mAvgTemp;
}

void CoffeeCup::setAvgTemp(double avgtemp)
{
    mAvgTemp = avgtemp;
}

void CoffeeCup::enterCurrentTemp(int currentTemp)
{
    mTemperatures.push_back(currentTemp);
}

void CoffeeCup::startCurrentCup()
{
    mTime.restart();
    mStartTime = mTime.currentTime().toString("h:mm ap");

    QDate date;
    mDate = date.currentDate().toString("yyyy.MM.dd");

    setId(-1);
    setEndTime("");
    setDuration("");
    setMaxTemp(INT_MIN);
    setMinTemp(INT_MAX);
    setAvgTemp(0);
    mTemperatures.clear();
}

void CoffeeCup::endCurrentCup()
{
    int elapsedTime = mTime.elapsed();
    QString minutes = QString::number(int(elapsedTime/(1000*60)));
    QString seconds = QString::number((elapsedTime/(1000))%60);

    mDuration = minutes + ":" + QTime::fromString(seconds, "s").toString("ss");

    mEndTime = mTime.currentTime().toString("h:mm ap");
}

void CoffeeCup::updateTemps()
{
    if(mTemperatures.size()!=0) {
        if(mTemperatures.back() > mMaxTemp){
            setMaxTemp(mTemperatures.back());
        }

        if(mTemperatures.back() < mMinTemp){
            setMinTemp(mTemperatures.back());
        }

        double tempSum = 0;
        for(double temp : mTemperatures){
           tempSum += temp;
        }
        setAvgTemp(tempSum/mTemperatures.size()) ;
    }
}
