#ifndef COFFEECUPDAO_H
#define COFFEECUPDAO_H

#include <memory>
#include <vector>

class QSqlDatabase;
class CoffeeCup;

class CoffeeCupDao
{
public:
    CoffeeCupDao(QSqlDatabase& database);
    void init() const;

    void addRow(CoffeeCup& coffeeCup) const;
    void updateRow(const CoffeeCup& coffeeCup) const;
    void removeRow(int id) const;
    void removeAllRows() const;

    std::unique_ptr<std::vector<std::unique_ptr<CoffeeCup>>> rows() const;

private:
    QSqlDatabase& mDatabase;

};

#endif // COFFEECUPDAO_H
