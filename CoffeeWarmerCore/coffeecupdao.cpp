#include "coffeecupdao.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariant>

#include "coffeecup.h"
#include "databasemanager.h"

using namespace std;

CoffeeCupDao::CoffeeCupDao(QSqlDatabase& database) :
    mDatabase(database)
{
}

void CoffeeCupDao::init() const
{
    if(!mDatabase.tables().contains("cupData")){
        QSqlQuery query(mDatabase);
        query.prepare(QString("CREATE TABLE cupData ")
                      + "(id INTEGER PRIMARY KEY AUTOINCREMENT, "
                      + "date TEXT, "
                      + "startTime TEXT, "
                      + "endTime TEXT, "
                      + "duration TEXT, "
                      + "minTemp INTEGER, "
                      + "maxTemp INTEGER, "
                      + "avgTemp DOUBLE)");
        query.exec();

        DatabaseManager::debugQuery(query);
    }
}

void CoffeeCupDao::addRow(CoffeeCup &coffeeCup) const
{
    QSqlQuery query(mDatabase);
    query.prepare(QString("INSERT INTO cupData ")
                  + "(date, startTime, endTime, duration, minTemp, maxTemp, avgTemp) "
                  + "VALUES ("
                  + ":date, :startTime, :endTime, :duration, :minTemp, :maxTemp, :avgTemp"
                  + ")");
    query.bindValue(":date", coffeeCup.date());
    query.bindValue(":startTime", coffeeCup.startTime());
    query.bindValue(":endTime", coffeeCup.endTime());
    query.bindValue(":duration", coffeeCup.duration());
    query.bindValue(":minTemp", coffeeCup.minTemp());
    query.bindValue(":maxTemp", coffeeCup.maxTemp());
    query.bindValue(":avgTemp", coffeeCup.avgTemp());
    query.exec();

    coffeeCup.setId(query.lastInsertId().toInt());

    DatabaseManager::debugQuery(query);
}

void CoffeeCupDao::updateRow(const CoffeeCup &coffeeCup) const
{
    QSqlQuery query(mDatabase);
    query.prepare(QString("UPDATE cupData SET ")
                  + "date = (:date), "
                  + "endTime = (:endTime), "
                  + "startTime = (:startTime), "
                  + "duration = (:duration), "
                  + "minTemp = (:minTemp), "
                  + "maxTemp = (:maxTemp), "
                  + "avgTemp = (:avgTemp) "
                  + "WHERE id = (:id)");
    query.bindValue(":date", coffeeCup.date());
    query.bindValue(":endTime", coffeeCup.endTime());
    query.bindValue(":startTime", coffeeCup.startTime());
    query.bindValue(":duration", coffeeCup.duration());
    query.bindValue(":minTemp", coffeeCup.minTemp());
    query.bindValue(":maxTemp", coffeeCup.maxTemp());
    query.bindValue(":avgTemp", coffeeCup.avgTemp());
    query.exec();

    DatabaseManager::debugQuery(query);
}

void CoffeeCupDao::removeRow(int id) const
{
    QSqlQuery query(mDatabase);
    query.prepare("DELETE FROM cupData WHERE ID = (:id)");
    query.bindValue(":id", id);
    query.exec();

    DatabaseManager::debugQuery(query);
}

void CoffeeCupDao::removeAllRows() const
{
    QSqlQuery query(mDatabase);
    query.prepare("DELETE FROM cupData");
    query.exec();

    DatabaseManager::debugQuery(query);
}

unique_ptr<vector<unique_ptr<CoffeeCup>>> CoffeeCupDao::rows() const
{
    QSqlQuery query(mDatabase);
    query.prepare("SELECT * FROM cupData");
//    query.prepare("SELECT * FROM cupData ORDER BY id DESC");
    query.exec();

    unique_ptr<vector<unique_ptr<CoffeeCup>>> list(new vector<unique_ptr<CoffeeCup>>);
    while(query.next()){
        unique_ptr<CoffeeCup> coffeeCup(new CoffeeCup);
        coffeeCup->setDate(query.value("date").toString());
        coffeeCup->setStartTime(query.value("startTime").toString());
        coffeeCup->setEndTime(query.value("endTime").toString());
        coffeeCup->setDuration(query.value("duration").toString());
        coffeeCup->setMinTemp(query.value("minTemp").toInt());
        coffeeCup->setMaxTemp(query.value("maxTemp").toInt());
        coffeeCup->setAvgTemp(query.value("avgTemp").toDouble());

        list->push_back(move(coffeeCup));
    }
    return list;
}












