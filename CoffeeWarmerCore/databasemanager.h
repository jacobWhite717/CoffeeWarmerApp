#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QString>
#include <memory>

//#inlcude "<...>dao.h"
#include "coffeecupdao.h"

class QSqlDatabase;
class QSqlQuery;

// database name
const QString DATABASE_FILENAME = "coffeeStats.db";

class DatabaseManager
{
public:
    static void debugQuery(const QSqlQuery& query);

    // singleton instance
    static DatabaseManager& instance();
    ~DatabaseManager();

protected:
    DatabaseManager(const QString& path = DATABASE_FILENAME);
    DatabaseManager& operator=(const DatabaseManager& rhs);

private:
    std::unique_ptr<QSqlDatabase> mDatabase;

public: // dao object declarations
    const CoffeeCupDao coffeeCupDao;
};

#endif // DATABASEMANAGER_H
