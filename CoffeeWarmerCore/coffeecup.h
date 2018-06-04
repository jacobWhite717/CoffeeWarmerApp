#ifndef COFFEECUP_H
#define COFFEECUP_H

#include<QString>
#include<vector>
#include<QTime>

#include<coffeewarmercore_global.h>

class COFFEEWARMERCORESHARED_EXPORT CoffeeCup
{
public:
    CoffeeCup();

    int id() const;
    void setId(int id);

    QString date() const;
    void setDate(const QString& date);

    QString startTime() const;
    void setStartTime(const QString &startTime);

    QString endTime() const;
    void setEndTime(const QString &endTime);

    QString duration() const;
    void setDuration(const QString &duration);

    int maxTemp() const;
    void setMaxTemp(int maxTemp);

    int minTemp() const;
    void setMinTemp(int minTemp);

    double avgTemp() const;
    void setAvgTemp(double avgTemp);

    void enterCurrentTemp(int currentTemp);
    void updateTemps(); // update temperature stats when push_back a new data point into mTemperatures

    void startCurrentCup();
    void endCurrentCup();

private:
    int mId;
    QString mDate;
    QString mStartTime;
    QString mEndTime;
    QString mDuration;
    int mMaxTemp;
    int mMinTemp;
    double mAvgTemp;
    std::vector<int> mTemperatures;
    QTime mTime;
};

#endif // COFFEECUP_H
