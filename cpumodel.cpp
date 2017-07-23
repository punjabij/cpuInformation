#include "cpumodel.h"
#include "globalconstants.h"

#include <QFile>
#include <QTextStream>
#include <QDebug>

CPUModel::CPUModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

void CPUModel::populateModel()
{

    // Begins a model reset operation.
    emit beginResetModel();
    qDebug() << "populate";

    m_roleNames.clear();
    m_data.clear();

    QFile file(CPUINFO_FILE);
    file.open(QIODevice::ReadOnly);
    QTextStream stream(&file);

    // read cpuinfo line by line
    QString line = stream.readLine();

    // cpuNum points to a current processor section inside cpuinfo
    int cpuNum = -1;

    while (!line.isNull()) {
        if (line.isEmpty()) {
            line = stream.readLine();
            continue;
        }

        QStringList keyValue = line.split(':');

        if (keyValue.count() > 0) {
            QString keyString = keyValue.at(0).trimmed();
            QByteArray key = keyString.replace(' ','_').toLatin1();
            if (!m_roleNames.values().contains(key)) {
                m_roleNames.insert(Qt::UserRole + m_roleNames.count() + 1, key);
            }

            if (keyValue.count() == 2) {
                QString value = keyValue.at(1).trimmed();
                // starting new processor section
                if (keyString == PROCESSOR_TAG) {
                    cpuNum++;
                    m_data.append(QMap<QString,QString>());
                }

                if (cpuNum >= m_data.count()) {
                    qWarning() << "CPU core" << cpuNum << "not inserted";
                } else {
                    m_data[cpuNum].insert(keyString, value);
                }
            } else {
                qWarning() << "Unexpected format:" << line;
            }
        }

        line = stream.readLine();
    }

    file.close();

    // Ends a model reset operation.
    emit endResetModel();
}

int CPUModel::rowCount(const QModelIndex & /*parent*/) const
{
    return m_data.count();
}

QVariant CPUModel::data(const QModelIndex & index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count() || !m_roleNames.contains(role)) {
        return QVariant();
    }

    return m_data.at(index.row()).value(m_roleNames.value(role));
}

QHash<int, QByteArray> CPUModel::roleNames() const
{
    return m_roleNames;
}

QString CPUModel::prettyFormat(int index) const
{
    qDebug() << "index" << index;
    QString result;
    if (index < 0 || index >= m_data.count()) {
        return result;
    }

    QList<QByteArray> keys = m_roleNames.values();
    qSort(keys);
    foreach (const QByteArray& key, keys) {
        result.append("<b>" + key + "</b>");
        result.append(" : ");
        result.append(m_data.at(index).value(key));
        result.append("<br>");
    }

    return result;
}
