# cpuInformation
This project consists of code for reading processor information on a Linux machine from the file “/proc/cpuinfo”. The integration of a QObject based C++ class into QML has been done by using QAbstractListModel and by setting an object as context property.

ListView is used in QML to display the data. The model for ListView is the class derived from QAbstractListModel.  This code specifically for C++ QML integration has been taken from an open source project (https://github.com/andytolst/cpuinfo). The code for displaying the data has been derived from the QtQuick examples present in the Qt QML documentation.

The shows a simple list of processors present in the system and their details, which can be refreshed on demand.
