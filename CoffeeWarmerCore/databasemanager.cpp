#include "databasemanager.h"

#include <QSqlDatabase>

#include <QSqlQuery>
#include <QDebug>
#include <QsqlError>

DatabaseManager& DatabaseManager::instance()
{
    static DatabaseManager singleton;
    return singleton;
}

DatabaseManager::DatabaseManager(const QString& path) :
    mDatabase(new QSqlDatabase(QSqlDatabase::addDatabase("QSQLITE"))),
    // database pointer connections
    coffeeCupDao(*mDatabase)
{
    mDatabase->setDatabaseName(path);

    bool openStatus = mDatabase->open();
    qDebug() << "Database Connection: " << (openStatus ? "OK" : "Error");

    //dao initializations
    coffeeCupDao.init();
}

DatabaseManager::~DatabaseManager()
{
    mDatabase->close();
}

void DatabaseManager::debugQuery(const QSqlQuery& query)
{
    if (query.lastError().type() == QSqlError::ErrorType::NoError) {
        qDebug() << "Query OK:"  << query.lastQuery();
    } else {
       qWarning() << "Query KO:" << query.lastError().text();
       qWarning() << "Query text:" << query.lastQuery();
    }
}
