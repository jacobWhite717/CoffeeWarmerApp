#ifndef COFFEECUPMODEL_H
#define COFFEECUPMODEL_H

#include <QAbstractListModel>
#include <QHash>
#include <vector>
#include <memory>

#include "coffeewarmercore_global.h"
#include "coffeecup.h"
#include "databasemanager.h"

class COFFEEWARMERCORESHARED_EXPORT CoffeeCupModel : public QAbstractListModel
{
    Q_OBJECT
public:

    enum Roles {
        IdRole = Qt::UserRole + 1,
        DateRole,
        StartTimeRole,
        EndTimeRole,
        DurationRole,
        MinTempRole,
        MaxTempRole,
        AvgTempRole,
        TemperaturesRole
    };

    CoffeeCupModel(QObject* parent= 0);

    QModelIndex addRow(const CoffeeCup& coffeeCup); //create

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    QHash<int, QByteArray> roleNames() const override;

    //Q_INVOKABLE functions below
    Q_INVOKABLE void startNewCup();
    Q_INVOKABLE void endCurrentCup();
    Q_INVOKABLE void resetRecords(const QModelIndex& parent = QModelIndex());

    //GUI getter/setters for cahced cup
    Q_INVOKABLE QString getDate();
    Q_INVOKABLE QString getStartTime();
    Q_INVOKABLE int getMinTemp();
    Q_INVOKABLE int getMaxTemp();
    Q_INVOKABLE double getAvgTemp();
    Q_INVOKABLE void enterCurrentTemp(int currentTemp);

private: // helper function
    bool isIndexValid(const QModelIndex& index) const;

private:
    DatabaseManager& mDatabase;
    std::unique_ptr<std::vector<std::unique_ptr<CoffeeCup>>> mObjects;
    std::unique_ptr<CoffeeCup> mCurrentCup;
};

#endif // COFFEECUPMODEL_H
