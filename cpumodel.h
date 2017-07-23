#ifndef CPUMODEL_H
#define CPUMODEL_H



#include <QAbstractListModel>
#include <QStringList>

/*!
 * \brief The CPUModel class
 * This class contains the list model for processor information extracted from
 * '/proc/cpuinfo' file in a Linux system. The class is derived from QAbstractListModel
 */


class CPUModel : public QAbstractListModel
{
    Q_OBJECT

public:
    CPUModel(QObject *parent = 0);

    /*!
     *  populates model from cpuinfo file
     */

    Q_INVOKABLE void populateModel();

    /*!
     * returns a complete string for a given index as key:value pairs
     * @ index index of the list containing the key:value pairs
     */
    Q_INVOKABLE QString prettyFormat(int index) const;


private:
    /*!
     *  from QAbstractListModel
     */
    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    /*!
     *  from QAbstractListModel
     */
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    /*!
     *  from QAbstractListModel
     */
    QHash<int, QByteArray> roleNames() const;

    /*!
     *  stores data as key:value map for each logical CPU core
     */
    QList<QMap<QString, QString> > m_data;

    /*!
     *  role names for the model
     */
    QHash<int, QByteArray> m_roleNames;


};

#endif // CPUMODEL_H
