#include "coffeecupmodel.h"

using namespace std;

CoffeeCupModel::CoffeeCupModel(QObject* parent) :
    QAbstractListModel(parent),
    mDatabase(DatabaseManager::instance()),
    mObjects(mDatabase.coffeeCupDao.rows()),
    mCurrentCup(new CoffeeCup)
{
}

QModelIndex CoffeeCupModel::addRow(const CoffeeCup& coffeeCup)
{
    int rowIndex = rowCount();

    beginInsertRows(QModelIndex(), rowIndex, rowIndex);
    unique_ptr<CoffeeCup> newCup(new CoffeeCup(coffeeCup));
    mDatabase.coffeeCupDao.addRow(*newCup);
    mObjects->push_back(move(newCup));
    endInsertRows();

    return index(rowIndex, 0);
}

int CoffeeCupModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mObjects->size();
}

QVariant CoffeeCupModel::data(const QModelIndex &index, int role) const
{
    if(!isIndexValid(index)) {
        return QVariant();
    }

    const CoffeeCup& coffeeCup = *mObjects->at(index.row());

    switch(role) {
    case Roles::IdRole:
        return coffeeCup.id();
        break;
    case Roles::DateRole:
        return coffeeCup.date();
        break;
    case Roles::StartTimeRole:
        return coffeeCup.startTime();
        break;
    case Roles::EndTimeRole:
        return coffeeCup.endTime();
        break;
    case Roles::DurationRole:
        return coffeeCup.duration();
        break;
    case Roles::MinTempRole:
        return coffeeCup.minTemp();
        break;
    case Roles::MaxTempRole:
        return coffeeCup.maxTemp();
        break;
    case Roles::AvgTempRole:
        return coffeeCup.avgTemp();
        break;
    default:
        return QVariant();
    }
}

bool CoffeeCupModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(!isIndexValid(index)) {
        return false;
    }

    CoffeeCup& coffeeCup = *mObjects->at(index.row());

    switch(role) {
    case Roles::IdRole:
        coffeeCup.setId(value.toInt());
        break;
    case Roles::DateRole:
        coffeeCup.setDate(value.toString());
        break;
    case Roles::StartTimeRole:
        coffeeCup.setStartTime(value.toString());
        break;
    case Roles::EndTimeRole:
        coffeeCup.setEndTime(value.toString());
        break;
    case Roles::DurationRole:
        coffeeCup.setDuration(value.toString());
        break;
    case Roles::MinTempRole:
        coffeeCup.setMinTemp(value.toInt());
        break;
    case Roles::MaxTempRole:
        coffeeCup.setMaxTemp(value.toInt());
        break;
    case Roles::AvgTempRole:
        coffeeCup.setAvgTemp(value.toDouble());
        break;
    default:
        break;
    }

    mDatabase.coffeeCupDao.updateRow(coffeeCup);
    emit dataChanged(index, index);
    return true;
}

QHash<int, QByteArray> CoffeeCupModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Roles::IdRole] = "id";
    roles[Roles::DateRole] = "date";
    roles[Roles::StartTimeRole] = "startTime";
    roles[Roles::EndTimeRole] = "endTime";
    roles[Roles::DurationRole] = "duration";
    roles[Roles::MinTempRole] = "minTemp";
    roles[Roles::MaxTempRole] = "maxTemp";
    roles[Roles::AvgTempRole] = "avgTemp";

    return roles;
}

void CoffeeCupModel::startNewCup()
{
    mCurrentCup->startCurrentCup();
}

void CoffeeCupModel::endCurrentCup()
{
    mCurrentCup->endCurrentCup();
    addRow(*mCurrentCup);
}

void CoffeeCupModel::resetRecords(const QModelIndex& parent)
{
    beginRemoveRows(parent, 0, rowCount()-1);
    mDatabase.coffeeCupDao.removeAllRows();
    mObjects->clear();
    endRemoveRows();
}

QString CoffeeCupModel::getDate()
{
    return mCurrentCup->date();
}

QString CoffeeCupModel::getStartTime()
{
    return mCurrentCup->startTime();
}

int CoffeeCupModel::getMinTemp()
{
    return mCurrentCup->minTemp();
}

int CoffeeCupModel::getMaxTemp()
{
    return mCurrentCup->maxTemp();
}

double CoffeeCupModel::getAvgTemp()
{
    return mCurrentCup->avgTemp();
}

void CoffeeCupModel::enterCurrentTemp(int currentTemp)
{
    mCurrentCup->enterCurrentTemp(currentTemp);
    mCurrentCup->updateTemps();
}

bool CoffeeCupModel::isIndexValid(const QModelIndex& index) const
{
    if (index.row() < 0 || index.row() >= rowCount() || !index.isValid()) {
        return false;
    }
    return true;
}


